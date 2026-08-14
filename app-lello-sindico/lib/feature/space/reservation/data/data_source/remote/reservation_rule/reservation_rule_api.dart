import 'package:chopper/chopper.dart';

part 'reservation_rule_api.chopper.dart';

@ChopperApi()
abstract class ReservationRuleApi extends ChopperService {
  @GET(path: "/condominiums/{id}/spaces/{space_id}/rules")
  Future<Response> get(
      @Path("id") String condominiumId, @Path("space_id") String spaceId);

  @GET(path: "/schedulemoving/rule/{condominiumId}")
  Future<Response> getChangeRules(@Path("condominiumId") String condominiumId);

  @POST(path: "/schedulemoving/rule/{condominiumId}")
  Future<Response> postChangeRules(
    @Path("reference") String condominiumId,
    @Body() Map<String, dynamic> rule,
  );

  static ReservationRuleApi create(ChopperClient client) {
    return _$ReservationRuleApi(client);
  }
}
