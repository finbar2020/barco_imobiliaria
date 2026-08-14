import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

abstract class GetReportUseCase extends UseCase<Report, GetReportParams> {}

class GetReportParams {
  final String unitId;
  final String reportId;

  GetReportParams({required this.unitId, required this.reportId});
}
