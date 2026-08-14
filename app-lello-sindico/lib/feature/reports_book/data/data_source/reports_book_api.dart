import 'package:chopper/chopper.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';

part 'reports_book_api.chopper.dart';

@ChopperApi()
abstract class ReportsBookApi extends ChopperService {
  @GET(path: "/concierge/reportbook/paginated")
  Future<Response> getAllReports(
    @Query("limit") int limit,
    @Query("page") int page,
  );

  // @GET(path: "/concierge/reportbook/paginated")
  // Future<Response> geReports(
  //   @Query("limit") int limit,
  //   @Query("page") int page,
  // );

  @GET(path: "/concierge/reportbook/paginated")
  Future<Response> geReports(
    @Query("date_from") DateTime? dateFrom,
    @Query("date_until") DateTime? dateTo,
    @Query("type") int? type,
    @Query("closed") bool? closed,
    @Query("unit_id") String? unitId,
    @Query("showNewMessages") bool? showNewMessages,
    @Query("showReplies") bool? showReplies,
    @Query("limit") int limit,
    @Query("page") int page,
  );

  @GET(path: "/concierge/reportbook/{unit_id}/{report_id}")
  Future<Response> getReport(
    @Path("unit_id") String unitId,
    @Path("report_id") String reportId,
  );

  @PUT(path: "/concierge/reportbook/{reportId}")
  Future<Response> putReportContent(
    @Path("reportId") String reportId,
    @Body() ContentSendModel body,
  );

  @Patch(path: "/concierge/reportbook/{reportId}", optionalBody: true)
  Future<Response> closeReport(
    @Path("reportId") String reportId,
  );

  static ReportsBookApi create(ChopperClient client) {
    return _$ReportsBookApi(client);
  }
}
