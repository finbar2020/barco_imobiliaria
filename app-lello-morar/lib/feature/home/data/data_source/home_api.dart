import 'package:chopper/chopper.dart';
part 'home_api.chopper.dart';

@ChopperApi()
abstract class HomeApi extends ChopperService {
  @Get(path: "/condominiums/{id}/accountabilities/{period}")
  Future<Response> get(
    @Path("id") String condominiumId,
  );

//TODO ALINHAR CHAMADA DOS BANNERS
  @Get(path: "/condominiums/{id}/banners")
  Future<Response> getBanners(
    @Path("id") String condominiumId,
  );

  @Get(path: "/dashboard/clublello/getLink/{unit_id}")
  Future<Response> getLink(@Path("unit_id") String unitId);

  @Post(path: "/dashboard/clublello/acceptuserterms/{unit_id}")
  Future<Response> postTerms(@Path("unit_id") String unitId);

  static HomeApi create(ChopperClient client) {
    return _$HomeApi(client);
  }
}
