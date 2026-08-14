import 'dart:io';

class ManualTimeSheetEntity {
  DateTime? date;
  File? file;
  String? fileTempHash;
  String? filePath;

  ManualTimeSheetEntity({
    this.date,
    this.file,
    this.fileTempHash,
    this.filePath,
  });

  bool get isValid {
    if (file == null || date == null) {
      return false;
    }
    return true;
  }
}
