// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_approval_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApprovalUsersModel _$PaymentApprovalUsersModelFromJson(
        Map<String, dynamic> json) =>
    PaymentApprovalUsersModel()
      ..description = json['description'] as String?
      ..approved = json['approved'] as bool?
      ..isCurrentUser = json['is_current_user'] as bool?;

Map<String, dynamic> _$PaymentApprovalUsersModelToJson(
        PaymentApprovalUsersModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'approved': instance.approved,
      'is_current_user': instance.isCurrentUser,
    };
