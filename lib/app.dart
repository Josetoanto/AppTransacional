import 'package:apptransaccional/features/auth/presentation/pages/login_page.dart';
import 'package:apptransaccional/features/auth/presentation/pages/register_page.dart';
import 'package:apptransaccional/features/hilos/presentation/pages/home_page.dart';
import 'package:apptransaccional/shared/constants/app_constants.dart';
import 'package:apptransaccional/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppConfig {
  const AppConfig({this.environment = 'dev'});

  final String environment;
}

class App extends StatelessWidget {
  const App({super.key, this.appConfig});

  final AppConfig? appConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppConstants.routeLogin,
      routes: {
        AppConstants.routeLogin: (_) => const LoginPage(),
        AppConstants.routeRegister: (_) => const RegisterPage(),
        AppConstants.routeHome: (_) => const HomePage(),
      },
    );
  }
}
