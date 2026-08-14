import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/data/data_source/remote/space_api.dart';
import 'package:lello/feature/space/data/data_source/remote/space_remote_data_source.dart';
import 'package:lello/feature/space/data/model/space_calendar_model.dart';
import 'package:lello/feature/space/data/model/space_model.dart';

class SpaceRemoteDataSourceImpl extends SpaceRemoteDataSource {
  final SpaceApi api;

  SpaceRemoteDataSourceImpl({required this.api});
  @override
  Future<List<SpaceModel>> list(String condominiumId) async {
    final response = await api.get(condominiumId);
    return ApiMapper.mapList(response, (json) => SpaceModel.fromJson(json));
  }

  @override
  Future<SpaceModel> insert(String condominiumId, SpaceModel model) async {
    final response = await api.post(condominiumId, model);
    return ApiMapper.map(response, (json) => SpaceModel.fromJson(json));
  }

  @override
  Future<SpaceModel> update(String condominiumId, SpaceModel model) async {
    final response = await api.put(condominiumId, model.id!, model);
    return ApiMapper.map(response, (json) => SpaceModel.fromJson(json));
  }

  @override
  Future<SpaceCalendarModel> getCalendarDisponibility(String condominiumId,
      String spaceId, DateTime startDate, DateTime endTime) async {
    DateTime endDate = DateTime.now().add(Duration(days: 30));
    final response = await api.getCalendar(condominiumId, spaceId,
        endDate: endDate, startDate: DateTime.now());

    return ApiMapper.map(response, (json) => SpaceCalendarModel.fromJson(json));
  }
}
