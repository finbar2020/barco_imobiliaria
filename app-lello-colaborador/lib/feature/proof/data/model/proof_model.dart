import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proof_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProofModel {
  final int? nsr;
  final String dateTimeClockIn;
  final String? proofName;

  ProofModel({
    this.nsr,
    required this.dateTimeClockIn,
    required this.proofName,
  });

  factory ProofModel.fromJson(Map<String, dynamic> json) =>
      _$ProofModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProofModelToJson(this);

  static ProofModel fromEntity(ProofEntity proof) => ProofModel(
        nsr: proof.nsr,
        dateTimeClockIn: proof.dateTimeClockIn,
        proofName: proof.proofName,
      );

  ProofEntity toEntity() => ProofEntity(
        nsr: nsr,
        dateTimeClockIn: dateTimeClockIn,
        proofName: proofName,
      );
}
