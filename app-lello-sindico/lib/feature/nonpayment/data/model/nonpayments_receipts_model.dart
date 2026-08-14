import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_receipts.dart';

part 'nonpayments_receipts_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NonPaymentsReceiptsModel {
  String? receipt;
  DateTime? period;
  double? valueLiquid;
  double? value;
  double? penalty;
  double? interest;

  NonPaymentsReceiptsModel();

  factory NonPaymentsReceiptsModel.fromJson(Map<String, dynamic> json) =>
      _$NonPaymentsReceiptsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NonPaymentsReceiptsModelToJson(this);

  static NonPaymentsReceiptsModel? fromEntity(NonPaymentsReceipts? entity) =>
      entity == null
          ? null
          : (NonPaymentsReceiptsModel()
            ..receipt = entity.receipt
            ..period = entity.period
            ..value = entity.value
            ..valueLiquid = entity.valueLiquid
            ..penalty = entity.penalty
            ..interest = entity.interest);

  NonPaymentsReceipts toEntity() => NonPaymentsReceipts()
    ..receipt = this.receipt
    ..valueLiquid = this.valueLiquid
    ..period = this.period
    ..value = this.value
    ..valueLiquid = this.valueLiquid
    ..penalty = this.penalty
    ..interest = this.interest;
}
