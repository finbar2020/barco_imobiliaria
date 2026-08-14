import 'package:chopper/chopper.dart';

part 'authentication_tablet_api.chopper.dart';

@ChopperApi()
abstract class AuthenticationTabletApi extends ChopperService {
  @Get(path: "/registration/condo_info/code/{condoCode}")
  Future<Response> getInfoByCondominiumCode(@Path() int condoCode);

  static AuthenticationTabletApi create(ChopperClient client) {
    return _$AuthenticationTabletApi(client);
  }
}
