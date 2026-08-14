import 'package:chopper/chopper.dart';

part 'unit_api.chopper.dart';

@ChopperApi()
abstract class UnitApi extends ChopperService {
  @GET(path: "/condominiums/{id}/units/full")
  Future<Response> list(
    @Path() String id, {
    @Query("lastUnitId") String? lastUnitId,
    @Query("q") String? query,
    @Query("loadAll") bool? loadAll,
    @Query("blockName") String? blockName,
    @Query("unitName") String? unitName,
    @Query("hasAppInstalled") bool? hasAppInstalled,
    @Query("showOnlyUnitsWithBiometrics") bool? showOnlyUnitsWithBiometrics,
    @Query("vehicleIdentification") String? vehicleIdentification,
    @Query("vehicleTypeSelected") String? vehicleTypeSelected,
    @Query("filterOnlyWithTenant") bool? filterOnlyWithTenant,
  });

  @GET(path: "/condominium/{id}/simple")
  Future<Response> listSimple(@Path() String id);

  static UnitApi create(ChopperClient client) {
    return _$UnitApi(client);
  }
}
