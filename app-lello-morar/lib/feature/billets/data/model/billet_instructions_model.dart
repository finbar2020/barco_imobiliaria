import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/billets/domain/entity/billet_instructions.dart';

part 'billet_instructions_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletInstructionsModel {
  String? lateBillet;
  String? secondBillet;
  String? afterMaturity;

  BilletInstructionsModel({
    this.lateBillet,
    this.secondBillet,
    this.afterMaturity,
  });

  factory BilletInstructionsModel.fromJson(Map<String, dynamic> json) =>
      _$BilletInstructionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletInstructionsModelToJson(this);

  static BilletInstructionsModel? fromEntity(BilletInstructions? entity) =>
      entity == null
          ? null
          : (BilletInstructionsModel()
            ..lateBillet = entity.lateBillet
            ..secondBillet = entity.secondBillet
            ..afterMaturity = entity.afterMaturity);

  BilletInstructions toEntity() => BilletInstructions()
    ..lateBillet = this.lateBillet
    ..secondBillet = this.secondBillet
    ..afterMaturity = this.afterMaturity;
}
