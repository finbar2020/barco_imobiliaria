import 'package:chopper/chopper.dart';

part 'billets_api.chopper.dart';

@ChopperApi()
abstract class BilletsApi extends ChopperService {
  @Get(path: "/billet/{reference}/{unitId}")
  //reference = reference do condominuim
  Future<Response> fetchBillets(
    @Path("reference") String reference,
    @Path("unitId") String unitId,
    @Query("showAll") bool showAll,
  );

  @Get(path: "/billet/{nr_billet}")
  Future<Response> getBilletPdf(
    @Path("nr_billet") String nrBillet,
  );

  static BilletsApi create(ChopperClient client) {
    return _$BilletsApi(client);
  }
}
