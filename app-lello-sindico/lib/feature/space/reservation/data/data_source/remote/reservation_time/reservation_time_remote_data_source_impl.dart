import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_time_model.dart';

class ReservationTimeRemoteDataSourceImpl
    extends ReservationTimeRemoteDataSource {
  final ReservationTimeApi api;

  ReservationTimeRemoteDataSourceImpl({required this.api});
  @override
  Future<List<ReservationTimeModel>> list(
      String condominiumId, String spaceId, DateTime date) async {
    final format = DateFormat("yyyy-MM-dd");
    final response = await api.get(condominiumId, spaceId, format.format(date));
    return ApiMapper.mapList(
        response, (json) => ReservationTimeModel.fromJson(json));
  }
}
