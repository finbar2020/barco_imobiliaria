import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report.dart';

class PostNewReportUseCaseImpl extends PostNewReportUseCase {
  final ReportsBookRepository repository;

  PostNewReportUseCaseImpl({required this.repository});
  @override
  Future<Try<Report>> call(PostNewReportParams params) async {
    return await repository.postNewReport(params.reportCreateModel);
  }
}
