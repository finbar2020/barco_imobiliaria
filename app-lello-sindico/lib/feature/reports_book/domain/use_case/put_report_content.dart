import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

abstract class PutReportContentUseCase
    extends UseCase<Report, PutReportContentParams> {}

class PutReportContentParams {
  final String reportId;
  final ContentSendModel content;

  PutReportContentParams({required this.reportId, required this.content});
}
