import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report.dart';

class GetReportUseCaseImpl extends GetReportUseCase {
  final ReportsBookRepository repository;

  GetReportUseCaseImpl({
    required this.repository,
  });
  @override
  Future<Try<Report>> call(GetReportParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getReport(params.unitId, params.reportId);
  }

  Failure? _validate(GetReportParams params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();
    if (params.reportId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
