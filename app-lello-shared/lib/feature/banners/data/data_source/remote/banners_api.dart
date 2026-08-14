import 'package:chopper/chopper.dart';

part 'banners_api.chopper.dart';

@ChopperApi()
abstract class BannersApi extends ChopperService {
  @GET(path: "/condominiums/{condo_id}/banners/v2")
  Future<Response> getBanners(
    @Path("condo_id") String condominiumId,
  );

  static BannersApi create(ChopperClient client) {
    return _$BannersApi(client);
  }
}
