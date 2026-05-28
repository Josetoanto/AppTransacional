import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppInjector init builds reusable instances', () async {
    await AppInjector.init(baseUrl: 'https://essentia.fun');

    expect(AppInjector.httpClient, isNotNull);
    expect(AppInjector.authRemoteDataSource, isNotNull);
    expect(AppInjector.hilosRemoteDataSource, isNotNull);
    expect(AppInjector.authProvider, isNotNull);
    expect(AppInjector.hilosProvider, isNotNull);
  });
}
