import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/url_builder.dart';

void main() {
  test('Builds URL for the PUUID', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildUrl('WombatBaby', 'NA2');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains('WombatBaby'));
    expect(uri.path, contains('NA2'));
  });

  test('Builds the list of match ids', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildMatchId('ThisisatestidIamjuststringingwordstogether'
        'withnorealpurpose');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains(
        'ThisisatestidIamjuststringingwordstogetherwithnorealpurpose'));
  });
}