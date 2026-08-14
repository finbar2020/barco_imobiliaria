import 'package:chopper/chopper.dart';

part 'vehicle_api.chopper.dart';

@ChopperApi()
abstract class VehicleApi extends ChopperService {
  @GET(path: "/condominiums/{id}/units/{unitId}/vehicles")
  Future<Response> list(
    @Path() String id,
    @Path() String unitId, {
    @Query("q") String? query,
    @Query("loadAll") bool? loadAll,
  });

  static VehicleApi create(ChopperClient client) {
    return _$VehicleApi(client);
  }
}
