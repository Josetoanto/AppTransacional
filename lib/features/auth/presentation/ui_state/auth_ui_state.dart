import 'package:apptransaccional/features/auth/domain/entities/user.dart';

enum AuthStatus { idle, loading, success, error }

class AuthUiState {
  const AuthUiState._({
    required this.status,
    this.user,
    this.message,
  });

  const AuthUiState.idle() : this._(status: AuthStatus.idle);

  const AuthUiState.loading() : this._(status: AuthStatus.loading);

  const AuthUiState.success(User user)
    : this._(status: AuthStatus.success, user: user);

  const AuthUiState.error(String message)
    : this._(status: AuthStatus.error, message: message);

  final AuthStatus status;
  final User? user;
  final String? message;
}
