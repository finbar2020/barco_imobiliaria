import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class UploadPaymentFile
    extends UseCase<String, UploadPaymentFileParams> {}

class UploadPaymentFileParams {
  final String condominiumId;
  final File file;

  UploadPaymentFileParams({required this.condominiumId, required this.file});
}
