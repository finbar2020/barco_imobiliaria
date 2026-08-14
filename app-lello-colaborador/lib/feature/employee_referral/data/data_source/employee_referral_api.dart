import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';

part 'employee_referral_api.chopper.dart';

@ChopperApi()
abstract class EmployeeReferralApi extends ChopperService {
  @Post(
      path: "/condominiums/{condoId}/employees/{employee_id}/referral/register")
  Future<Response> registerEmployeeReferral(
    @Body() EmployeeReferralModel model,
    @Path("condoId") String condoId,
    @Path('employee_id') String employeeId,
  );

  @Get(path: "/condominiums/{condoId}/employees/{employee_id}/referral/cities")
  Future<Response> getCities(
      @Path('condoId') String condoId, @Path('employee_id') String employeeId);

  @Get(
      path:
          "/condominiums/{condoId}/employees/{employee_id}/referral/urlUploadImage")
  Future<Response> getAwsUrl(
    @Path("condoId") String condoId,
    @Path('employee_id') String employeeId,
  );

  static EmployeeReferralApi create(ChopperClient client) {
    return _$EmployeeReferralApi(client);
  }
}
