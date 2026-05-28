import 'package:flutter_test/flutter_test.dart';

import 'package:apptransaccional/app.dart';

void main() {
  testWidgets('App starts on login placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Login'), findsOneWidget);
  });
}
