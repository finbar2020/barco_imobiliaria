import 'package:essentials/essentials.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment.dart';

class PutReportAttachmentUseCaseImpl extends PutReportAttachmentUseCase {
  final ReportsBookRepository repository;

  PutReportAttachmentUseCaseImpl({required this.repository});
  @override
  Future<Try<String>> call(PutReportAttachmentParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.uploadReportAtt(params.contentId, params.file);
  }

  Failure? _validate(PutReportAttachmentParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.contentId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
