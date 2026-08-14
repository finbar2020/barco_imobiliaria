import 'package:chopper/chopper.dart';
import 'package:morar/feature/easy_fix/data/model/easy_fix_unit_model.dart';

part 'easy_fix_api.chopper.dart';

@ChopperApi()
abstract class EasyFixApi extends ChopperService {
  @Get(path: "/condominiums/{condominium_id}/easyfix/unit-contact")
  Future<Response> getEasyFixUnit(
    @Path("condominium_id") String condominiumId,
  );

  @Put(path: "/condominiums/{condominium_id}/easyfix/unit-contact/update")
  Future<Response> updateAddress(
    @Path("condominium_id") String condominiumId,
    @Body() EasyFixUnitModel address,
  );

  @Get(path: "/condominiums/{condominium_id}/easyfix/cities")
  Future<Response> getCities(
    @Path("condominium_id") String condominiumId,
    @Query("uf") String uf,
  );

  static EasyFixApi create(ChopperClient client) {
    return _$EasyFixApi(client);
  }
}
