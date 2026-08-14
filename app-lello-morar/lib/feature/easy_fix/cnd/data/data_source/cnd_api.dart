import 'package:chopper/chopper.dart';
import 'package:morar/feature/easy_fix/cnd/data/model/unit_profile_model.dart';

part 'cnd_api.chopper.dart';

@ChopperApi()
abstract class CndApi extends ChopperService {
  @Post(path: "/condominiums/{condominium_id}/easyfix/cnd")
  Future<Response> generateCertificateNoOutstandingDebt(
    @Path("condominium_id") String condominiumId,
    @Body() UnitProfileModel body,
  );

  static CndApi create(ChopperClient client) {
    return _$CndApi(client);
  }
}
