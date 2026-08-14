import 'package:chopper/chopper.dart';
part 'employee_report_api.chopper.dart';

@ChopperApi()
abstract class EmployeeReportApi extends ChopperService {
  @GET(path: '/condominiums/{condominium_id}/employee/{employee_id}/reports')
  Future<Response> get(
      @Path('condominium_id') String condominiumId,
      @Path('employee_id') String employeeId,
      @Query('report_type') String reportType);

  static EmployeeReportApi create(ChopperClient client) {
    return _$EmployeeReportApi(client);
  }
}
