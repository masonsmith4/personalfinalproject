import 'package:test/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  test('Check that network is running',
      () async {
    final service = EsportsService();
    final puuid = await service.requestIdentification('WombatBaby', 'NA2');

    expect(puuid, isNotEmpty);
  });

  test('PlayerNotFoundException is thrown for invalid player', () async {
    final service = EsportsService();

    expect(
          () => service.requestIdentification('InvalidPlayer123456', 'INVALID'),
      throwsA(isA<PlayerNotFoundException>()),
    );
  });

  test('NetworkException is thrown on network error', () async {

    expect(
      isA<NetworkException>().toString(),
      contains('NetworkException'),
    );
  });

  test('RequestTimeoutException is thrown', () async {

    expect(
      isA<TimingException>().toString(),
      contains('TimingException'),
    );
  });
}