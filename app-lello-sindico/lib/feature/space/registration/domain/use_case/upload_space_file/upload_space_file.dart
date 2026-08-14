import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class UploadSpaceFile extends UseCase<String, UploadSpaceFileParam> {}

class UploadSpaceFileParam {
  final String condominiumId;
  final String spaceId;
  final File file;
  final StreamController<double> progress;

  UploadSpaceFileParam(
      {required this.condominiumId,
      required this.spaceId,
      required this.file,
      required this.progress});
}
