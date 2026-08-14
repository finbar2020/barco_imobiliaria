import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/supplier_contract.dart';

part 'supplier_contract_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierContractModel {
  int? id;
  String? code;

  SupplierContractModel();

  factory SupplierContractModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierContractModelToJson(this);

  static SupplierContractModel? fromEntity(SupplierContract? entity) =>
      entity == null
          ? null
          : (SupplierContractModel()
            ..id = entity.id
            ..code = entity.code);

  SupplierContract toEntity() => SupplierContract(
        id: id,
        code: code,
      );
}
