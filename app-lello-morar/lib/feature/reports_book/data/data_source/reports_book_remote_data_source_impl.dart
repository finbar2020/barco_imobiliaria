import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_api.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source.dart';
import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/data/model/report_model.dart';

class ReportsBookRemoteDataSourceImpl implements ReportsBookRemoteDataSource {
  final ReportsBookApi api;

  ReportsBookRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ReportModel>> getAllReports(String unitId) async {
    final response = await api.getAllReports(unitId, 1000);
    return ApiMapper.mapList(response, (json) => ReportModel.fromJson(json));
  }

  @override
  Future<ReportModel> postNewReport(ReportCreateModel reportCreateModel) async {
    final response = await api.postNewReport(reportCreateModel);
    return ApiMapper.map(response, (json) => ReportModel.fromJson(json));
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
}
