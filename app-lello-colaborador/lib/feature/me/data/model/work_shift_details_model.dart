import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_shift_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WorkShiftDetailsModel {
  String badageNumber;
  String entry1;
  String out1;
  String entry2;
  String out2;
  bool isDayOff;
  DateTime date;
  String reference;

  WorkShiftDetailsModel(
      {required this.badageNumber,
      required this.entry1,
      required this.out1,
      required this.entry2,
      required this.out2,
      required this.isDayOff,
      required this.date,
      required this.reference});

  factory WorkShiftDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$WorkShiftDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkShiftDetailsModelToJson(this);

  static WorkShiftDetailsModel? fromEntity(WorkShiftDetails? me) => me == null
      ? null
      : (WorkShiftDetailsModel(
          badageNumber: me.badageNumber,
          entry1: me.entry1,
          out1: me.out1,
          entry2: me.entry2,
          out2: me.out2,
          isDayOff: me.isDayOff,
          date: me.date,
          reference: me.reference,
        ));

  WorkShiftDetails toEntity() => WorkShiftDetails(
        badageNumber: badageNumber,
        entry1: entry1,
        out1: out1,
        entry2: entry2,
        out2: out2,
        isDayOff: isDayOff,
        date: date,
        reference: reference,
      );
}
