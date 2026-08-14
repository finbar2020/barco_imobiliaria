import 'package:chopper/chopper.dart';
import 'package:lello/feature/space/data/model/space_model.dart';

part 'space_api.chopper.dart';

@ChopperApi()
abstract class SpaceApi extends ChopperService {
  @GET(path: "/condominiums/{id}/spaces")
  Future<Response> get(@Path("id") String condominiumId);

  @GET(path: "/condominiums/{id}/spaces_types")
  Future<Response> listTypes(@Path("id") String condominiumId);

  @POST(path: "/condominiums/{id}/spaces")
  Future<Response> post(
      @Path("id") String condominiumId, @Body() SpaceModel space);

  @PUT(path: "/condominiums/{id}/spaces/{space_id}")
  Future<Response> put(@Path("id") String condominiumId,
      @Path("space_id") String spaceId, @Body() SpaceModel space);

  @GET(path: "/condominiums/{id}/spaces/calendar")
  Future<Response> getDates(
    @Path() String id, {
    @Query("start_date") DateTime? startDate,
    @Query("end_date") DateTime? endDate,
  });

  @GET(path: "/condominiums/{id}/spaces/calendar/day/{spaceId}")
  Future<Response> getCalendar(
    @Path() String id,
    @Path() String spaceId, {
    @Query("start_date") DateTime? startDate,
    @Query("end_date") DateTime? endDate,
  });

  @GET(path: "/condominiums/{id}/spaces/reservation/calendar/hours/{spaceId}")
  Future<Response> getHours(
    @Path() String id,
    @Path() String spaceId, {
    @Query("date") required DateTime date,
    @Query("unitId") String? unitId,
  });

  static SpaceApi create(ChopperClient client) {
    return _$SpaceApi(client);
  }
}
