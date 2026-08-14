import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

import '../entity/reports.dart';

abstract class ReportsBookRepository {
  // Future<Try<Reports>> getAllReports();
  // Future<Try<Reports>> getReports(int page);
  Future<Try<Reports>> getReports(
      ReportFilterModel reportFilterModel, int page);
  Future<Try<Report>> getReport(String unitId, String reportId);
  Future<Try<Report>> putReportContent(
      String reportId, ContentSendModel content);
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {Function(String) onComplete, Function(Exception) onError});
  Future<Try<Report>> closeReport(String reportId);
}
