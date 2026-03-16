import 'package:test/test.dart';

void main() {
  test('Builds URL for the PUUID', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildUrl();
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains('username'));
    expect(uri.path, contains('tag'));
  });
}