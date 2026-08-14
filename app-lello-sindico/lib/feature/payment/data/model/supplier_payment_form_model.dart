import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/supplier_payment_form_bank_data_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_form.dart';

part 'supplier_payment_form_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierPaymentFormModel {
  int? id;
  String? name;
  SupplierPaymentFormBankDataModel? bankData;

  SupplierPaymentFormModel();

  factory SupplierPaymentFormModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierPaymentFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierPaymentFormModelToJson(this);

  static SupplierPaymentFormModel? fromEntity(SupplierPaymentForm? entity) =>
      entity == null
          ? null
          : (SupplierPaymentFormModel()
            ..id = entity.id
            ..name = entity.name
            ..bankData =
                SupplierPaymentFormBankDataModel.fromEntity(entity.bankData));

  SupplierPaymentForm toEntity() => SupplierPaymentForm(
        id: id,
        name: name,
        bankData: bankData?.toEntity(),
      );
}
