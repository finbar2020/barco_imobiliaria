import 'package:chopper/chopper.dart';
part 'reservation_time_api.chopper.dart';

@ChopperApi()
abstract class ReservationTimeApi extends ChopperService {
  @GET(
      path:
          "/condominiums/{id}/spaces/{space_id}/reservation_dates/{date}/times")
  Future<Response> get(@Path("id") String condominiumId,
      @Path("space_id") String spaceId, @Path("date") String date);

  static ReservationTimeApi create(ChopperClient client) {
    return _$ReservationTimeApi(client);
  }
}
