import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/url_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EsportsService {
  final _urlBuilder = UrlBuilder();

  String parseIdentification(String body) =>
      jsonDecode(body)['puuid'] as String;

  List<String> parseMatchList(String body) =>
      List<String>.from(jsonDecode(body));

  Map<String, dynamic> parseMatchData(String body) =>
      jsonDecode(body) as Map<String, dynamic>;
}