import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptransaccional/app.dart';

void main() {
  testWidgets('App starts on login placeholder', (WidgetTester tester) async {
    await AppInjector.init(baseUrl: 'https://essentia.fun');
    await tester.pumpWidget(const App());

    expect(find.text('Login'), findsOneWidget);
  });
}
