import 'package:intl/intl.dart';

class AccountabilityGroupedAccountEntrie {
  int id;
  DateTime date;
  double value;
  String signal;
  double credit;
  double debit;
  String history;

  AccountabilityGroupedAccountEntrie(
      {required this.id,
      required this.date,
      required this.value,
      required this.signal,
      required this.credit,
      required this.debit,
      required this.history});

  String get dateFormatted => DateFormat("dd/MM/yyyy").format(date);
}
