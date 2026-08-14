import 'package:lello/core/extension/string_extension.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';

class TimesheetEntity {
  final String? photo;
  final String name;
  final String? numCra;
  final String? jobPosition;
  final int? signatureId;
  final int? occurrences;
  final bool? signatureEmployee;
  final bool? signatureManager;
  final TimesheetActionEnum action;

  TimesheetEntity({
    this.photo,
    required this.name,
    this.numCra,
    this.jobPosition,
    this.signatureId,
    this.occurrences,
    this.signatureEmployee,
    this.signatureManager,
    required this.action,
  });

  String get nameFormatted => name
      .trimRight()
      .split(' ')
      .map((word) => word.isNotEmpty ? word.capitalize() : '')
      .join(' ');

  String get pictureLink => photo?.isNotEmpty == true ? photo! : "";
}
