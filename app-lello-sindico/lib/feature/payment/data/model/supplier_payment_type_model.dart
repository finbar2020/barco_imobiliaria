import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/payment_form_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_type.dart';
part 'supplier_payment_type_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierPaymentTypeModel {
  final int? id;
  final String? name;
  final List<PaymentFormModel?> paymentForms;

  SupplierPaymentTypeModel({
    this.id,
    this.name,
    this.paymentForms = const [],
  });

  factory SupplierPaymentTypeModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierPaymentTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierPaymentTypeModelToJson(this);

  static SupplierPaymentTypeModel? fromEntity(
      SupplierPaymentTypeEntity? entity) {
    if (entity == null) return null;
    return SupplierPaymentTypeModel(
      id: entity.id,
      name: entity.name,
      paymentForms: entity.paymentForms
          .map((paymentForm) => PaymentFormModel.fromEntity(paymentForm))
          .toList(),
    );
  }

  SupplierPaymentTypeEntity toEntity() {
    return SupplierPaymentTypeEntity(
      id: id,
      name: name,
      paymentForms: paymentForms.isNotEmpty
          ? paymentForms.map((paymentForm) => paymentForm!.toEntity()).toList()
          : [],
    );
  }
}
