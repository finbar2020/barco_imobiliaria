import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';

part 'agreements_recommendation_payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementRecommendationPaymentModel {
  String? paymentMethod;
  int? dueDay;
  int installmentQtd;
  bool recomendation;

  AgreementRecommendationPaymentModel({
    this.paymentMethod,
    this.dueDay,
    required this.installmentQtd,
    required this.recomendation,
  });

  factory AgreementRecommendationPaymentModel.fromJson(
          Map<String, dynamic> json) =>
      _$AgreementRecommendationPaymentModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AgreementRecommendationPaymentModelToJson(this);

  static AgreementRecommendationPaymentModel? fromEntity(
          AgreementRecommendationPayment? entity) =>
      entity == null
          ? null
          : (AgreementRecommendationPaymentModel(
              paymentMethod: entity.paymentMethod,
              dueDay: entity.dueDay,
              installmentQtd: entity.installmentQtd,
              recomendation: entity.recomendation));
  AgreementRecommendationPayment toEntity() => AgreementRecommendationPayment(
        paymentMethod: this.paymentMethod,
        dueDay: this.dueDay,
        installmentQtd: this.installmentQtd,
        recomendation: this.recomendation,
      );
}
