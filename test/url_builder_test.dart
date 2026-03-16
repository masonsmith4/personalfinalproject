import 'package:test/test.dart';

void main() {
  test('Builds URL for the PUUID', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildUrl();
    final uri = constructor.buildUrl('WombatBaby', 'NA2');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains('username'));
    expect(uri.path, contains('tag'));
    expect(uri.path, contains('WombatBaby'));
    expect(uri.path, contains('NA2'));
  });
}