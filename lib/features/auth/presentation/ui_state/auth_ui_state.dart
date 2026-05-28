import 'package:apptransaccional/features/auth/domain/entities/user.dart';

enum AuthStatus { idle, loading, success, error }

class AuthUiState {
  const AuthUiState._({
    required this.status,
    this.user,
    this.message,
  });

  factory AuthUiState.idle() => const AuthUiState._(status: AuthStatus.idle);

  factory AuthUiState.loading() =>
      const AuthUiState._(status: AuthStatus.loading);

  factory AuthUiState.success(User user) =>
      AuthUiState._(status: AuthStatus.success, user: user);

  factory AuthUiState.error(String message) =>
      AuthUiState._(status: AuthStatus.error, message: message);

  final AuthStatus status;
  final User? user;
  final String? message;
}
