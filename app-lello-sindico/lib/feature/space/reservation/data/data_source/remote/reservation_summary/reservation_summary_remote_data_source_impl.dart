import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/data/model/space_calendar_model.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_remote_data_source.dart';

class ReservationSummaryRemoteDataSourceImpl
    extends ReservationSummaryRemoteDataSource {
  final ReservationSummaryApi api;

  ReservationSummaryRemoteDataSourceImpl({required this.api});

  @override
  Future<SpaceCalendarModel> list(String condominiumId, String spaceId,
      DateTime periodStart, DateTime periodEnd) async {
    final format = DateFormat('yyyy-MM-dd');

    final response = await api.get(condominiumId, spaceId,
        format.format(periodStart), format.format(periodEnd));
    return ApiMapper.map(response, (json) => SpaceCalendarModel.fromJson(json));
  }
}
