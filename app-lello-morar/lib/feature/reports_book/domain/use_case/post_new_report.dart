import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';

abstract class PostNewReportUseCase
    extends UseCase<Report, PostNewReportParams> {}

class PostNewReportParams {
  final ReportCreateModel reportCreateModel;

  PostNewReportParams({required this.reportCreateModel});
}
