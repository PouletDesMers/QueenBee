enum HarvestStatus { declared, validated, rejected }

class HarvestModel {
  const HarvestModel({
    required this.hiveName,
    required this.quantityKg,
    required this.date,
    required this.status,
  });

  final String hiveName;
  final double quantityKg;
  final DateTime date;
  final HarvestStatus status;
}
