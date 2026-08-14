import 'package:lello/feature/resident/data/model/resident_model.dart';

abstract class ResidentLocalDataSource {
	Future<List<ResidentModel>> list(String condominiumId);
	Future<List<ResidentModel>> insert(String condominiumId, List<ResidentModel> data);
	Future<void> clear();
}