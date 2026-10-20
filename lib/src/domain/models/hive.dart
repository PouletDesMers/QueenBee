enum HiveRisk { low, medium, high }

class HiveModel {
  const HiveModel({
    required this.id,
    required this.name,
    required this.site,
    required this.healthScore,
    required this.weightKg,
    required this.temperature,
    required this.risk,
    required this.lastInspection,
  });

  final String id;
  final String name;
  final String site;
  final int healthScore;
  final double weightKg;
  final double temperature;
  final HiveRisk risk;
  final DateTime lastInspection;
}
