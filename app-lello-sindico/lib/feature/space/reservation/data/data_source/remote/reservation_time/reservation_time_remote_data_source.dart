import 'package:lello/feature/space/reservation/data/model/reservation_time_model.dart';

abstract class ReservationTimeRemoteDataSource {
	Future<List<ReservationTimeModel>> list(String condominiumId, String spaceId, DateTime date);
}