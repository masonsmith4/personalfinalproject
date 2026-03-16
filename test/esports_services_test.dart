import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

void main() {
  final service = EsportsService();

  test('parses puuid from identification response', () async {
    final puuid = service.parseIdentification(
        '{"puuid":"TestId46507","gameName":"WombatBaby","tagLine":"NA2"}');
    expect(puuid, equals('TestId46507'));
  });
  test('parses match id list from match list response', () async {
    final matches = service.parseMatchList(
        '["NA1_match001","NA1_match002","NA1_match003"]');
    expect(matches, equals(['NA1_match001', 'NA1_match002', 'NA1_match003']));
  });
}