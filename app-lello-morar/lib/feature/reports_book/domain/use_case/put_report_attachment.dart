import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PutReportAttachmentUseCase
    extends UseCase<String, PutReportAttachmentParams> {}

class PutReportAttachmentParams {
  final String contentId;
  final File file;

  PutReportAttachmentParams({required this.contentId, required this.file});
}
