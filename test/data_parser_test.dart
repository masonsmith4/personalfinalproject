import 'package:test/test.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/data_parser.dart';
import 'dart:io';

void main() {
  test('Matches the puuid with the player', () async {
    final playerData = await File('test/sample_data.json').readAsString();
    final identifier = DataParser();
    final player = identifier.searchPlayerId(playerData,
        'nvPdRr7ZMzx5uMWQ9Wj90K5KtekgFysWazHv6BTXScrt-5lDO6YXI-VzBpSkQT7q01aw-hq63nOR2A');
    expect(player, isNotNull);
    expect(player!['puuid'],
        equals('nvPdRr7ZMzx5uMWQ9Wj90K5KtekgFysWazHv6BTXScrt-5lDO6YXI-VzBpSkQT7q01aw-hq63nOR2A')
    );
  });

  test("Gets the player's character info", () async {
    final playerData = await File('test/sample_data.json').readAsString();
    final identifier = DataParser();
    final player = identifier.searchPlayerId(playerData,
        'nvPdRr7ZMzx5uMWQ9Wj90K5KtekgFysWazHv6BTXScrt-5lDO6YXI-VzBpSkQT7q01aw-hq63nOR2A'
    );
    final playerCharacter = identifier.pullCharacterInfo(player);
    expect(player, isNotNull);
    expect(playerCharacter, isNotNull);
    expect(playerCharacter['championName'], 'Ornn');
    expect(playerCharacter['champLevel'], 14);
    expect(playerCharacter['champExperience'], 12569);
  });
}