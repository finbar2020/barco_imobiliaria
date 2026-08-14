import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:lello/feature/space/data/model/space_calendar_model.dart';

abstract class SpaceRemoteDataSource {
  Future<List<SpaceModel>> list(String condominiumId);
  Future<SpaceModel> insert(String condominiumId, SpaceModel model);
  Future<SpaceModel> update(String condominiumId, SpaceModel model);
  Future<SpaceCalendarModel> getCalendarDisponibility(String condominiumId,
      String spaceId, DateTime startDate, DateTime endTime);
}
