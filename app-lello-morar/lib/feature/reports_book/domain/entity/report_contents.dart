import 'dart:io';

import 'package:intl/intl.dart';

class ReportContents {
  String? id;
  int? numReport;
  // User: 0; Manager: 1
  int? typeUser;
  String? content;
  String? attachment;
  DateTime? dateContent;

  String? attachmentLink;
  File? attachmentFile;

  String? attachmentType;

  bool? public;

  ReportContents({
    this.id,
    this.numReport,
    this.typeUser,
    this.content,
    this.attachment,
    this.attachmentType,
    this.dateContent,
    this.public,
  });

  @override
  String toString() =>
      'Report(id: $id, numReport: $numReport, typeUser: $typeUser, content: $content, attachment: $attachment, attachmentType: $attachmentType)';

  String getDate() {
    final f = new DateFormat('dd/MM/yyyy - HH:mm');

    return '${f.format(dateContent!).substring(0, 15)}h:${f.format(dateContent!).substring(16, f.format(dateContent!).length)}m';
  }
}
