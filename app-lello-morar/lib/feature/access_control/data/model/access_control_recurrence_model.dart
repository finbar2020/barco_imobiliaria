import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/data/model/access_control_itens_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';

part 'access_control_recurrence_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlRecurrenceModel {
  String? idRecurrence;
  String? recurrenceType;
  int? interval;
  List<AccessControlItensModel?> itens;

  AccessControlRecurrenceModel(
      {this.idRecurrence,
      this.recurrenceType,
      this.interval,
      this.itens = const []});

  factory AccessControlRecurrenceModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlRecurrenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlRecurrenceModelToJson(this);

  static AccessControlRecurrenceModel? fromEntity(
          AccessControlRecurrence? entity) =>
      entity == null
          ? null
          : (AccessControlRecurrenceModel()
            ..idRecurrence = entity.idRecurrence
            ..recurrenceType = entity.recurrenceType
            ..interval = entity.interval
            ..itens = entity.itens != null
                ? entity.itens!
                    .map((value) => AccessControlItensModel.fromEntity(value))
                    .toList()
                : []);

  AccessControlRecurrence toEntity() => AccessControlRecurrence()
    ..idRecurrence = idRecurrence
    ..recurrenceType = recurrenceType
    ..interval = interval
    ..itens = this.itens.isNotEmpty
        ? this.itens.map((model) => model!.toEntity()).toList()
        : [];

  @override
  String toString() {
    return 'AccessControlRecurrenceModel(idRecurrence: $idRecurrence, recurrenceType: $recurrenceType, interval: $interval, itens: $itens)';
  }
}
