import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/domain/entity/billets_instructions.dart';

part 'billets_instructions_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletsInstructionsModel {
  String? lateBillet;
  String? secondBillet;
  String? afterMaturity;

  BilletsInstructionsModel();

  factory BilletsInstructionsModel.fromJson(Map<String, dynamic> json) =>
      _$BilletsInstructionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletsInstructionsModelToJson(this);

  static BilletsInstructionsModel? fromEntity(BilletsInstructions? entity) =>
      entity == null
          ? null
          : (BilletsInstructionsModel()
            ..lateBillet = entity.lateBillet
            ..secondBillet = entity.secondBillet
            ..afterMaturity = entity.afterMaturity);

  BilletsInstructions toEntity() => BilletsInstructions()
    ..lateBillet = this.lateBillet
    ..secondBillet = this.secondBillet
    ..afterMaturity = this.afterMaturity;
}
