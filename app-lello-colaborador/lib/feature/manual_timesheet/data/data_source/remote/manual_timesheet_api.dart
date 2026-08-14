import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';

part 'manual_timesheet_api.chopper.dart';

@ChopperApi()
abstract class ManualTimeSheetApi extends ChopperService {
  @Post(path: "digitalRepository/manual_timesheet/register")
  Future<Response> registerManualTimeSheet(
    @Body() ManualTimeSheetModel model,
    @Path("id") String id,
  );

  @Get(path: "digitalRepository/urlUploadImage")
  Future<Response> getAwsUrl(
    @Path("id") String id,
  );

  static ManualTimeSheetApi create(ChopperClient client) {
    return _$ManualTimeSheetApi(client);
  }
}
