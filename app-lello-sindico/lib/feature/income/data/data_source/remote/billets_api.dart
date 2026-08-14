import 'package:chopper/chopper.dart';

part 'billets_api.chopper.dart';

@ChopperApi()
abstract class BilletsApi extends ChopperService {
  @GET(path: "/condominiums/{id}/incomes/{period}/unit/{unitId}/billet")
  Future<Response> get(
      @Path() String id, @Path() String unitId, @Path() String period);

  @GET(path: "/condominiums/{id}/units/byBillets")
  Future<Response> getUnitsByBillets(
    @Path() String id,
    @Query("query") String? query,
    @Query("status") String? status,
    @Query("period") DateTime? period,
    @Query("lastUnitId") String? lastUnitId,
    @Query("loadAll") bool? loadAll,
  );

  @GET(path: "/billet/{nrBillet}")
  Future<Response> downloadPdf(
    @Path() String nrBillet,
  );

  static BilletsApi create(ChopperClient client) {
    return _$BilletsApi(client);
  }

  @GET(path: "/billet/{id}/period_availability")
  Future<Response> getBilletPeriodAvailability(
    @Path("id") String condominiumId,
    @Query("limit") int? limit,
    @Query("page") int? page,
  );
}
