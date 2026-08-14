import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class RequestDigitalUsecase
    extends UseCase<bool, RequestDigitalParam> {}

class RequestDigitalParam {
  final String condoId;
  final File file;
  final Position position;

  RequestDigitalParam({
    required this.condoId,
    required this.file,
    required this.position,
  });
}
