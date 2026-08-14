import 'dart:io';

import 'package:intl/intl.dart';

class ReportContents {
  String? id;
  int? numReport;
  String? userName;
  int? typeUser;
  String? content;
  String? attachment;
  DateTime? dateContent;
  String? attachmentLink;
  File? attachmentFile;
  String? attachmentType;

  ReportContents({
    this.id,
    this.numReport,
    this.userName,
    this.typeUser,
    this.content,
    this.attachment,
    this.attachmentFile,
    this.attachmentLink,
    this.attachmentType,
    this.dateContent,
  });

  String getDate() {
    final f = DateFormat('dd/MM/yyyy - HH:mm');

    if (dateContent == null) {
      return '${f.format(DateTime.now())}h';
    } else {
      return '${f.format(dateContent!)}h';
    }
  }

  @override
  String toString() {
    return 'ReportContents(id: $id, numReport: $numReport, userName: $userName, typeUser: $typeUser, content: $content, attachment: $attachment, dateContent: $dateContent, attachmentLink: $attachmentLink, attachmentFile: $attachmentFile, attachmentType: $attachmentType)';
  }
}
