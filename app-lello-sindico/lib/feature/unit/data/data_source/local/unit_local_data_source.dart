import 'package:lello/feature/unit/data/model/unit_model.dart';

abstract class UnitLocalDataSource {
	Future<List<UnitModel>> list(String condominiumId);
	Future<List<UnitModel>> insert(String condominiumId, List<UnitModel> data);
	Future<void> clear();
}