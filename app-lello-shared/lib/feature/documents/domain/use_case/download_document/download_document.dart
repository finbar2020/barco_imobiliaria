import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class DownloadDocument extends UseCase<File, DownloadDocumentParam> {}

class DownloadDocumentParam {
  final String documentId;
  final String documentType;

  DownloadDocumentParam({
    required this.documentId,
    required this.documentType,
  });
}
