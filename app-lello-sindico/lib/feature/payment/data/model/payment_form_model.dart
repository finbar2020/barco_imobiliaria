import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/payment_form_bank_data_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_form.dart';
part 'payment_form_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentFormModel {
  final int? id;
  final String? name;
  final PaymentFormBankDataModel? bankData;

  PaymentFormModel({
    this.id,
    this.name,
    this.bankData,
  });

  factory PaymentFormModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentFormModelToJson(this);

  static PaymentFormModel? fromEntity(PaymentFormEntity? entity) {
    if (entity == null) return null;
    return PaymentFormModel(
      id: entity.id,
      name: entity.name,
      bankData: PaymentFormBankDataModel.fromEntity(entity.bankData),
    );
  }

  PaymentFormEntity toEntity() {
    return PaymentFormEntity(
      id: id,
      name: name,
      bankData: bankData?.toEntity(),
    );
  }
}
