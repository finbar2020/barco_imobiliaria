import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_users.dart';

part 'payment_approval_users_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentApprovalUsersModel {
  String? description;
  bool? approved;
  bool? isCurrentUser;

  PaymentApprovalUsersModel();

  factory PaymentApprovalUsersModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApprovalUsersModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentApprovalUsersModelToJson(this);

  static PaymentApprovalUsersModel? fromEntity(ApprovalUsers? entity) =>
      entity == null
          ? null
          : (PaymentApprovalUsersModel()
            ..description = entity.description
            ..approved = entity.approved
            ..isCurrentUser = entity.isCurrentUser);

  ApprovalUsers toEntity() => ApprovalUsers(
        description: description,
        approved: approved,
        isCurrentUser: isCurrentUser,
      );
}
