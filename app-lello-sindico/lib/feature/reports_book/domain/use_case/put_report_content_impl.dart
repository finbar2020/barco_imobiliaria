import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content.dart';

class PutReportContentUseCaseImpl extends PutReportContentUseCase {
  final ReportsBookRepository repository;

  PutReportContentUseCaseImpl({required this.repository});
  @override
  Future<Try<Report>> call(PutReportContentParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.putReportContent(params.reportId, params.content);
  }

  Failure? _validate(PutReportContentParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.reportId.isEmpty) return InvalidParamFailure();
    if (params.content.idReport == null || params.content.idReport!.isEmpty)
      return InvalidParamFailure();
    if (params.content.content == null || params.content.content!.isEmpty)
      return InvalidParamFailure();
    return null;
  }
}
