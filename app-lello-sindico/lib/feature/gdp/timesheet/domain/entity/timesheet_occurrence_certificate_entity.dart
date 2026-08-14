import 'package:lello/core/extension/string_extension.dart';

class TimesheetOccurrenceCertificateEntity {
  String name;
  String numCra;
  String reference;
  String initDate;
  String endDate;
  String archiveHash;
  TimesheetOccurrenceCertificateEntity({
    this.numCra = "",
    this.name = '',
    this.initDate = '',
    this.endDate = '',
    this.reference = '',
    this.archiveHash = '',
  });

  String get nameFormatted => name
      .trimRight()
      .split(' ')
      .map((word) => word.isNotEmpty ? word.capitalize() : '')
      .join(' ');
}
