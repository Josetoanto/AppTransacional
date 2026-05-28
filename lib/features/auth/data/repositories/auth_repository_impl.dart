import 'package:apptransaccional/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apptransaccional/features/auth/domain/entities/user.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this._authRemoteDataSource});

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<User> login({required String email, required String password}) async {
    final userModel = await _authRemoteDataSource.login(
      email: email,
      password: password,
    );

    return userModel.toEntity();
  }

  @override
  Future<User> register({required String email, required String password}) async {
    final userModel = await _authRemoteDataSource.register(
      email: email,
      password: password,
    );

    return userModel.toEntity();
  }
}
