import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/data/model/report_model.dart';

import '../model/reports_model.dart';

abstract class ReportsBookRemoteDataSource {
  Future<ReportsModel> getReports(
      {required int page,
      required DateTime? dateFrom,
      required DateTime? dateTo,
      required int? type,
      required bool? closed,
      required String? unitId,
      required bool showNewMessages,
      required bool showReplies});
  Future<ReportModel> getReport(String unitId, String reportId);
  Future<ReportModel> putReportContent(
      String reportId, ContentSendModel content);
  Future<ReportModel> closeReport(String reportId);
}
