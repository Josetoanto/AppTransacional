import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:apptransaccional/features/auth/presentation/pages/login_page.dart';
import 'package:apptransaccional/features/auth/presentation/pages/register_page.dart';
import 'package:apptransaccional/features/hilos/presentation/pages/home_page.dart';
import 'package:apptransaccional/shared/constants/app_constants.dart';
import 'package:apptransaccional/shared/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppConfig {
  const AppConfig({this.environment = 'dev'});

  final String environment;
}

// StatelessWidget because App depends on external DI/config and does not keep local mutable state.
class App extends StatelessWidget {
  const App({super.key, this.appConfig});

  final AppConfig? appConfig;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppInjector.authProvider),
        ChangeNotifierProvider.value(value: AppInjector.hilosProvider),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: AppTheme.light,
        initialRoute: AppConstants.routeLogin,
        routes: {
          AppConstants.routeLogin: (_) => const LoginPage(),
          AppConstants.routeRegister: (_) => const RegisterPage(),
          AppConstants.routeHome: (_) => const HomePage(),
        },
      ),
    );
  }
}
