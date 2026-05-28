import 'package:apptransaccional/core/network/http_client.dart';
import 'package:apptransaccional/features/auth/di/auth_di.dart';
import 'package:apptransaccional/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';
import 'package:apptransaccional/features/hilos/di/hilos_di.dart';
import 'package:apptransaccional/features/hilos/data/datasources/hilos_remote_data_source.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';

class AppInjector {
  AppInjector._();

  static bool _initialized = false;
  static late final String _baseUrl;
  static String? _tokenSecret;

  static late final HttpClient _httpClient;
  static late final AuthRemoteDataSource _authRemoteDataSource;
  static late final HilosRemoteDataSource _hilosRemoteDataSource;
  static late final AuthProvider _authProvider;
  static late final HilosProvider _hilosProvider;

  static HttpClient get httpClient {
    _bootstrapIfNeeded();
    return _httpClient;
  }

  static AuthRemoteDataSource get authRemoteDataSource {
    _bootstrapIfNeeded();
    return _authRemoteDataSource;
  }

  static HilosRemoteDataSource get hilosRemoteDataSource {
    _bootstrapIfNeeded();
    return _hilosRemoteDataSource;
  }

  static AuthProvider get authProvider {
    _bootstrapIfNeeded();
    return _authProvider;
  }

  static HilosProvider get hilosProvider {
    _bootstrapIfNeeded();
    return _hilosProvider;
  }

  static Future<void> init({
    String baseUrl = 'https://essentia.fun',
    String? tokenSecret,
    Duration timeout = const Duration(seconds: 20),
    int retryCount = 1,
    String authLoginPath = '/api/login',
    String authRegisterPath = '/api/register',
    String hilosPath = '/api/hilos',
  }) async {
    if (_initialized) {
      return;
    }

    _baseUrl = baseUrl;
    _tokenSecret = tokenSecret;

    _httpClient = HttpClient.fromConfig(
      baseUrl: _baseUrl,
      tokenSecret: _tokenSecret,
      timeout: timeout,
      retryCount: retryCount,
    );

    _authRemoteDataSource = provideAuthRemoteDataSource(
      httpClient: _httpClient,
      loginPath: authLoginPath,
      registerPath: authRegisterPath,
    );
    _hilosRemoteDataSource = provideHilosRemoteDataSource(
      httpClient: _httpClient,
      hilosPath: hilosPath,
    );

    _authProvider = provideAuthProvider(
      authRemoteDataSource: _authRemoteDataSource,
    );
    _hilosProvider = provideHilosProvider(
      remoteDataSource: _hilosRemoteDataSource,
      currentUserIdResolver: () => _authProvider.state.user?.id,
    );
    _initialized = true;
  }

  static void _bootstrapIfNeeded() {
    if (!_initialized) {
      throw StateError(
        'AppInjector is not initialized. Call AppInjector.init(baseUrl: ...) first.',
      );
    }
  }
}
