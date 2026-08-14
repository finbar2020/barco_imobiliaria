import 'package:chopper/chopper.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_data_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_registration_model.dart';

part 'reservation_api.chopper.dart';

@ChopperApi()
abstract class ReservationApi extends ChopperService {
  @GET(path: "/condominiums/{id}/spaces/calendar/day/hours/{spaceId}")
  Future<Response> get(@Path("id") String condominiumId,
      @Path("spaceId") String spaceId, @Query("date") DateTime date);

  @GET(path: "/condominiums/{id}/reservations")
  Future<Response> getAllReservations(
      @Path("id") String condominiumId,
      @Query("start_date") DateTime? startDate,
      @Query("end_date") DateTime? endDate);

  @DELETE(
      path:
          "/condominiums/{id}/reservations/{reservation_id}/{reservation_type}")
  Future<Response> delete(
      @Path("id") String condominiumId,
      @Path("reservation_id") String reservationId,
      @Path("reservation_type") String? reservationType);

  @POST(path: "/condominiums/{id}/spaces/{space_id}/maintenances")
  Future<Response> postMaintenance(
      @Path("id") String condominiumId,
      @Path("space_id") String spaceId,
      @Body() ReservationRegistrationModel model);

  @POST(path: "/condominiums/{id}/spaces/{space_id}/reservations")
  Future<Response> postReservations(
      @Path("id") String condominiumId,
      @Path("space_id") String spaceId,
      @Body() ReservationRegistrationModel model);

  @POST(path: "/condominiums/{id}/spaces/{space_id}/raffles")
  Future<Response> postRaffles(
      @Path("id") String condominiumId,
      @Path("space_id") String spaceId,
      @Body() ReservationRaffleDataModel model);

  @GET(path: "/condominiums/{id}/spaces/{space_id}/raffles/{reservation_id}")
  Future<Response> getRaffle(
      @Path("id") String condominiumId,
      @Path("space_id") String spaceId,
      @Path("reservation_id") String reservationId);

  @POST(
      path:
          "/condominiums/{id}/spaces/{space_id}/raffles/{reservation_id}/executions",
      optionalBody: true)
  Future<Response> postRaffleExecution(
      @Path("id") String condominiumId,
      @Path("space_id") String spaceId,
      @Path("reservation_id") String reservationId);

  static ReservationApi create(ChopperClient client) {
    return _$ReservationApi(client);
  }

  static final String unit_exceeded_reservation_limit =
      "unit_exceeded_reservation_limit";
}
