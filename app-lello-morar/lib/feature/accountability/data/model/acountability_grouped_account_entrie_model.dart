import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

part 'acountability_grouped_account_entrie_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityGroupedAccountEntrieModel {
  int id;
  DateTime date;
  double value;
  String signal;
  double credit;
  double debit;
  String history;

  AccountabilityGroupedAccountEntrieModel(
      {required this.id,
      required this.date,
      required this.value,
      required this.signal,
      required this.credit,
      required this.debit,
      required this.history});

  factory AccountabilityGroupedAccountEntrieModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityGroupedAccountEntrieModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityGroupedAccountEntrieModelToJson(this);

  static AccountabilityGroupedAccountEntrieModel fromEntity(
          AccountabilityGroupedAccountEntrie entity) =>
      (AccountabilityGroupedAccountEntrieModel(
        id: entity.id,
        date: entity.date,
        value: entity.value,
        signal: entity.signal,
        credit: entity.credit,
        debit: entity.debit,
        history: entity.history,
      ));

  AccountabilityGroupedAccountEntrie toEntity() =>
      AccountabilityGroupedAccountEntrie(
        id: this.id,
        date: this.date,
        value: this.value,
        signal: this.signal,
        credit: this.credit,
        debit: this.debit,
        history: this.history,
      );
}
