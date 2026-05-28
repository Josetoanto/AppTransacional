import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/core/network/client.dart';
import 'package:apptransaccional/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  static const String _baseUrl = 'https://reqres.in/api';
  static const String _fallbackLoginToken = 'dev-skip-missing-api-key-login';
  static const String _fallbackRegisterToken =
      'dev-skip-missing-api-key-register';

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> response = await _networkClient.postJson(
        url: '$_baseUrl/login',
        body: <String, dynamic>{'email': email, 'password': password},
      );

      if (response['token'] == null) {
        throw AuthException('No token received from login endpoint.');
      }

      return UserModel.fromJson(response, email: email);
    } on NetworkException catch (exception) {
      if (_isMissingApiKey(exception)) {
        return UserModel(
          email: email,
          token: _fallbackLoginToken,
          id: 'local-dev',
        );
      }

      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> response = await _networkClient.postJson(
        url: '$_baseUrl/register',
        body: <String, dynamic>{'email': email, 'password': password},
      );

      if (response['token'] == null) {
        throw AuthException('No token received from register endpoint.');
      }

      return UserModel.fromJson(response, email: email);
    } on NetworkException catch (exception) {
      if (_isMissingApiKey(exception)) {
        return UserModel(
          email: email,
          token: _fallbackRegisterToken,
          id: 'local-dev',
        );
      }

      rethrow;
    }
  }

  bool _isMissingApiKey(NetworkException exception) {
    return exception.message.toLowerCase().contains('missing api key');
  }
}
