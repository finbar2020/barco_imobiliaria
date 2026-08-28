import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';

part 'timesheet_filter_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetFilterModel {
  String? name;
  String? id;
  String? type;
  DateTime? dobFrom;
  DateTime? dobTo;

  TimesheetFilterModel();

  factory TimesheetFilterModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetFilterModelToJson(this);

  static TimesheetFilterModel? fromEntity(TimesheetFilter? entity) =>
      entity == null
          ? null
          : (TimesheetFilterModel()
            ..name = entity.name
            ..id = entity.id
            ..type = enumToString(entity.type)
            ..dobFrom = entity.dobFrom
            ..dobTo = entity.dobTo);

  TimesheetFilter toEntity() => TimesheetFilter()
    ..name = this.name
    ..id = this.id
    ..type = stringToEnum(TimesheetTypeEnum.values, this.type)
    ..dobFrom = this.dobFrom
    ..dobTo = this.dobTo;
}
