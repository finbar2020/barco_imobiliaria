import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports.dart';

import '../entity/reports.dart';

class GetReportsUseCaseImpl extends GetReportsUseCase {
  final ReportsBookRepository repository;

  GetReportsUseCaseImpl({
    required this.repository,
  });
  @override
  Future<Try<Reports>> call(GetReportsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getReports(params.reportFilterModel, params.page);
  }

  Failure? _validate(GetReportsParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}


