import 'package:apptransaccional/app.dart';
import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.init(baseUrl: 'https://essentia.fun');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const App(),
    ),
  );
}
