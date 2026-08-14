import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/data/data_source/remote/space_api.dart';
import 'package:lello/feature/space/data/data_source/remote/space_type_remote_data_source.dart';
import 'package:lello/feature/space/data/model/space_type_model.dart';

class SpaceTypeRemoteDataSourceImpl extends SpaceTypeRemoteDataSource {
  final SpaceApi api;

  SpaceTypeRemoteDataSourceImpl({required this.api});

  @override
  Future<List<SpaceTypeModel>> list(String condominiumId) async {
    final response = await api.listTypes(condominiumId);
    return ApiMapper.mapList(response, (json) => SpaceTypeModel.fromJson(json));
  }
}
