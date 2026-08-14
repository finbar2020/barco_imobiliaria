import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';

part 'payment_installments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentInstallmentsModel {
  double? value;
  DateTime? dueDate;

  PaymentInstallmentsModel();

  factory PaymentInstallmentsModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstallmentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentInstallmentsModelToJson(this);

  static PaymentInstallmentsModel? fromEntity(PaymentInstallments? entity) =>
      entity == null
          ? null
          : (PaymentInstallmentsModel()
            ..value = entity.value
            ..dueDate = entity.dueDate);

  PaymentInstallments toEntity() =>
      PaymentInstallments(value: value, dueDate: dueDate);
}
