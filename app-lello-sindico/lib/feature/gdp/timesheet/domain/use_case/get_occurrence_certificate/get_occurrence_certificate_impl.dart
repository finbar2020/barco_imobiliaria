import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate.dart';

class GetOccurrenceCertificateImpl extends GetOccurrenceCertificate {
  final TimesheetRepository repository;

  GetOccurrenceCertificateImpl({required this.repository});

  @override
  Future<Try<List<TimesheetOccurrenceCertificateEntity>>> call(
      GetOccurrenceCertificateParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getOccurrenceCertificate(params.date);
  }

  Failure? _validate(GetOccurrenceCertificateParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    return null;
  }
}
