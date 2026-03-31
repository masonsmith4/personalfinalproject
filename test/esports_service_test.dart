import 'package:test/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  test('Check that network is running', () async {
    final service = EsportsService();
    final puuid = await service.requestIdentification('WombatBaby', 'NA2');

    expect(puuid, isNotEmpty);
  });
}