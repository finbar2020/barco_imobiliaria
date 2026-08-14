import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';

part 'agreement_payment_method_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementPaymentMethodModel {
  AgreementPaymentMethodEnum type;
  bool enabled;
  String text;
  String description;
  String disabledDescription;

  AgreementPaymentMethodModel(
      {required this.type,
      required this.enabled,
      required this.text,
      required this.description,
      required this.disabledDescription});

  factory AgreementPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementPaymentMethodModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementPaymentMethodModelToJson(this);

  static AgreementPaymentMethodModel fromEntity(
          AgreementPaymentMethod entity) =>
      (AgreementPaymentMethodModel(
        type: entity.type,
        enabled: entity.enabled,
        text: entity.text,
        description: entity.description,
        disabledDescription: entity.disabledDescription,
      ));

  AgreementPaymentMethod toEntity() => AgreementPaymentMethod(
        type: this.type,
        enabled: this.enabled,
        text: this.text,
        description: this.description,
        disabledDescription: this.disabledDescription,
      );
}
