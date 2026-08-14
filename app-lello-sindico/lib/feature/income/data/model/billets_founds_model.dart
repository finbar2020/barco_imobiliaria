import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/domain/entity/billet_found.dart';

part 'billets_founds_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletsFoundsModel {
  String? description;
  double? value;

  BilletsFoundsModel();

  factory BilletsFoundsModel.fromJson(Map<String, dynamic> json) =>
      _$BilletsFoundsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletsFoundsModelToJson(this);

  static BilletsFoundsModel? fromEntity(BilletFound? entity) => entity == null
      ? null
      : (BilletsFoundsModel()
        ..description = entity.description
        ..value = entity.value);

  BilletFound toEntity() => BilletFound()
    ..description = this.description
    ..value = this.value;
}
