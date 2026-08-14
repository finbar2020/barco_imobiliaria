import 'package:chopper/chopper.dart';
import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_send_invite_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_visitant_model.dart';

part 'access_control_api.chopper.dart';

@ChopperApi()
abstract class AccessControlApi extends ChopperService {
  @Get(path: "/concierge/accesscontrol/{unit_id}")
  Future<Response> getVisitants(@Path("unit_id") String unitId);

  @Post(path: "/concierge/accesscontrol")
  Future<Response> saveVisitant(
    @Body() AccessControlVisitantModel visitant,
  );

  @Put(path: "/concierge/accesscontrol")
  Future<Response> editVisitant(
    @Body() AccessControlVisitantModel visitant,
  );

  @Delete(path: "/concierge/accesscontrol/{gest_id}")
  Future<Response> deleteVisitant(
    @Path("gest_id") String gestId,
  );

  //visitas

  @Post(path: "/concierge/accesscontrol/recurrence")
  Future<Response> saveVisit(
    @Body() AccessControlAuthorizationsModel visit,
    @Query("gest_id") String gestId,
    @Query('unit_idv') String unitId,
  );

  @Put(path: "/concierge/accesscontrol/recurrence/{recurrence_id}")
  Future<Response> editVisit(
    @Body() AccessControlAuthorizationsModel visitant,
    @Path("recurrence_id") String recurrenceId,
  );

  @Delete(path: "/concierge/accesscontrol/recurrence/{recurrence_id}")
  Future<Response> deleteVisit(
    @Path("recurrence_id") String recurrenceId,
  );

  @Get(path: "/concierge/accesscontrol/getUrlS3")
  Future<Response> getAwsUrl();

  @Post(path: "/concierge/accesscontrol/registerFacialBiometric")
  Future<Response> registerFacialBiometric(
    @Query("hash") String hash,
  );

  @Post(path: "/concierge/accesscontrol/sendInvite")
  Future<Response> sendInvite(
    @Body() AccessControlSendInviteModel body,
  );

  static AccessControlApi create(ChopperClient client) {
    return _$AccessControlApi(client);
  }
}
