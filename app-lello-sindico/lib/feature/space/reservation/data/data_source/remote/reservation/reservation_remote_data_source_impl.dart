import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_data_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_detail_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_result_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_registration_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_response_model.dart';
import 'package:lello/feature/space/reservation/data/model/space_available_hours_model.dart';

import '../../../../../data/data_source/remote/space_api.dart';

class ReservationRemoteDataSourceImpl extends ReservationRemoteDataSource {
  final ReservationApi api;
  final SpaceApi spaceApi;

  ReservationRemoteDataSourceImpl({required this.api, required this.spaceApi});

  @override
  Future<List<SpaceAvailableHoursModel>> list(
    String condominiumId, {
    required String spaceId,
    String? unitId,
    required DateTime date,
  }) async {
    final response = await spaceApi.getHours(
      condominiumId,
      spaceId,
      unitId: unitId,
      date: date,
    );

    final result = ApiMapper.mapList(
        response, (json) => SpaceAvailableHoursModel.fromJson(json));
    return result;
  }

  @override
  Future<List<ReservationResponseModel>> listAllReservations(
    String condominiumId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response =
        await api.getAllReservations(condominiumId, startDate, endDate);

    final result = ApiMapper.mapList(
        response, (json) => ReservationResponseModel.fromJson(json));
    return result;
  }

  @override
  Future<void> delete(String condominiumId, String reservationId,
      String? reservationType) async {
    await api.delete(condominiumId, reservationId, reservationType);
  }

  @override
  Future<String> cancelReservation(String condominiumId, String reservationId,
      String? reservationType) async {
    final response =
        await api.delete(condominiumId, reservationId, reservationType);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error ?? "";
    } else {
      return "";
    }
  }

  @override
  Future<ReservationModel> insertMaintenance(
      String condominiumId, ReservationRegistrationModel model) async {
    final response =
        await api.postMaintenance(condominiumId, model.spaceId!, model);
    return ApiMapper.map(response, (json) => ReservationModel.fromJson(json));
  }

  @override
  Future<String> insertReservation(
      String condominiumId, ReservationRegistrationModel model) async {
    final response =
        await api.postReservations(condominiumId, model.spaceId!, model);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error ?? "";
    } else {
      return "";
    }
  }

  @override
  Future<ReservationModel> insertRaffle(
      String condominiumId,
      ReservationRegistrationModel model,
      ReservationRaffleDataModel data) async {
    final response = await api.postRaffles(condominiumId, model.spaceId!, data);
    return ApiMapper.map(response, (json) => ReservationModel.fromJson(json));
  }

  @override
  Future<ReservationRaffleDetailModel> selectRaffleDetail(
      String condominiumId, String spaceId, String reservationId) async {
    final response = await api.getRaffle(condominiumId, spaceId, reservationId);
    return ApiMapper.map(
        response, (json) => ReservationRaffleDetailModel.fromJson(json));
  }

  @override
  Future<ReservationRaffleResultModel> insertRaffleExecution(
      String condominiumId, String spaceId, String reservationId) async {
    final response =
        await api.postRaffleExecution(condominiumId, spaceId, reservationId);
    return ApiMapper.map(
        response, (json) => ReservationRaffleResultModel.fromJson(json));
  }
}
