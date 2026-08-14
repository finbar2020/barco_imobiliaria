import 'package:json_annotation/json_annotation.dart';

part 'timesheet_occurrence_manual_appontment_list_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetOccurrenceManualAppontmentListModel {
  List<String>? times;

  TimesheetOccurrenceManualAppontmentListModel({
    this.times,
  });

  factory TimesheetOccurrenceManualAppontmentListModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetOccurrenceManualAppontmentListModelFromJson(json);

  List<String>? toEntity() => times;
}
