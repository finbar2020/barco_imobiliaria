import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';

part 'timesheet_api.chopper.dart';

@ChopperApi()
abstract class TimesheetGDPApi extends ChopperService {
  @Get(path: '/timesheet/references/{id}')
  Future<Response> list(
    @Path('id') String condominiumId, {
    @Query("name") String? name,
    @Query("id_Employee") String? idEmployee,
    @Query("type") String? type,
    @Query("dob_from") DateTime? dobFrom,
    @Query("dob_to") DateTime? dobTo,
  });

  @Get(path: '/timesheet/employees/{id}')
  Future<Response> listEmployees(@Path('id') String condominiumId);

  @Get(path: '/timesheet/report/day/{id}')
  Future<Response> getReportDay(
    @Path('id') String condominiumId, {
    @Query("name") String? name,
    @Query("id_Employee") String? idEmployee,
    @Query("type") String? type,
    @Query("dob_from") DateTime? dobFrom,
    @Query("dob_to") DateTime? dobTo,
  });

  @Get(path: '/timesheet/signatures/{id}')
  Future<Response> listSignature(
    @Path('id') String condominiumId, {
    @Query("name") String? name,
    @Query("id_Employee") String? idEmployee,
    @Query("type") String? type,
    @Query("dob_from") DateTime? dobFrom,
    @Query("dob_to") DateTime? dobTo,
  });

  @Put(path: '/timesheet/signatures/{id}')
  Future<Response> sign(@Path('id') String condominiumId,
      @Body() TimesheetSignatureRequestModel signatures);

  @Post(path: '/timesheet/event/{id}')
  Future<Response> insertTimesheetEvent(
      @Path('id') String condominiumId, @Body() TimesheetEventModel event);

  @Post(path: '/timesheet/request/{id}', optionalBody: true)
  Future<Response> requestTimesheet(@Path('id') String condominiumId);

  static TimesheetGDPApi create(ChopperClient client) {
    return _$TimesheetGDPApi(client);
  }
}
