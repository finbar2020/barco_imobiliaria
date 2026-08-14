import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports.dart';

class GetAllReportsUseCaseImpl extends GetAllReportsUseCase {
  final ReportsBookRepository repository;

  GetAllReportsUseCaseImpl({required this.repository});
  @override
  Future<Try<List<Report>>> call(GetAllReportsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getAllReports(params.unitId);
  }

  Failure? _validate(GetAllReportsParams params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
