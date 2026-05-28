import 'package:apptransaccional/core/network/http_client.dart';
import 'package:apptransaccional/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apptransaccional/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';
import 'package:apptransaccional/features/auth/domain/usecases/login_user.dart';
import 'package:apptransaccional/features/auth/domain/usecases/register_user.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';

AuthRemoteDataSource provideAuthRemoteDataSource({
  required HttpClient httpClient,
  String loginPath = '/api/login',
  String registerPath = '/api/register',
}) {
  return AuthRemoteDataSourceImpl(
    httpClient,
    loginPath: loginPath,
    registerPath: registerPath,
  );
}

AuthRepository provideAuthRepository({
  required AuthRemoteDataSource authRemoteDataSource,
}) {
  return AuthRepositoryImpl(authRemoteDataSource: authRemoteDataSource);
}

LoginUser provideLoginUser({required AuthRepository authRepository}) {
  return LoginUser(authRepository);
}

RegisterUser provideRegisterUser({required AuthRepository authRepository}) {
  return RegisterUser(authRepository);
}

AuthProvider provideAuthProvider({
  required AuthRemoteDataSource authRemoteDataSource,
}) {
  final authRepository = provideAuthRepository(
    authRemoteDataSource: authRemoteDataSource,
  );
  final loginUser = provideLoginUser(authRepository: authRepository);
  final registerUser = provideRegisterUser(authRepository: authRepository);

  return AuthProvider(loginUser, registerUser);
}
