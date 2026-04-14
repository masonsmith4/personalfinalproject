import 'dart:convert';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/player_record.dart';

typedef Puuid = String;

class DataParser {
  /// Returns the [PlayerRecord] for the participant matching [puuid] in [content],
  /// with [username] set to the provided value.
  /// Returns null if no participant with the given [puuid] is found.
  PlayerRecord? playerByPuuid(
      String content, {
        required Puuid puuid,
        required String username,
      }) {
    final decoded = jsonDecode(content);
    final participants = decoded['info']['participants'] as List<dynamic>;
    for (final participant in participants) {
      if (participant['puuid'] == puuid) {
        return _toPlayerRecord(
          participant as Map<String, dynamic>,
          username: username,
        );
      }
    }
    return null;
  }

  PlayerRecord _toPlayerRecord(
      Map<String, dynamic> player, {
        required String username,
      }) {
    return PlayerRecord(
      puuid: player['puuid'] as String,
      username: username,
      championName: player['championName'] as String,
      championLevel: player['champLevel'] as int,
      championExperience: player['champExperience'] as int,
      kills: player['kills'] as int,
      deaths: player['deaths'] as int,
      kda: (player['challenges']['kda'] as num).toDouble(),
      damagePerMinute: (player['challenges']['damagePerMinute'] as num).toDouble(),
    );
  }
}