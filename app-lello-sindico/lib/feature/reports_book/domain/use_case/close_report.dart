import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

abstract class CloseReportUseCase extends UseCase<Report, CloseReportParams> {}

class CloseReportParams {
  final String reportId;

  CloseReportParams({required this.reportId});
}
