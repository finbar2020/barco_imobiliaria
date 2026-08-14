import 'dart:io';
import 'package:essentials/base/use_case.dart';

abstract class UploadDocuments extends UseCase<String, UploadDocumentsParams> {}

class UploadDocumentsParams {
  final String url;
  final File file;

  UploadDocumentsParams({required this.url, required this.file});
}
