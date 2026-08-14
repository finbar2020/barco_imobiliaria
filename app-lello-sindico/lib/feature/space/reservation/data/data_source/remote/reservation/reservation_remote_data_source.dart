import 'package:lello/feature/space/reservation/data/model/reservation_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_data_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_detail_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_result_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_registration_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_response_model.dart';
import 'package:lello/feature/space/reservation/data/model/space_available_hours_model.dart';

abstract class ReservationRemoteDataSource {
  Future<List<SpaceAvailableHoursModel>> list(
    String condominiumId, {
    required String spaceId,
    String? unitId,
    required DateTime date,
  });

  Future<List<ReservationResponseModel>> listAllReservations(
    String condominiumId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<void> delete(
      String condominiumId, String reservationId, String? reservationType);
  Future<ReservationModel> insertMaintenance(
      String condominiumId, ReservationRegistrationModel model);
  Future<String> insertReservation(
      String condominiumId, ReservationRegistrationModel model);
  Future<ReservationModel> insertRaffle(
      String condominiumId,
      ReservationRegistrationModel registration,
      ReservationRaffleDataModel data);

  Future<ReservationRaffleDetailModel> selectRaffleDetail(
      String condominiumId, String spaceId, String reservationId);
  Future<ReservationRaffleResultModel> insertRaffleExecution(
      String condominiumId, String spaceId, String reservationId);

  Future<String> cancelReservation(
      String condominiumId, String reservationId, String? reservationType);
}
