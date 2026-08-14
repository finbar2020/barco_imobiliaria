// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

import 'nonpayments_detail_model.dart';

part 'nonpayments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NonPaymentModel {
  final DateTime? positionOfDay;
  final int? quotes;
  final double? value;
  final double? valueWithPenalty;
  final double? penalty;
  final List<NonPaymentsDetailModel?>? details;

  NonPaymentModel({
    this.positionOfDay,
    this.quotes,
    this.value,
    this.valueWithPenalty,
    this.penalty,
    this.details,
  });

  factory NonPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$NonPaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$NonPaymentModelToJson(this);

  static NonPaymentModel? fromEntity(NonPayment? entity) => entity == null
      ? null
      : (NonPaymentModel(
          positionOfDay: entity.positionOfDay,
          quotes: entity.quotes,
          value: entity.value,
          penalty: entity.penalty,
          valueWithPenalty: entity.valueWithPenalty,
          details: entity.details
                  ?.map(
                    (entity) => NonPaymentsDetailModel.fromEntity(entity),
                  )
                  .toList() ??
              []));

  NonPayment toEntity() {
    return NonPayment(
      positionOfDay: positionOfDay,
      quotes: quotes,
      value: value,
      penalty: penalty,
      valueWithPenalty: valueWithPenalty,
      details: details?.map((model) => model?.toEntity()).toList() ?? [],
    );
  }

  NonPaymentModel copyWith({
    DateTime? positionOfDay,
    int? quotes,
    double? value,
    double? valueWithPenalty,
    double? penalty,
    List<NonPaymentsDetailModel?>? details,
  }) {
    return NonPaymentModel(
      positionOfDay: positionOfDay ?? this.positionOfDay,
      quotes: quotes ?? this.quotes,
      value: value ?? this.value,
      valueWithPenalty: valueWithPenalty ?? this.valueWithPenalty,
      penalty: penalty ?? this.penalty,
      details: details ?? this.details,
    );
  }
}
