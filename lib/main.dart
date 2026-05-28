import 'package:apptransaccional/app.dart';
import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.init();
  runApp(const App());
}
