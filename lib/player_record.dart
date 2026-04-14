class PlayerRecord {
  final String puuid;
  final String username;
  final String championName;
  final int championLevel;
  final int championExperience;
  final int kills;
  final int deaths;
  final double kda;
  final double damagePerMinute;

  const PlayerRecord({
    required this.puuid,
    required this.username,
    required this.championName,
    required this.championLevel,
    required this.championExperience,
    required this.kills,
    required this.deaths,
    required this.kda,
    required this.damagePerMinute,
  });
}