import '../models/alert.dart';
import '../models/harvest.dart';
import '../models/hive.dart';

abstract interface class QueenBeeRepository {
  List<HiveModel> getHives();
  List<AlertModel> getAlerts();
  List<HarvestModel> getHarvests();
  int get pendingOperations;
  DateTime? get lastSync;

  Future<void> saveInspection({
    required String hiveId,
    required String observation,
  });

  Future<void> saveHarvest({
    required String hiveId,
    required double quantityKg,
    required DateTime date,
  });

  Future<void> synchronize();
}
