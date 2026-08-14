import 'package:lello/feature/space/reservation/data/model/reservation_summary_model.dart';

abstract class ReservationSummaryLocalDataSource {
	Future<List<ReservationSummaryModel>> list(String condominiumId, DateTime periodStart, DateTime periodEnd);
	Future<List<ReservationSummaryModel>> save(String condominiumId, List<ReservationSummaryModel> data);
}