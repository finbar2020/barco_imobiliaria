import 'package:chopper/chopper.dart';

part 'timesheet_api.chopper.dart';

@ChopperApi()
abstract class TimesheetApi extends ChopperService {
  @Get(path: "condominiums/{id}/digital_point/timesheet")
  Future<Response> getTimesheet(
    @Path("id") String id,
    @Query() DateTime period,
  );

  @Get(path: "condominiums/{id}/digital_point/timesheet/detail")
  Future<Response> getTimesheetDetail(
    @Path("id") String id,
    @Query() DateTime period,
  );

  @Get(path: "timesheet/references/{id}/periods")
  Future<Response> getTimesheetPeriods(
    @Path("id") String id,
  );

  @Post(
      path: "condominiums/{id}/digital_point/timesheet_email",
      optionalBody: true)
  Future<Response> sendEmail(
    @Path("id") String id,
    @Query("email") String email,
    @Query("period") DateTime period,
  );

  @Post(
      path: "condominiums/{id}/digital_point/timesheet/sign",
      optionalBody: true)
  Future<Response> signTimesheet(
    @Path("id") String id,
    @Query("timesheetSignType") String timesheetSignType,
    @Query("period") DateTime period,
  );

  static TimesheetApi create(ChopperClient client) {
    return _$TimesheetApi(client);
  }
}
