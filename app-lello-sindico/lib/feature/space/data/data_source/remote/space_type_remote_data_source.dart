import 'package:lello/feature/space/data/model/space_type_model.dart';

abstract class SpaceTypeRemoteDataSource {
	Future<List<SpaceTypeModel>> list(String condominiumId);
}