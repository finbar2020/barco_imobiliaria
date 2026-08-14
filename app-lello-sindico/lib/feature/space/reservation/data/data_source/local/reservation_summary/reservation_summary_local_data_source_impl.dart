import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/reservation_summary/reservation_summary_dao.dart';
import 'package:lello/feature/space/reservation/data/data_source/local/reservation_summary/reservation_summary_local_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_summary_model.dart';
import 'package:drift/drift.dart';

class ReservationSummaryLocalDataSourceImpl
    extends ReservationSummaryLocalDataSource {
  final ReservationSummaryDao dao;

  ReservationSummaryLocalDataSourceImpl({required this.dao});

  @override
  Future<List<ReservationSummaryModel>> list(
      String condominiumId, DateTime periodStart, DateTime periodEnd) async {
    final list = await dao.list(condominiumId, periodStart, periodEnd);
    final List<ReservationSummaryModel>? result = [];
    list.forEach((element) {
      ReservationSummaryModel? existingDay =
          result?.firstWhere((el) => el.day == element.day, orElse: null);
      if (existingDay == null) {
        existingDay = ReservationSummaryModel()
          ..day = element.day
          ..types = [];
        result!.add(existingDay);
      }
      existingDay.types!.add(element.type);
    });
    return result!;
  }

  @override
  Future<List<ReservationSummaryModel>> save(
      String condominiumId, List<ReservationSummaryModel> data) async {
    final List<ReservationSummaryTableCompanion> dataModels = [];
    data.forEach((e) {
      e.types!.forEach((type) {
        dataModels.add(ReservationSummaryTableCompanion(
            condominiumId: Value(condominiumId),
            day: Value(e.day!),
            type: Value(type)));
      });
    });
    await dao.insert(dataModels);
    return data;
  }
}
