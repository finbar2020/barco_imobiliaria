import 'package:lello/feature/payment/domain/entity/payment_form_bank_data.dart';

class PaymentFormEntity {
  final int? id;
  final String? name;
  final PaymentFormBankDataEntity? bankData;

  PaymentFormEntity({
    this.id,
    this.name,
    this.bankData,
  });

  PaymentFormEntity copyWith({
    int? id,
    String? name,
    PaymentFormBankDataEntity? bankData,
  }) {
    return PaymentFormEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      bankData: bankData ?? this.bankData,
    );
  }
}
