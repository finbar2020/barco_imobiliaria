// ignore_for_file: annotate_overrides, overridden_fields

import 'package:essentials/essentials.dart';

import '../../feature/digital_point/domain/entity/digital_point.dart';

class DigitalPointSendFailure extends Failure {
  final List<DigitalPointEntity> points;
  final String? message;
  final String? code;
  DigitalPointSendFailure({
    required this.points,
    this.message,
    this.code,
  });
}
