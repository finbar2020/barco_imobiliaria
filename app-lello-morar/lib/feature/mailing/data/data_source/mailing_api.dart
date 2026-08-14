import 'package:chopper/chopper.dart';

part 'mailing_api.chopper.dart';

@ChopperApi()
abstract class MailingApi extends ChopperService {
  @Get(path: "/concierge/mailing/{unit_id}")
  Future<Response> fetchMailings(
    @Path("unit_id") String unitId,
    @Query("showAll") bool showAll,
  );

  @Get(path: "/concierge/mailing/photo/{hash}")
  Future<Response> getPicture(
    @Path("hash") String hash,
  );

  static MailingApi create(ChopperClient client) {
    return _$MailingApi(client);
  }
}
