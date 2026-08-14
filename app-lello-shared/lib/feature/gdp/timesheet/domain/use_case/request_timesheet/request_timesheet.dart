import 'package:essentials/essentials.dart';

abstract class RequestTimesheet extends UseCase<String, RequestTimesheetParam> {
}

class RequestTimesheetParam {
  final String condominiumId;

  RequestTimesheetParam({required this.condominiumId});
}
