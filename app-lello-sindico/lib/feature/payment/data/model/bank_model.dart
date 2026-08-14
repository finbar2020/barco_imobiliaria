import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/bank.dart';

part 'bank_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BankModel {
  int? id;
  String? name;
  String? code;

  BankModel();

  factory BankModel.fromJson(Map<String, dynamic> json) =>
      _$BankModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankModelToJson(this);

  static BankModel? fromEntity(Bank? entity) => entity == null
      ? null
      : (BankModel()
        ..id = entity.id
        ..name = entity.name
        ..code = entity.code);

  Bank toEntity() => Bank(
        id: id,
        name: name,
        code: code,
      );
}
