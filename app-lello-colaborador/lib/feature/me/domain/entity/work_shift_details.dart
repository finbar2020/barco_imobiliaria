import 'package:intl/intl.dart';

class WorkShiftDetails {
  String badageNumber;
  String entry1;
  String out1;
  String entry2;
  String out2;
  bool isDayOff;
  DateTime date;
  String reference;

  WorkShiftDetails(
      {required this.badageNumber,
      required this.entry1,
      required this.out1,
      required this.entry2,
      required this.out2,
      required this.isDayOff,
      required this.date,
      required this.reference});

  factory WorkShiftDetails.clone(WorkShiftDetails wsd) => WorkShiftDetails(
        badageNumber: wsd.badageNumber,
        entry1: wsd.entry1,
        out1: wsd.out1,
        entry2: wsd.entry2,
        out2: wsd.out2,
        isDayOff: wsd.isDayOff,
        date: wsd.date,
        reference: wsd.reference,
      );

  DateTime? get entry1Date => isDayOff == false
      ? DateTime.parse("${DateFormat("yyyy-MM-dd").format(date)} $entry1")
      : null;
  DateTime? get out1Date => isDayOff == false
      ? DateTime.parse("${DateFormat("yyyy-MM-dd").format(date)} $out1")
      : null;
  DateTime? get entry2Date => isDayOff == false
      ? DateTime.parse("${DateFormat("yyyy-MM-dd").format(date)} $entry2")
      : null;
  DateTime? get out2Date => isDayOff == false
      ? DateTime.parse("${DateFormat("yyyy-MM-dd").format(date)} $out2")
      : null;

  static const int lateWarning = 5;

  DateTime? get entry1DateLate =>
      entry1Date?.add(const Duration(minutes: lateWarning));
  DateTime? get out1DateLate =>
      out1Date?.add(const Duration(minutes: lateWarning));
  DateTime? get entry2DateLate =>
      entry2Date?.add(const Duration(minutes: lateWarning));
  DateTime? get out2DateLate =>
      out2Date?.add(const Duration(minutes: lateWarning));
}
