import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

void main() {
  test ('Check that network is running', () async {
    final network = EsportsService();
    final puuid = await network.requestIdentification('WombatBaby', 'NA2');

    expect(puuid, isNotEmpty);
  });
}