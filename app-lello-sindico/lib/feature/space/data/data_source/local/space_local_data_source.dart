import 'package:lello/feature/space/data/model/space_model.dart';

abstract class SpaceLocalDataSource {
	Future<List<SpaceModel>> list(String condominiumId);
	Future<List<SpaceModel>> insert(String condominiumId, List<SpaceModel> data);
}