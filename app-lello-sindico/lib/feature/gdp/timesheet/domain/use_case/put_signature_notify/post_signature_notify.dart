import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';

abstract class PutSignatureNotify
    extends UseCase<String, PutSignatureNotifyParam> {}

class PutSignatureNotifyParam {
  final TimesheetSignatureRequestModel model;

  PutSignatureNotifyParam({required this.model});
}
