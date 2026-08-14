import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/reports.dart';

abstract class GetReportsUseCase
    extends UseCase<Reports, GetReportsParams> {}

class GetReportsParams {
  final int page;
  final ReportFilterModel reportFilterModel;

  GetReportsParams(
      {required this.reportFilterModel, required this.page});
}
