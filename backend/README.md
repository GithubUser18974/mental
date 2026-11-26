# Backend — Laravel API

Laravel 13 · PHP 8.4 · PostgreSQL 16 · Redis 7. Everything runs in Docker; no local PHP needed.

## Run

```sh
cd backend
docker compose up -d --build        # app, nginx, queue, scheduler, postgres, redis
docker compose exec app composer install
cp .env.example .env                # first time only
docker compose exec app php artisan key:generate   # first time only
docker compose exec app php artisan migrate
```

API: http://localhost:8000/api/v1 — health check: `GET /api/v1/health`

| Service | Host port |
|---|---|
| API (nginx) | 8000 |
| Swagger UI (`docs/openapi/openapi.json`) | 8080 |
| PostgreSQL (`mental` / `mental_test`) | 54320 |
| Redis | 63790 |

## Quality checks

```sh
docker compose exec app composer lint      # Pint (check only)
docker compose exec app composer format    # Pint (fix)
docker compose exec app composer analyse   # Larastan level 8
docker compose exec app composer test      # Pest (uses mental_test DB)
docker compose exec app composer ci        # all of the above + composer audit
```
