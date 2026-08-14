import 'package:chopper/chopper.dart';
part 'reservation_summary_api.chopper.dart';

@ChopperApi()
abstract class ReservationSummaryApi extends ChopperService {
  @GET(path: "/condominiums/{id}/spaces/reservation/calendar/day/{spaceId}")
  Future<Response> get(
      @Path() String id,
      @Path() String spaceId,
      @Query("start_date") String periodStart,
      @Query("end_date") String periodEnd);

  static ReservationSummaryApi create(ChopperClient client) {
    return _$ReservationSummaryApi(client);
  }
}
