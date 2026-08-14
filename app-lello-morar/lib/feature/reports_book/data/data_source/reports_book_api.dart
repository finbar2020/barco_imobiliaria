import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:chopper/chopper.dart';

part 'reports_book_api.chopper.dart';

@ChopperApi()
abstract class ReportsBookApi extends ChopperService {
  @Get(path: "/concierge/reportbook/{unit_id}")
  Future<Response> getAllReports(
    @Path("unit_id") String unitId,
    @Query("limit") int limit,
  );

  @Post(path: "/concierge/reportbook")
  Future<Response> postNewReport(@Body() ReportCreateModel reportBook);

  @Get(path: "/concierge/reportbook/{unit_id}/{report_id}")
  Future<Response> getReport(
    @Path("unit_id") String unitId,
    @Path("report_id") String reportId,
  );

  @Put(path: "/concierge/reportbook/{reportId}")
  Future<Response> putReportContent(
    @Path("reportId") String reportId,
    @Body() ContentSendModel body,
  );

  static ReportsBookApi create(ChopperClient client) {
    return _$ReportsBookApi(client);
  }
}
