import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_api.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source.dart';
import 'package:morar/feature/reservation/data/model/reservation_registration_model.dart';
import 'package:morar/feature/reservation/data/model/reservation_scheduled_model.dart';
import 'package:morar/feature/reservation/data/model/space_available_hours_model.dart';
import 'package:morar/feature/reservation/data/model/space_calendar_model.dart';
import 'package:morar/feature/reservation/data/model/space_model.dart';

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final ReservationApi api;

  ReservationRemoteDataSourceImpl({required this.api});
  @override
  Future<List<SpaceModel>> getSpaces(String condominiumId) async {
    final response = await api.getSpaces(condominiumId);
    return ApiMapper.mapList(response, (json) => SpaceModel.fromJson(json));
  }

  @override
  Future<List<ReservationScheduledModel>> getAllReservationsScheduled(
      String condominiumId, String unitId) async {
    final response = await api.getReservations(condominiumId, unitId);
    return ApiMapper.mapList(
        response, (json) => ReservationScheduledModel.fromJson(json));
  }

  @override
  Future<SpaceCalendarModel> getCalendar(
    String condominiumId,
    String spaceId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    String insertNumber(String date) {
      if (date.length == 1) {
        return "0$date";
      } else {
        return date;
      }
    }

    final response = await api.getCalendar(
      condominiumId,
      spaceId,
      "${startDate.year}-${insertNumber(startDate.month.toString())}-${insertNumber(startDate.day.toString())}",
      "${endDate.year}-${insertNumber(endDate.month.toString())}-${insertNumber(endDate.day.toString())}",
    );
    return ApiMapper.map(response, (json) => SpaceCalendarModel.fromJson(json));
  }

  @override
  Future<List<SpaceAvailableHoursModel>> getHours(
    String condominiumId,
    String spaceId,
    DateTime date,
    String unitId,
  ) async {
    final response = await api.getHours(condominiumId, spaceId, date, unitId);
    return ApiMapper.mapList(
        response, (json) => SpaceAvailableHoursModel.fromJson(json));
  }

  @override
  Future<ReservationScheduledModel> postReservation(
    String condominiumId,
    String spaceId,
    ReservationRegistrationModel body,
  ) async {
    var reserve = {
      "flag_utility_term": body.flagUtilityTerm,
      "reservation_end_date": body.reservationEndDate,
      "reservation_start_date": body.reservationStartDate,
      "space_id": body.spaceId,
      "unit_id": body.unitId
    };
    final response =
        await api.postReservations(condominiumId, spaceId, reserve);
    return ApiMapper.map(
        response, (json) => ReservationScheduledModel.fromJson(json));
  }

  @override
  Future<String> deleteReservation(String condominiumId, String reservationId,
      String reservationType) async {
    final response = await api.deleteReservation(
        condominiumId, reservationId, reservationType);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "Sucesso";
    }
  }
}
