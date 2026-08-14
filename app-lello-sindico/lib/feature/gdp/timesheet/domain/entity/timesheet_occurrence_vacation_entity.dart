import 'package:essentials/essentials.dart';

class TimesheetOccurrenceVacationEntity {
  String name;
  String numCra;
  String initDate;
  String endDate;
  String receiptUrl;
  String archiveName;
  TimesheetOccurrenceVacationEntity({
    this.numCra = "",
    this.name = '',
    this.initDate = '',
    this.endDate = '',
    this.receiptUrl = '',
    this.archiveName = '',
  });

  String get nameFormatted => name
      .trimRight()
      .split(' ')
      .map((word) => word.isNotEmpty ? word.capitalize : '')
      .join(' ');
}
