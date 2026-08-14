import 'package:chopper/chopper.dart';
part 'accountability_approval_api.chopper.dart';

@ChopperApi()
abstract class AccountabilityApprovalApi extends ChopperService {
  @POST(
      path: "/condominiums/{id}/accountabilities/{period}/approvals",
      optionalBody: true)
  Future<Response> post(
      @Path("id") String condominiumId, @Path("period") String period);

  static AccountabilityApprovalApi create(ChopperClient client) {
    return _$AccountabilityApprovalApi(client);
  }
}
