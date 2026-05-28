import 'package:apptransaccional/core/network/http_client.dart';

Future<void> main() async {
  final client = HttpClient.withTimeout(
    const Duration(seconds: 15),
    baseUrl: 'https://essentia.fun',
    retryCount: 1,
  );

  final response = await client.get('/health');

  if (response is! Map<String, dynamic>) {
    throw StateError('Health endpoint did not return a JSON object.');
  }

  final message = response['message'];
  if (message == null) {
    throw StateError('Health endpoint JSON does not include message.');
  }

  // ignore: avoid_print
  print('health.message=$message');
}
