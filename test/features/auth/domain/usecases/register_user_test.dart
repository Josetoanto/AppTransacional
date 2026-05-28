import 'package:apptransaccional/features/auth/domain/entities/user.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';
import 'package:apptransaccional/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<User> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<User> register({required String email, required String password}) async {
    return User(email: email, token: 'register-token', id: '2');
  }
}

void main() {
  test('RegisterUser delegates register to repository', () async {
    final repository = _FakeAuthRepository();
    final useCase = RegisterUser(repository);

    final user = await useCase(
      email: 'eve.holt@reqres.in',
      password: 'cityslicka',
    );

    expect(user.email, 'eve.holt@reqres.in');
    expect(user.token, 'register-token');
  });
}
