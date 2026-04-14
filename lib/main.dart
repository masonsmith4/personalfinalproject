import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/player_record.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';

/// Returns a display-ready string for the given [stat] label, reading from [player].
String formattedStatRow(String stat, PlayerRecord player) {
  switch (stat) {
    case 'Champion': return player.championName;
    case 'Champion Level': return '${player.championLevel}';
    case 'Kills': return '${player.kills}';
    case 'Deaths': return '${player.deaths}';
    case 'KDA': return player.kda.toStringAsFixed(2);
    case 'Damage / Min': return player.damagePerMinute.toStringAsFixed(1);
    default: return '';
  }
}

const _statLabels = [
  'Champion',
  'Champion Level',
  'Kills',
  'Deaths',
  'KDA',
  'Damage / Min',
];

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
  static const int _maxPlayers = 6;
  final _usernameController = TextEditingController();
  final _tagController = TextEditingController();
  final _service = EsportsService();
  final _playerList = <PlayerRecord>[];

  bool _loading = false;
  String? _errorMessage;

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final player = await _service.requestPlayerData(
        _usernameController.text.trim(),
        _tagController.text.trim(),
      );
      setState(() => _playerList.add(player));
    } on PlayerNotFoundException catch (e) {
      setState(() => _errorMessage = e.message);
    } on NetworkException catch (e) {
      setState(() => _errorMessage = e.message);
    } on TimingException catch (e) {
      setState(() => _errorMessage = e.message);
    } on UnexpectedResultException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _clearPlayerList() {
    setState(() {
      _playerList.clear();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool atCapacity = _playerList.length >= _maxPlayers;
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Eligibility')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PlayerInputSection(
              hint: 'Try it with: WombatBaby, NA2',
              usernameController: _usernameController,
              tagController: _tagController,
            ),
            const SizedBox(height: 16),
            Text(
              'Players added: ${_playerList.length} / $_maxPlayers',
              style: TextStyle(
                color: atCapacity ? Colors.red : Colors.grey,
                fontWeight: atCapacity ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: (_loading || atCapacity) ? null : _search,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search Stats'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _StatsTable(players: _playerList),
                ),
              ),
            ),
            if (_playerList.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _clearPlayerList,
                child: const Text('Clear Player List'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerInputSection extends StatelessWidget {
  final String hint;
  final TextEditingController usernameController;
  final TextEditingController tagController;

  const _PlayerInputSection({
    required this.hint,
    required this.usernameController,
    required this.tagController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: tagController,
          decoration: const InputDecoration(labelText: 'Tag'),
        ),
      ],
    );
  }
}

class _StatsTable extends StatelessWidget {
  final List<PlayerRecord> players;

  const _StatsTable({required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return const SizedBox.shrink();

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        TableRow(
          children: [
            const SizedBox(),
            for (final player in players)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  player.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
          ],
        ),
        for (final stat in _statLabels)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(stat, style: const TextStyle(color: Colors.grey)),
              ),
              for (final player in players)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    formattedStatRow(stat, player),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}