import 'package:lello/feature/payment/domain/entity/payment_form.dart';

class SupplierPaymentTypeEntity {
  final int? id;
  final String? name;
  final List<PaymentFormEntity?> paymentForms;

  SupplierPaymentTypeEntity({
    this.id,
    this.name,
    this.paymentForms = const [],
  });

  SupplierPaymentTypeEntity copyWith({
    int? id,
    String? name,
    List<PaymentFormEntity?>? paymentForms,
  }) {
    return SupplierPaymentTypeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      paymentForms: paymentForms ?? this.paymentForms,
    );
  }
}
