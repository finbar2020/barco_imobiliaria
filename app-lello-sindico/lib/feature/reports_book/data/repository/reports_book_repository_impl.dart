import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_data_source.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';

import '../../domain/entity/reports.dart';

class ReportsBookRepositoryImpl extends ReportsBookRepository {
  final ReportsBookRemoteDataSource dataSource;
  final Uploader uploader;
  final String baseUrl;

  ReportsBookRepositoryImpl(
      {required this.dataSource,
      required this.uploader,
      required this.baseUrl});

  @override
  // Future<Try<Reports>> getAllReports() async {
  //   try {
  //     final data = await dataSource.getAllReports(page: 2);
  //     if (data.data!.isNotEmpty) {
  //       data.data?.sort((a, b) => b.dateReport!.compareTo(a.dateReport!));
  //     }
  //     return Success(data.toEntity());
  //   } catch (err) {
  //     return Rejection(UnknownFailure(err));
  //   }
  // }

  // @override
  // Future<Try<Reports>> getReports(int page) async {
  //   try {
  //     final data = await dataSource.getReports(page: page);
  //     if (data.data!.isNotEmpty) {
  //       data.data?.sort((a, b) => b.dateReport!.compareTo(a.dateReport!));
  //     }
  //     return Success(data.toEntity());
  //   } catch (err) {
  //     return Rejection(UnknownFailure(err));
  //   }
  // }

  @override
  Future<Try<Reports>> getReports(
      ReportFilterModel reportFilterModel, int page) async {
    try {
      final data = await dataSource.getReports(
        dateFrom: reportFilterModel.dateFrom,
        dateTo: reportFilterModel.dateTo,
        type: reportFilterModel.type,
        closed: reportFilterModel.closed,
        unitId: reportFilterModel.unitId,
        showNewMessages: reportFilterModel.showOnlyNewReports,
        showReplies: reportFilterModel.showOnlyReplies,
        page: page,
      );
      if (data.data!.isNotEmpty) {
        data.data?.sort((a, b) => b.dateReport!.compareTo(a.dateReport!));
      }
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
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
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Report>> putReportContent(
      String reportId, ContentSendModel content) async {
    try {
      final data = await dataSource.putReportContent(reportId, content);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {Function(String)? onComplete, Function(Exception)? onError}) async {
    try {
      final completer = Completer<Try<String>>();
      await uploader.upload(
        "concierge/reportbook/$contentId/upload",
        file,
        onComplete: (url) {
          return completer.complete(Success(url));
        },
        onError: (err) {
          return completer.complete(Rejection(UnknownFailure(err)));
        },
      );
      return completer.future;
    } catch (err) {
      return new Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Report>> closeReport(String reportId) async {
    try {
      final data = await dataSource.closeReport(reportId);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
