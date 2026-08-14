import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_debits.dart';

part 'condominium_balance_detail_debits_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DebitsModel {
  String? id;
  String? name;
  DateTime? period;
  String? type;
  double? previousBalance;
  double? balance;
  double? accountBalance;
  double? debit;
  double? credits;

  DebitsModel();

  factory DebitsModel.fromJson(Map<String, dynamic> json) =>
      _$DebitsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DebitsModelToJson(this);

  static DebitsModel? fromEntity(Debits? entity) => entity == null
      ? null
      : (DebitsModel()
        ..id = entity.id
        ..name = entity.name
        ..period = entity.period
        ..type = entity.type
        ..previousBalance = entity.previousBalance
        ..balance = entity.balance
        ..accountBalance = entity.accountBalance
        ..debit = entity.debit
        ..credits = entity.credits);

  Debits toEntity() => Debits()
    ..id = this.id
    ..name = this.name
    ..period = this.period
    ..type = this.type
    ..previousBalance = this.previousBalance
    ..balance = this.balance
    ..accountBalance = this.accountBalance
    ..debit = this.debit
    ..credits = this.credits;
}
