import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_approver.dart';
part 'installment_approver_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstallmentApproverModel {
  String? name;
  String? status;
  String? approvalDate;
  String? approvalTime;
  String? channel;

  InstallmentApproverModel();

  factory InstallmentApproverModel.fromJson(Map<String, dynamic> json) =>
      _$InstallmentApproverModelFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentApproverModelToJson(this);

  static InstallmentApproverModel? fromEntity(
          PaymentInstallmentApprover? entity) =>
      entity == null
          ? null
          : (InstallmentApproverModel()
            ..name = entity.name
            ..status = entity.status
            ..approvalDate = entity.approvalDate
            ..approvalTime = entity.approvalTime
            ..channel = entity.channel);

  PaymentInstallmentApprover toEntity() => PaymentInstallmentApprover(
        name: name,
        status: status,
        approvalDate: approvalDate,
        approvalTime: approvalTime,
        channel: channel,
      );
}
