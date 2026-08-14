import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';

abstract class ReportsBookRepository {
  Future<Try<List<Report>>> getAllReports(String unitId);
  Future<Try<Report>> postNewReport(ReportCreateModel reportCreateModel);
  Future<Try<Report>> getReport(String unitId, String reportId);
  Future<Try<Report>> putReportContent(
      String reportId, ContentSendModel content);
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError});
}
