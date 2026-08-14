import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

part 'acountability_grouped_account_entrie_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityGroupedAccaountEntrieModel {
  int id;
  DateTime date;
  double value;
  String signal;
  double credit;
  double debit;
  String history;

  AccountabilityGroupedAccaountEntrieModel(
      {required this.id,
      required this.date,
      required this.value,
      required this.signal,
      required this.credit,
      required this.debit,
      required this.history});

  factory AccountabilityGroupedAccaountEntrieModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityGroupedAccaountEntrieModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityGroupedAccaountEntrieModelToJson(this);

  static AccountabilityGroupedAccaountEntrieModel fromEntity(
          AccountabilityGroupedAccaountEntrie entity) =>
      (AccountabilityGroupedAccaountEntrieModel(
        id: entity.id,
        date: entity.date,
        value: entity.value,
        signal: entity.signal,
        credit: entity.credit,
        debit: entity.debit,
        history: entity.history,
      ));

  AccountabilityGroupedAccaountEntrie toEntity() =>
      AccountabilityGroupedAccaountEntrie(
        id: this.id,
        date: this.date,
        value: this.value,
        signal: this.signal,
        credit: this.credit,
        debit: this.debit,
        history: this.history,
      );
}
