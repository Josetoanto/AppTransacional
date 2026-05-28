import 'package:apptransaccional/core/network/client.dart';
import 'package:apptransaccional/features/auth/di/auth_di.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';
import 'package:apptransaccional/features/hilos/di/hilos_di.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';

class AppInjector {
  AppInjector._();

  static bool _initialized = false;

  static late final NetworkClient _networkClient;
  static late final AuthProvider _authProvider;
  static late final HilosProvider _hilosProvider;

  static NetworkClient get networkClient {
    _bootstrapIfNeeded();
    return _networkClient;
  }

  static AuthProvider get authProvider {
    _bootstrapIfNeeded();
    return _authProvider;
  }

  static HilosProvider get hilosProvider {
    _bootstrapIfNeeded();
    return _hilosProvider;
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
    _hilosProvider = provideHilosProvider(
      networkClient: _networkClient,
      currentUserIdResolver: () => _authProvider.state.user?.id,
    );
    _initialized = true;
  }
}
