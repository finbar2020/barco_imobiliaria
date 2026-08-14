import 'package:chopper/chopper.dart';

part 'employee_api.chopper.dart';

@ChopperApi()
abstract class EmployeeApi extends ChopperService {
  @Get(path: "/condominiums/{id}/employees")
  Future<Response> list(
    @Path("id") String condominiumId,
    @Query("last_employee_id") String? lastEmployeeId, {
    @Query("name") String? name,
    @Query("role") String? role,
    @Query("salary_from") double? salaryFrom,
    @Query("salary_to") double? salaryTo,
    @Query("dob_from") DateTime? dobFrom,
    @Query("dob_to") DateTime? dobTo,
    @Query("hiring_date_from") DateTime? hiringDateFrom,
    @Query("hiring_date_to") DateTime? hiringDateTo,
    @Query("condition_name") String? conditionName,
    @Query("status") String? status,
  });

  @Get(path: "/condominiums/{id}/employees/{employee_id}")
  Future<Response> get(
      @Path("id") String condominiumId, @Path("employee_id") String employeeId);

  static EmployeeApi create(ChopperClient client) {
    return _$EmployeeApi(client);
  }
}
