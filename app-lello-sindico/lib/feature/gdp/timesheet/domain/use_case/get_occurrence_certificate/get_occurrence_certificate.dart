import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

abstract class GetOccurrenceCertificate extends UseCase<
    List<TimesheetOccurrenceCertificateEntity>,
    GetOccurrenceCertificateParam> {}

class GetOccurrenceCertificateParam {
  final String date;

  GetOccurrenceCertificateParam({required this.date});
}
