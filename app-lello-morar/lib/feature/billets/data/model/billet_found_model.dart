import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/billets/domain/entity/billet_found.dart';

part 'billet_found_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletFoundModel {
  String? description;
  double? value;

  BilletFoundModel({
    this.description,
    this.value,
  });

  factory BilletFoundModel.fromJson(Map<String, dynamic> json) =>
      _$BilletFoundModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletFoundModelToJson(this);

  static BilletFoundModel fromEntity(BilletFound entity) => (BilletFoundModel()
    ..description = entity.description
    ..value = entity.value);

  BilletFound toEntity() => BilletFound()
    ..description = this.description
    ..value = this.value;
}
