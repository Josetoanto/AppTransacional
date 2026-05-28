import 'package:apptransaccional/features/auth/domain/entities/user.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';
import 'package:apptransaccional/features/auth/domain/usecases/login_user.dart';
import 'package:apptransaccional/features/auth/domain/usecases/register_user.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';
import 'package:apptransaccional/features/auth/presentation/ui_state/auth_ui_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<User> login({required String email, required String password}) async {
    return User(email: email, token: 'login-token', id: '10');
  }

  @override
  Future<User> register({required String email, required String password}) async {
    return User(email: email, token: 'register-token', id: '20');
  }
}

void main() {
  group('AuthProvider', () {
    test('login updates state to success', () async {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(
        LoginUser(repository),
        RegisterUser(repository),
      );

      await provider.login(email: 'eve.holt@reqres.in', password: 'cityslicka');

      expect(provider.state.status, AuthStatus.success);
      expect(provider.state.user?.token, 'login-token');
    });

    test('register updates state to success', () async {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(
        LoginUser(repository),
        RegisterUser(repository),
      );

      await provider.register(
        email: 'eve.holt@reqres.in',
        password: 'cityslicka',
      );

      expect(provider.state.status, AuthStatus.success);
      expect(provider.state.user?.token, 'register-token');
    });
  });
}
