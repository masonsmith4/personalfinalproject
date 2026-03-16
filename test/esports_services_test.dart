import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

void main() {
  final service = EsportsService();

  test('parses puuid from identification response', () async {
    final puuid = service.parseIdentification(
        '{"puuid":"TestId46507","gameName":"WombatBaby","tagLine":"NA2"}');
    expect(puuid, equals('TestId46507'));
  });