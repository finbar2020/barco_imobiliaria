import 'package:chopper/chopper.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/data/model/me_password_model.dart';

part 'me_api.chopper.dart';

@ChopperApi()
abstract class MeApi extends ChopperService {
  @Get(path: "/me")
  Future<Response> get([@Query("idEmpresa") int? idEmpresa]);

  @Patch(path: "/me")
  Future<Response> patch(@Body() MeModel me, @Query("code") String code);

  @Post(path: "/me/change_password")
  Future<Response> updatePassword(@Body() MePasswordModel me);

  static MeApi create(ChopperClient client) {
    return _$MeApi(client);
  }
}
