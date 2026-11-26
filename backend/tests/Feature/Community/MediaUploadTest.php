<?php

declare(strict_types=1);

use App\Modules\Community\Models\PostMedia;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    Storage::fake('local');
    // Non-static: Laravel binds this closure to the disk adapter.
    Storage::disk('local')->buildTemporaryUrlsUsing(
        fn (string $path, DateTimeInterface $expires): string => 'https://media.test/'.$path.'?expires='.$expires->getTimestamp(),
    );
    $this->me = AnonymousProfile::factory()->create();
    Sanctum::actingAs($this->me->user);
});

/** A real JPEG with an EXIF block carrying a fake GPS marker, like a phone photo. */
function jpegWithExif(string $marker): UploadedFile
{
    $img = imagecreatetruecolor(400, 300);
    ob_start();
    imagejpeg($img);
    $jpeg = (string) ob_get_clean();

    $payload = "Exif\0\0".$marker;
    $app1 = "\xFF\xE1".pack('n', strlen($payload) + 2).$payload;
    $withExif = substr($jpeg, 0, 2).$app1.substr($jpeg, 2); // insert right after SOI

    $path = tempnam(sys_get_temp_dir(), 'exif').'.jpg';
    file_put_contents($path, $withExif);

    return new UploadedFile($path, 'IMG_0001.jpg', 'image/jpeg', null, true);
}

it('stores a sanitized image privately and returns a signed, expiring URL', function (): void {
    $response = $this->post('/api/v1/media', ['image' => UploadedFile::fake()->image('photo.jpg', 800, 600)])
        ->assertCreated()
        ->assertJsonPath('data.width', 800)
        ->assertJsonPath('data.height', 600)
        ->assertJsonPath('data.mime', 'image/jpeg');

    $media = PostMedia::query()->sole();
    expect($media->uploader_profile_id)->toBe($this->me->id)
        ->and($media->post_id)->toBeNull()
        ->and($response->json('data.url'))->toStartWith('https://media.test/post-media/')
        ->and($response->json('data.url_expires_at'))->not->toBeNull();

    Storage::disk('local')->assertExists($media->path);
});

it('strips EXIF metadata such as GPS location', function (): void {
    $this->post('/api/v1/media', ['image' => jpegWithExif('GPSLatitude=30.0444;SECRET-DEVICE')])->assertCreated();

    $stored = Storage::disk('local')->get(PostMedia::query()->sole()->path);

    expect($stored)->not->toContain('SECRET-DEVICE')->not->toContain('Exif');
});

it('downscales very large images', function (): void {
    $this->post('/api/v1/media', ['image' => UploadedFile::fake()->image('big.jpg', 4000, 2000)])
        ->assertCreated()
        ->assertJsonPath('data.width', 2048)
        ->assertJsonPath('data.height', 1024);
});

it('keeps PNG transparency by storing WebP', function (): void {
    $this->post('/api/v1/media', ['image' => UploadedFile::fake()->image('art.png', 300, 300)])
        ->assertCreated()
        ->assertJsonPath('data.mime', 'image/webp');
});

it('rejects non-images, disguised files and tiny images', function (UploadedFile $file): void {
    $this->post('/api/v1/media', ['image' => $file], ['Accept' => 'application/json'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('image');

    expect(PostMedia::query()->count())->toBe(0);
})->with([
    'pdf' => fn () => UploadedFile::fake()->create('doc.pdf', 10, 'application/pdf'),
    'script named .jpg' => fn () => UploadedFile::fake()->createWithContent('evil.jpg', '<?php echo 1;'),
    'gif' => fn () => UploadedFile::fake()->image('anim.gif', 100, 100),
    'too small' => fn () => UploadedFile::fake()->image('dot.jpg', 10, 10),
]);

it('prunes uploads that were never attached', function (): void {
    $this->post('/api/v1/media', ['image' => UploadedFile::fake()->image('a.jpg', 100, 100)])->assertCreated();
    $media = PostMedia::query()->sole();
    $media->forceFill(['updated_at' => now()->subDays(2)])->saveQuietly();

    $this->artisan('community:prune-orphan-media')->assertSuccessful();

    expect(PostMedia::query()->count())->toBe(0);
    Storage::disk('local')->assertMissing($media->path);
});
