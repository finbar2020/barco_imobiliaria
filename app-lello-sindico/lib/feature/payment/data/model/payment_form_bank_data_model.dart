import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/bank_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_form_bank_data.dart';
part 'payment_form_bank_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentFormBankDataModel {
  final BankModel? bank;
  final String? agency;
  final String? account;
  final String? digit;
  final String? type;

  PaymentFormBankDataModel({
    this.bank,
    this.agency,
    this.account,
    this.digit,
    this.type,
  });

  factory PaymentFormBankDataModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentFormBankDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentFormBankDataModelToJson(this);

  static PaymentFormBankDataModel? fromEntity(
      PaymentFormBankDataEntity? entity) {
    if (entity == null) return null;
    return PaymentFormBankDataModel(
      bank: BankModel.fromEntity(entity.bank),
      agency: entity.agency,
      account: entity.account,
      digit: entity.digit,
      type: entity.type,
    );
  }

  PaymentFormBankDataEntity toEntity() {
    return PaymentFormBankDataEntity(
      bank: bank?.toEntity(),
      agency: agency,
      account: account,
      digit: digit,
      type: type,
    );
  }
}
