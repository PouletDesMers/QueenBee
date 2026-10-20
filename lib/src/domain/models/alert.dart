enum AlertSeverity { info, warning, critical }

class AlertModel {
  const AlertModel({
    required this.title,
    required this.hiveName,
    required this.description,
    required this.severity,
    required this.createdAt,
  });

  final String title;
  final String hiveName;
  final String description;
  final AlertSeverity severity;
  final DateTime createdAt;
}
