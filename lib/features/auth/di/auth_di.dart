import 'package:apptransaccional/core/network/client.dart';
import 'package:apptransaccional/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apptransaccional/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:apptransaccional/features/auth/domain/repos/auth_repository.dart';
import 'package:apptransaccional/features/auth/domain/usecases/login_user.dart';
import 'package:apptransaccional/features/auth/domain/usecases/register_user.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';

AuthRemoteDataSource provideAuthRemoteDataSource({
  required NetworkClient networkClient,
}) {
  return AuthRemoteDataSourceImpl(networkClient: networkClient);
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

AuthProvider provideAuthProvider({required NetworkClient networkClient}) {
  final authRemoteDataSource = provideAuthRemoteDataSource(
    networkClient: networkClient,
  );
  final authRepository = provideAuthRepository(
    authRemoteDataSource: authRemoteDataSource,
  );
  final loginUser = provideLoginUser(authRepository: authRepository);
  final registerUser = provideRegisterUser(authRepository: authRepository);

  return AuthProvider(loginUser, registerUser);
}
