import 'dart:io';

import 'package:intl/intl.dart';

class SickNoteEntity {
  DateTime? date;
  File? file;
  String? fileTempHash;
  String? filePath;
  String? typeFile;
  bool isChecked;
  int? sickNoteDays;

  SickNoteEntity(
      {this.date,
      this.file,
      this.fileTempHash,
      this.filePath,
      this.typeFile,
      this.sickNoteDays,
      this.isChecked = false});

  String get getFormattedDate =>
      date == null ? "" : DateFormat('dd/MM/yyyy').format(date!);

  bool get isValid {
    if (file == null || date == null) {
      return false;
    }
    return true;
  }

  bool get isDaysChecked {
    if (sickNoteDays == null && isChecked) {
      return false;
    }
    if (sickNoteDays != null && !isChecked) {
      return false;
    }
    return true;
  }
}
