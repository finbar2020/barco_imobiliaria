import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report.dart';

class CloseReportUseCaseImpl extends CloseReportUseCase {
  final ReportsBookRepository repository;

  CloseReportUseCaseImpl({
    required this.repository,
  });
  @override
  Future<Try<Report>> call(CloseReportParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.closeReport(params.reportId);
  }

  Failure? _validate(CloseReportParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.reportId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
