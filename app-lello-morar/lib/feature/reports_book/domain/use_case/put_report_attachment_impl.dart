import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment.dart';

class PutReportAttachmentUseCaseImpl extends PutReportAttachmentUseCase {
  final ReportsBookRepository repository;

  PutReportAttachmentUseCaseImpl({required this.repository});
  @override
  Future<Try<String>> call(PutReportAttachmentParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    final completer = Completer<Try<String>>();
    await repository.uploadReportAtt(
      params.contentId,
      params.file,
      onComplete: (url) {
        return completer.complete(Success(url));
      },
      onError: (e) {
        return completer.complete(Rejection(UnknownFailure(e)));
      },
    );
    return completer.future;
  }

  Failure? _validate(PutReportAttachmentParams params) {
    if (params.contentId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
