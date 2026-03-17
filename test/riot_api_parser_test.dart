import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/riot_api_parser.dart';

void main() {
  final parser = RiotApiParser();

  test('parses puuid from identification response', () {
    final puuid = parser.parseIdentification(
        '{"puuid":"TestId46507","gameName":"WombatBaby","tagLine":"NA2"}');
    expect(puuid, equals('TestId46507'));
  });

  test('parses match id list from match list response', () {
    final matches = parser.parseMatchList(
        '["NA1_match001","NA1_match002","NA1_match003"]');
    expect(matches, equals(['NA1_match001', 'NA1_match002', 'NA1_match003']));
  });

  test('parses match data from match response', () {
    final result = parser.parseMatchData('{"info":{"participants":[]}}');
    expect(result['info'], isNotNull);
  });
}