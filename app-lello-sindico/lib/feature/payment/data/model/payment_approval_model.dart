import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_type.dart';

part 'payment_approval_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentApprovalModel {
  String? id;
  String? paymentId;
  String? type;
  String? accountId;
  String? paymentHistory;
  String? reason;

  PaymentApprovalModel();

  factory PaymentApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApprovalModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentApprovalModelToJson(this);

  static PaymentApprovalModel? fromEntity(PaymentApproval? entity) =>
      entity == null
          ? null
          : (PaymentApprovalModel()
            ..id = entity.id
            ..paymentId = entity.paymentId
            ..type = enumToString(entity.type)
            ..accountId = entity.accountId
            ..paymentHistory = entity.paymentHistory
            ..reason = entity.reason);

  PaymentApproval toEntity() => PaymentApproval(
        id: this.id,
        paymentId: this.paymentId,
        type: stringToEnum(PaymentApprovalType.values, this.type!) ??
            PaymentApprovalType.approve,
        accountId: this.accountId,
        paymentHistory: this.paymentHistory,
        reason: this.reason,
      );
}
