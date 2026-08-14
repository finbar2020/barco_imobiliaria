import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';

part 'agreement_quote_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementQuoteModel {
  String? id;
  DateTime? dueDate;
  double originValue;
  double fineValue;
  double feeValue;
  double honoraryValue;
  String? overdueMessage;

  AgreementQuoteModel({
    this.id,
    this.dueDate,
    this.originValue = 0.0,
    this.fineValue = 0.0,
    this.feeValue = 0.0,
    this.honoraryValue = 0.0,
    this.overdueMessage,
  });

  factory AgreementQuoteModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementQuoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementQuoteModelToJson(this);

  static AgreementQuoteModel fromEntity(AgreementQuote entity) =>
      (AgreementQuoteModel(
        id: entity.id,
        dueDate: entity.dueDate,
        originValue: entity.originValue,
        fineValue: entity.fineValue,
        feeValue: entity.feeValue,
        honoraryValue: entity.honoraryValue,
        overdueMessage: entity.overdueMessage,
      ));

  AgreementQuote toEntity() => AgreementQuote(
        id: this.id,
        dueDate: this.dueDate,
        originValue: this.originValue,
        fineValue: this.fineValue,
        feeValue: this.feeValue,
        honoraryValue: this.honoraryValue,
        overdueMessage: this.overdueMessage,
      );
}
