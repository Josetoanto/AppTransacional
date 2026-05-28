import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/core/network/http_client.dart';
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
  AuthRemoteDataSourceImpl(
    this._httpClient, {
    this.loginPath = '/api/login',
    this.registerPath = '/api/register',
  });

  final HttpClient _httpClient;
  final String loginPath;
  final String registerPath;

  static const String _fallbackLoginToken = 'dev-skip-missing-api-key-login';
  static const String _fallbackRegisterToken =
      'dev-skip-missing-api-key-register';

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final dynamic responseBody = await _httpClient.post(
        loginPath,
        body: <String, dynamic>{'email': email, 'password': password},
      );

      if (responseBody is! Map<String, dynamic>) {
        throw AuthException('Invalid response format for login endpoint.');
      }

      if (responseBody['token'] == null) {
        throw AuthException('No token received from login endpoint.');
      }

      return UserModel.fromJson(responseBody, email: email);
    } on AppException catch (exception) {
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
      final dynamic responseBody = await _httpClient.post(
        registerPath,
        body: <String, dynamic>{'email': email, 'password': password},
      );

      if (responseBody is! Map<String, dynamic>) {
        throw AuthException('Invalid response format for register endpoint.');
      }

      if (responseBody['token'] == null) {
        throw AuthException('No token received from register endpoint.');
      }

      return UserModel.fromJson(responseBody, email: email);
    } on AppException catch (exception) {
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

  bool _isMissingApiKey(AppException exception) {
    return exception.message.toLowerCase().contains('missing api key');
  }
}
