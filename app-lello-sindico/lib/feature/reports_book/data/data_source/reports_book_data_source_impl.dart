import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_api.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_data_source.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/data/model/report_model.dart';

import '../model/reports_model.dart';

class ReportsBookRemoteDataSourceImpl implements ReportsBookRemoteDataSource {
  final ReportsBookApi api;

  ReportsBookRemoteDataSourceImpl({required this.api});

  @override
  Future<ReportsModel> getReports({
    required DateTime? dateFrom,
    required DateTime? dateTo,
    required int? type,
    required bool? closed,
    required String? unitId,
    required bool showNewMessages,
    required bool showReplies,
    required int page,
  }) async {
    final response = await api.geReports(
        dateFrom, dateTo, type, closed, unitId, showNewMessages, showReplies, 15, page);
    return ApiMapper.map(response, (json) => ReportsModel.fromJson(json));
  }

  @override
  Future<ReportModel> getReport(String unitId, String reportId) async {
    final response = await api.getReport(unitId, reportId);
    return ApiMapper.map(response, (json) => ReportModel.fromJson(json));
  }

  @override
  Future<ReportModel> putReportContent(
      String reportId, ContentSendModel content) async {
    final response = await api.putReportContent(reportId, content);
    return ApiMapper.map(response, (json) => ReportModel.fromJson(json));
  }

  @override
  Future<ReportModel> closeReport(String reportId) async {
    final response = await api.closeReport(reportId);
    return ApiMapper.map(response, (json) => ReportModel.fromJson(json));
  }
  
}
