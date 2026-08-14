import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/account/domain/entity/account.dart';

part 'account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountModel {
  String? id;
  String? number;
  String? name;
  String? condominiumId;

  AccountModel();

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  static AccountModel? fromEntity(Account? entity) => entity != null
      ? (AccountModel()
        ..id = entity.id
        ..name = entity.name
        ..condominiumId = entity.condominiumId)
      : null;

  Account toEntity() => Account()
    ..id = this.id
    ..name = this.name
    ..condominiumId = this.condominiumId;
}
