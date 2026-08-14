import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_summary.dart';

part 'condominium_balance_detail_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SummaryModel {
  String? name;
  double? debits;
  double? credits;

  SummaryModel();

  factory SummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryModelToJson(this);

  static SummaryModel? fromEntity(Summary? entity) => entity == null
      ? null
      : (SummaryModel()
        ..name = entity.name
        ..debits = entity.debits
        ..credits = entity.credits);

  Summary toEntity() => Summary()
    ..name = this.name
    ..debits = this.debits
    ..credits = this.credits;
}
