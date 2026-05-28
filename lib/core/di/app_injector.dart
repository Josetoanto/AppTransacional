import 'package:apptransaccional/core/network/client.dart';
import 'package:apptransaccional/features/auth/di/auth_di.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';

class AppInjector {
  AppInjector._();

  static bool _initialized = false;

  static late final NetworkClient _networkClient;
  static late final AuthProvider _authProvider;

  static NetworkClient get networkClient {
    _bootstrapIfNeeded();
    return _networkClient;
  }

  static AuthProvider get authProvider {
    _bootstrapIfNeeded();
    return _authProvider;
  }

  static Future<void> init() async {
    _bootstrapIfNeeded();
  }

  static void _bootstrapIfNeeded() {
    if (_initialized) {
      return;
    }

    _networkClient = NetworkClient();
    _authProvider = provideAuthProvider(networkClient: _networkClient);
    _initialized = true;
  }
}
