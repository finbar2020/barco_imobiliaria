import 'package:lello/feature/payment/domain/entity/supplier_payment_form_bank_data.dart';

class SupplierPaymentForm {
  int? id;
  String? name;
  SupplierPaymentFormBankData? bankData;

  SupplierPaymentForm({
    this.id,
    this.name,
    this.bankData,
  });
  @override
  String toString() {
    return 'SupplierPaymentForm(id: $id, name: $name, bankData: $bankData)';
  }
}
