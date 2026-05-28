import 'package:apptransaccional/features/auth/domain/entities/user.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';

class LoginUser {
  LoginUser(this._authRepository);

  final AuthRepository _authRepository;

  Future<User> call({
    required String email,
    required String password,
  }) {
    return _authRepository.login(email: email, password: password);
  }
}
