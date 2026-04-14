import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/url_builder.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/riot_api_parser.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/data_parser.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/player_record.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Suite of Errors
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

class TimingException implements Exception {
  final String message;
  const TimingException (this.message);

  @override
  String toString() => message;
}

class PlayerNotFoundException implements Exception {
  final String message;
  const PlayerNotFoundException(this.message);

  @override
  String toString() => message;
}

class UnexpectedResultException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  UnexpectedResultException(
      this.message, {
  this.originalError,
  this.stackTrace,
});

  @override
  String toString() => message;
}

/// Provides access to the Riot Games API for match and account data.
class EsportsService {
  final _urlBuilder = UrlBuilder();
  final _parser = RiotApiParser();
  final _matchParser = DataParser();
  final _log = Logger();

  Map<String, String> get _headers =>
      {'X-Riot-Token': dotenv.env['RIOT_API_KEY'] ?? ''};

  /// Performs a request to [url], logging any network errors with a description.
  Future<http.Response> _get(Uri url, String context) async {
    try {
      return await http.get(url, headers: _headers);
    } on SocketException catch (e) {
      _log.e('Network error — $context', error: e);
      throw NetworkException(
          'Network error: please check your internet connection.');
    } on TimeoutException catch (e) {
      _log.e('Request timed out — $context', error: e);
      throw TimingException(
          'Request timed out: the server took too long to respond.');
    } catch (e, stack) {
      _log.e('Unexpected error — $context', error: e, stackTrace: stack);
      throw UnexpectedResultException(
        'Unexpected error: please try again.',
        originalError: e,
        stackTrace: stack,
      );
    }
  }
  /// Returns the [Puuid] of the account identified by [username] and [tag].
  /// Throws an [EsportsException] if the player could not be found.
  Future<Puuid> requestIdentification(String username, String tag) async {
    final response = await _get(_urlBuilder.buildUrl(username, tag), 'identification for $username#$tag');
    if (response.statusCode == 404) {
      throw PlayerNotFoundException('Player not found. Please check the username and tag.');
    }
    return _parser.parseIdentification(response.body);
  }

  /// Returns a list of recent match IDs for the account with the given [puuid].
  Future<List<String>> requestMatchList(Puuid puuid) async {
    final response = await _get(_urlBuilder.buildMatchId(puuid), 'match list for $puuid');
    return _parser.parseMatchList(response.body);
  }

  /// Returns the raw match data map for the match identified by [matchId].
  Future<Map<String, dynamic>> requestMatchData(String matchId) async {
    final response = await _get(_urlBuilder.buildMatchUrl(matchId), 'match data for $matchId');
    return _parser.parseMatchData(response.body);
  }

  /// Returns the [PlayerRecord] for the given [username] and [tag],
  /// populated from their most recent match.
  Future<PlayerRecord> requestPlayerData(String username, String tag) async {
    final puuid = await requestIdentification(username, tag);
    final matchIds = await requestMatchList(puuid);
    final matchData = await requestMatchData(matchIds.first);
    return _matchParser.playerByPuuid(
      jsonEncode(matchData),
      puuid: puuid,
      username: '$username $tag',
    )!;
  }
}