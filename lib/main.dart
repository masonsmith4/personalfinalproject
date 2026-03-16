import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/data_parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(() {
    HttpOverrides.global = _DevHttpOverrides();
    return true;
  }());
  await dotenv.load(fileName: '.env');
  runApp(const MaterialApp(home: EligibilityScreen()));
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  final _usernameController = TextEditingController();
  final _tagController = TextEditingController();
  final _service = EsportsService();
  final _parser = DataParser();

  bool _loading = false;
  String? _message;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _charInfo;

  Future<void> _lookup() async {
    setState(() {
      _loading = true;
      _message = null;
      _stats = null;
      _charInfo = null;
    });

    try {
      final puuid = await _service.requestIdentification(
          _usernameController.text.trim(), _tagController.text.trim());
      final matchIds = await _service.requestMatchList(puuid);
      final matchData = await _service.requestMatchData(matchIds.first);
      final participant = _parser.searchPlayerId(jsonEncode(matchData), puuid)!;

      setState(() {
        _stats = _parser.pullGameStatistics(participant);
        _charInfo = _parser.pullCharacterInfo(participant);
        _message =
        'To enter the Spring Invitational, your KDA must be above 2.0.';
      });
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }
}