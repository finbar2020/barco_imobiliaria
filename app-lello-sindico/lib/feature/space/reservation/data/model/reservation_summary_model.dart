import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_summary.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

part 'reservation_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationSummaryModel {
  DateTime? day;
  List<String>? types;

  ReservationSummaryModel();

  factory ReservationSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationSummaryModelToJson(this);

  static ReservationSummaryModel? fromEntity(ReservationSummary? entity) =>
      entity == null
          ? null
          : (ReservationSummaryModel()
            ..day = entity.day
            ..types =
                entity.types?.map((e) => enumToString(e)!).toList() ?? []);

  ReservationSummary toEntity() => ReservationSummary()
    ..day = this.day
    ..types = this
            .types
            ?.map((e) =>
                stringToEnum(ReservationType.values, e) ??
                ReservationType.reservation)
            .toList() ??
        [];
}
