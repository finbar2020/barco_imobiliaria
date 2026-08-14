import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify.dart';

class PutSignatureNotifyImpl extends PutSignatureNotify {
  final TimesheetRepository repository;

  PutSignatureNotifyImpl({required this.repository});

  @override
  Future<Try<String>> call(PutSignatureNotifyParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.putSignatureOrNotify(params.model);
  }

  Failure? _validate(PutSignatureNotifyParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.model.signaturesRequest.isEmpty) return InvalidParamFailure();
    return null;
  }
}
