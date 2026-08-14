import 'package:chopper/chopper.dart';

part 'reservation_api.chopper.dart';

@ChopperApi()
abstract class ReservationApi extends ChopperService {
  @Get(path: "/condominiums/{id}/spaces")
  Future<Response> getSpaces(
    @Path("id") String condominiumId,
  );

  @Get(path: "/condominiums/{id}/spaces/reservation/calendar/day/{spaceId}")
  Future<Response> getCalendar(
    @Path("id") String condominiumId,
    @Path("spaceId") String spaceId,
    @Query("start_date") String startDate,
    @Query("end_date") String endDate,
  );

  @Get(path: "/condominiums/{id}/spaces/reservation/calendar/hours/{spaceId}")
  Future<Response> getHours(
    @Path("id") String condominiumId,
    @Path("spaceId") String spaceId,
    @Query("date") DateTime date,
    @Query("unitId") String unitId,
  );

  @Get(path: "/condominiums/{id}/reservations")
  Future<Response> getReservations(
    @Path("id") String condominiumId,
    @Query("unitId") String unitId,
  );

  @Delete(
      path:
          "/condominiums/{id}/reservations/{reservation_id}/{reservation_type}")
  Future<Response> deleteReservation(
    @Path("id") String condominiumId,
    @Path("reservation_id") String reservationId,
    @Path("reservation_type") String reservationType,
  );

  @Post(path: "/condominiums/{id}/spaces/{space_id}/reservations")
  Future<Response> postReservations(
    @Path("id") String condominiumId,
    @Path("space_id") String spaceId,
    @Body() Object body,
  );

  static ReservationApi create(ChopperClient client) {
    return _$ReservationApi(client);
  }
}
