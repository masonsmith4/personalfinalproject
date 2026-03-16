import 'dart:convert';

class DataParser {
  Map<String, dynamic>? searchPlayerId(String content, String playerId) {
    final decoded = jsonDecode(content);
    final listOfParticipants = decoded['info']['participants'];
    for (Map<String, dynamic> participant in listOfParticipants) {
      if (participant['puuid'] == playerId) {
        return participant;
      }
    }
    return null;
  }
}