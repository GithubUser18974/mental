/// The signed-in user's private account (never shown to other members).
class Account {
  const Account({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.status,
  });

  final String id;
  final String email;
  final bool emailVerified;
  final String status;
}

/// Result of register / login / refresh.
class AuthSessionToken {
  const AuthSessionToken({required this.token, required this.expiresAt, required this.account});

  final String token;
  final DateTime expiresAt;
  final Account account;
}
