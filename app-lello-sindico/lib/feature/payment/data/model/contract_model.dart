import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contract.dart';
part 'contract_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ContractModel {
  final int? id;
  final String? code;

  ContractModel({
    this.id,
    this.code,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  static ContractModel? fromEntity(ContractEntity? entity) {
    if (entity == null) return null;
    return ContractModel(
      id: entity.id,
      code: entity.code,
    );
  }

  ContractEntity toEntity() {
    return ContractEntity(
      id: id,
      code: code,
    );
  }
}
