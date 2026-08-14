import 'package:chopper/chopper.dart';

part 'resident_api.chopper.dart';

@ChopperApi()
abstract class ResidentApi extends ChopperService {
  @GET(path: "/condominiums/{id}/residents")
  Future<Response> list(@Path() String id,
      {@Query("lastResidentId") String? lastResidentId,
      @Query("q") String? query,
      @Query("loadAll") bool? loadAll});

  @GET(path: "/condominiums/{id}/units/{unitId}/residents")
  Future<Response> listFromUnit(@Path() String id, @Path() String unitId);

  static ResidentApi create(ChopperClient client) {
    return _$ResidentApi(client);
  }
}
