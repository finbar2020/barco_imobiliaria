import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/data/model/report_model.dart';

abstract class ReportsBookRemoteDataSource {
  Future<List<ReportModel>> getAllReports(String unitId);
  Future<ReportModel> postNewReport(ReportCreateModel reportCreateModel);
  Future<ReportModel> getReport(String unitId, String reportId);
  Future<ReportModel> putReportContent(
      String reportId, ContentSendModel content);
}
