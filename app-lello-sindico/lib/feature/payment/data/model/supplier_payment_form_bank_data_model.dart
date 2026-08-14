import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/bank_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_form_bank_data.dart';

part 'supplier_payment_form_bank_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierPaymentFormBankDataModel {
  BankModel? bank;
  String? agency;
  String? account;
  String? digit;
  String? type;

  SupplierPaymentFormBankDataModel();

  factory SupplierPaymentFormBankDataModel.fromJson(
          Map<String, dynamic> json) =>
      _$SupplierPaymentFormBankDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SupplierPaymentFormBankDataModelToJson(this);

  static SupplierPaymentFormBankDataModel? fromEntity(
          SupplierPaymentFormBankData? entity) =>
      entity == null
          ? null
          : (SupplierPaymentFormBankDataModel()
            ..bank = BankModel.fromEntity(entity.bank)
            ..agency = entity.agency
            ..account = entity.account
            ..digit = entity.digit
            ..type = entity.type);

  SupplierPaymentFormBankData toEntity() => SupplierPaymentFormBankData(
        bank: bank?.toEntity(),
        agency: agency,
        account: account,
        digit: digit,
        type: type,
      );
}
