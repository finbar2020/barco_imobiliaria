import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source.dart';
import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';

class ReportsBookRepositoryImpl extends ReportsBookRepository {
  final ReportsBookRemoteDataSource dataSource;
  final Uploader uploader;
  final String baseUrl;

  ReportsBookRepositoryImpl({
    required this.dataSource,
    required this.uploader,
    required this.baseUrl,
  });

  @override
  Future<Try<List<Report>>> getAllReports(String unitId) async {
    try {
      final data = await dataSource.getAllReports(unitId);
      data.sort((a, b) => b.dateReport!.compareTo(a.dateReport!));
      return Success(data.map((model) => model.toEntity()).toList());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Report>> postNewReport(ReportCreateModel reportCreateModel) async {
    try {
      final data = await dataSource.postNewReport(reportCreateModel);
      return Success(data.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: ${reportCreateModel.idUnit}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Report>> getReport(String unitId, String reportId) async {
    try {
      final data = await dataSource.getReport(unitId, reportId);
      Report report = data.toEntity();
      if (report.reportContents!.length > 0) {
        report.reportContents!
            .sort((a, b) => a.dateContent!.compareTo(b.dateContent!));
        report.reportContents!.forEach((element) {
          if (element.attachment != null) {
            element.attachmentLink =
                "$baseUrl/concierge/reportbook/${element.id}/file/${element.attachment}";
          }
        });
      }
      return Success(report);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId - reportId: $reportId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Report>> putReportContent(
      String reportId, ContentSendModel content) async {
    try {
      final data = await dataSource.putReportContent(reportId, content);
      return Success(data.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'reportId: $reportId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    try {
      final taskId = await uploader.upload(
        "concierge/reportbook/$contentId/upload",
        file,
        onComplete: onComplete,
        onError: onError,
      );
      return Success(taskId);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'contentId: $contentId',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
