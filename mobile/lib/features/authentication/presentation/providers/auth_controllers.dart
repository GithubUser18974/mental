import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/authentication/data/repositories/auth_repository_impl.dart';

/// Form submission state shared by the auth screens: idle/success = `AsyncData`,
/// in flight = `AsyncLoading`, failure = `AsyncError(AppException)`.
typedef SubmitState = AsyncValue<void>;

final NotifierProvider<LoginController, SubmitState> loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, SubmitState>(
      LoginController.new,
    );

class LoginController extends Notifier<SubmitState> {
  @override
  SubmitState build() => const AsyncData(null);

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(authSessionProvider.notifier)
          .signIn(session.token, expiresAt: session.expiresAt);
    });
    if (ref.mounted) state = result;
  }
}

final NotifierProvider<RegisterController, SubmitState> registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, SubmitState>(
      RegisterController.new,
    );

class RegisterController extends Notifier<SubmitState> {
  @override
  SubmitState build() => const AsyncData(null);

  Future<void> submit({
    required String email,
    required String password,
    required bool ageConfirmed,
    required bool termsAccepted,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .register(
            email: email,
            password: password,
            ageConfirmed: ageConfirmed,
            termsAccepted: termsAccepted,
          );
      await ref
          .read(authSessionProvider.notifier)
          .signIn(session.token, expiresAt: session.expiresAt);
    });
    if (ref.mounted) state = result;
  }
}

final NotifierProvider<ForgotPasswordController, SubmitState> forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, SubmitState>(
      ForgotPasswordController.new,
    );

class ForgotPasswordController extends Notifier<SubmitState> {
  @override
  SubmitState build() => const AsyncData(null);

  Future<void> submit(String email) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).requestPasswordReset(email),
    );
    if (ref.mounted) state = result;
  }
}

final NotifierProvider<ResetPasswordController, SubmitState> resetPasswordControllerProvider =
    NotifierProvider.autoDispose<ResetPasswordController, SubmitState>(
      ResetPasswordController.new,
    );

class ResetPasswordController extends Notifier<SubmitState> {
  @override
  SubmitState build() => const AsyncData(null);

  Future<void> submit({
    required String email,
    required String token,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .resetPassword(email: email, token: token, password: password),
    );
    if (ref.mounted) state = result;
  }
}
