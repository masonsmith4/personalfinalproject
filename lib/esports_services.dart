import 'package:http/http.dart' as http;
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/url_builder.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/riot_api_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'

class EsportsService {
  final _urlBuilder = UrlBuilder();
  final _parser = RiotApiParser();

  Map<String, String> get _headers =>
      {'X-Riot-Token': dotenv.env['RIOT_API_KEY'] ?? ''};

  //Returns the puuid of the user as a String
  Future<String> requestIdentification(String username, String tag) async {
    final response = await http.get(_urlBuilder.buildUrl(username, tag), headers: _headers);
    return _parser.parseIdentification(response.body);
  }
  //Returns a list of match ids as Strings
  Future<List<String>> requestMatchList(String puuid) async {
    final response = await http.get(_urlBuilder.buildMatchId(puuid), headers: _headers);
    return _parser.parseMatchList(response.body);
  }
  //Returns a dictionary of data within the match
  //Key is a String, value can be either a String, int, or a float
  Future<Map<String, dynamic>> requestMatchData(String matchId) async {
    final response = await http.get(_urlBuilder.buildMatchUrl(matchId), headers: _headers);
    return _parser.parseMatchData(response.body);
  }
}