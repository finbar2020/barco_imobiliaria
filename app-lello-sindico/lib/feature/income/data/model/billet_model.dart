// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/data/model/billets_founds_model.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';

import 'billets_instructions_model.dart';

part 'billet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletModel {
  final String? id;
  final UnitModel? unit;
  final double? value;
  final DateTime? period;
  final DateTime? bankPeriod;
  final String? situation;
  final int? invoice;
  final String? nrBillet;
  final String? code;
  final BilletsInstructionsModel? instructions;
  final List<BilletsFoundsModel?>? founds;

  factory BilletModel.fromJson(Map<String, dynamic> json) =>
      _$BilletModelFromJson(json);

  BilletModel({
    required this.id,
    required this.unit,
    required this.value,
    required this.period,
    required this.bankPeriod,
    required this.situation,
    required this.invoice,
    required this.nrBillet,
    required this.code,
    required this.instructions,
    required this.founds,
  });

  Map<String, dynamic> toJson() => _$BilletModelToJson(this);

  static BilletModel? fromEntity(Billet? entity) => entity == null
      ? null
      : (BilletModel(
          id: entity.id,
          unit: UnitModel.fromEntity(entity.unit),
          value: entity.value,
          period: entity.period,
          bankPeriod: entity.bankPeriod,
          situation: entity.situation,
          invoice: entity.invoice,
          nrBillet: entity.nrBillet,
          code: entity.code,
          instructions:
              BilletsInstructionsModel.fromEntity(entity.instructions),
          founds: entity.founds
                  ?.map((found) => BilletsFoundsModel.fromEntity(found))
                  .toList() ??
              [],
        ));

  Billet toEntity() {
    return Billet(
      id: id,
      unit: unit?.toEntity(),
      value: value,
      period: period,
      bankPeriod: bankPeriod,
      situation: situation,
      nrBillet: nrBillet,
      invoice: invoice,
      code: code,
      instructions: instructions?.toEntity(),
      founds: founds?.map((found) => found!.toEntity()).toList() ?? [],
    );
  }

  BilletModel copyWith({
    String? id,
    UnitModel? unit,
    double? value,
    DateTime? period,
    DateTime? bankPeriod,
    String? situation,
    int? invoice,
    String? nrBillet,
    String? code,
    BilletsInstructionsModel? instructions,
    List<BilletsFoundsModel?>? founds,
  }) {
    return BilletModel(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      value: value ?? this.value,
      period: period ?? this.period,
      bankPeriod: bankPeriod ?? this.bankPeriod,
      situation: situation ?? this.situation,
      invoice: invoice ?? this.invoice,
      nrBillet: nrBillet ?? this.nrBillet,
      code: code ?? this.code,
      instructions: instructions ?? this.instructions,
      founds: founds ?? this.founds,
    );
  }
}
