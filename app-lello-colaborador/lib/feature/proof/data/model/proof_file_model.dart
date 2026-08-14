import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proof_file_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProofFileModel {
  final String contentBytes;

  ProofFileModel({
    required this.contentBytes,
  });

  factory ProofFileModel.fromJson(Map<String, dynamic> json) =>
      _$ProofFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProofFileModelToJson(this);

  static ProofFileModel fromEntity(ProofFileEntity proofFile) => ProofFileModel(
        contentBytes: proofFile.contentBytes,
      );

  ProofFileEntity toEntity() => ProofFileEntity(
        contentBytes: contentBytes,
      );
}
