import 'package:intl/intl.dart';

class AccountabilityPeriods {
  DateTime? period;
  String? situation;
  DateTime? approvalDate;

  String get periodo =>
      "${toBeginningOfSentenceCase(DateFormat('MMMM').format(period ?? DateTime.now()))} - ${this.period?.year ?? DateTime.now().year}";
}
