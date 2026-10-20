import '../domain/models/alert.dart';
import '../domain/models/harvest.dart';
import '../domain/models/hive.dart';
import '../domain/repositories/queenbee_repository.dart';

class FakeQueenBeeRepository implements QueenBeeRepository {
  final List<HiveModel> _hives = [
    HiveModel(
      id: 'hive-01',
      name: 'Ruche A-01',
      site: 'Dakar - Keur Massar',
      healthScore: 92,
      weightKg: 48.6,
      temperature: 34.2,
      risk: HiveRisk.low,
      lastInspection: DateTime(2027, 3, 14, 8, 15),
    ),
    HiveModel(
      id: 'hive-02',
      name: 'Ruche A-02',
      site: 'Dakar - Keur Massar',
      healthScore: 68,
      weightKg: 39.1,
      temperature: 36.8,
      risk: HiveRisk.medium,
      lastInspection: DateTime(2027, 3, 13, 16, 40),
    ),
    HiveModel(
      id: 'hive-03',
      name: 'Ruche A-03',
      site: 'Dakar - Keur Massar',
      healthScore: 41,
      weightKg: 31.4,
      temperature: 38.1,
      risk: HiveRisk.high,
      lastInspection: DateTime(2027, 3, 14, 7, 55),
    ),
  ];

  final List<AlertModel> _alerts = [
    AlertModel(
      title: 'Activité atypique détectée',
      hiveName: 'Ruche A-03',
      description: 'Une visite anticipée est recommandée dans les 24 heures.',
      severity: AlertSeverity.critical,
      createdAt: DateTime(2027, 3, 14, 9, 5),
    ),
    AlertModel(
      title: 'Température élevée',
      hiveName: 'Ruche A-02',
      description: 'La température dépasse le seuil configuré depuis 15 minutes.',
      severity: AlertSeverity.warning,
      createdAt: DateTime(2027, 3, 14, 8, 30),
    ),
  ];

  final List<HarvestModel> _harvests = [
    HarvestModel(
      hiveName: 'Ruche A-01',
      quantityKg: 12.4,
      date: DateTime(2027, 3, 3),
      status: HarvestStatus.validated,
    ),
  ];

  int _pendingOperations = 3;
  DateTime? _lastSync = DateTime(2027, 3, 14, 8, 15);

  @override
  List<HiveModel> getHives() => List.unmodifiable(_hives);

  @override
  List<AlertModel> getAlerts() => List.unmodifiable(_alerts);

  @override
  List<HarvestModel> getHarvests() => List.unmodifiable(_harvests);

  @override
  int get pendingOperations => _pendingOperations;

  @override
  DateTime? get lastSync => _lastSync;

  @override
  Future<void> saveInspection({
    required String hiveId,
    required String observation,
  }) async {
    _pendingOperations++;
  }

  @override
  Future<void> saveHarvest({
    required String hiveId,
    required double quantityKg,
    required DateTime date,
  }) async {
    final hive = _hives.firstWhere((item) => item.id == hiveId);
    _harvests.insert(
      0,
      HarvestModel(
        hiveName: hive.name,
        quantityKg: quantityKg,
        date: date,
        status: HarvestStatus.declared,
      ),
    );
    _pendingOperations++;
  }

  @override
  Future<void> synchronize() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _pendingOperations = 0;
    _lastSync = DateTime.now();
  }
}
