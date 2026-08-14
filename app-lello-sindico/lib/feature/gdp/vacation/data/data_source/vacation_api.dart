import 'package:chopper/chopper.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_created_model.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_request_model.dart';

part 'vacation_api.chopper.dart';

@ChopperApi()
abstract class VacationApi extends ChopperService {
  @GET(path: '/condominiums/{condominium_id}/employees/{employee_id}/vacations')
  Future<Response> getEmployeeVacation(
      @Path('condominium_id') String condominiumId,
      @Path('employee_id') String employeeId);

  @GET(
      path:
          '/condominiums/{condominium_id}/employees/{employee_id}/vacations/periods')
  Future<Response> getVacationPeriod(
      @Path('condominium_id') String condominiumId,
      @Path('employee_id') String employeeId);

  @GET(
      path:
          '/condominiums/{condominium_id}/employees/{employee_id}/vacations/holidays/')
  Future<Response> getLockedDays(
    @Path('condominium_id') String condominiumId,
    @Path('employee_id') String employeeId,
    @Query('start_date') String startDate,
    @Query('end_date') String endDate,
  );

  @POST(
      path: '/condominiums/{condominium_id}/employees/{employee_id}/vacations')
  Future<Response> postEmployeeVacation(
      @Path('condominium_id') String condominiumId,
      @Path('employee_id') String employeeId,
      @Body() VacationRequestModel model);

  @POST(
      path:
          '/condominiums/{condominium_id}/employees/{employee_id}/vacations/periods')
  Future<Response> createVacation(
      @Path('condominium_id') String condominiumId,
      @Path('employee_id') String employeeId,
      @Body() VacationCreatedModel? vacationCreated);

  static VacationApi create(ChopperClient client) {
    return _$VacationApi(client);
  }
}
