import 'package:intl/intl.dart';

class ReportMessage {
  String? message;
  DateTime? date;
  String? attachment;

  ReportMessage({
    this.message,
    this.date,
    this.attachment,
  });

  @override
  String toString() {
    return 'Report(message: $message, date: $date, attachment: $attachment)';
  }

  String get getDate {
    final f = new DateFormat('dd/MM/yyyy - HH:mm');

    return f.format(date!) + 'h';
  }
}
