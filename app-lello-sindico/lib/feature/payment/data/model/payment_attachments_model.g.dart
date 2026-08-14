// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_attachments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAttachmentsModel _$PaymentAttachmentsModelFromJson(
        Map<String, dynamic> json) =>
    PaymentAttachmentsModel()
      ..type = json['type'] as String?
      ..content = json['content'] as String?
      ..name = json['name'] as String?;

Map<String, dynamic> _$PaymentAttachmentsModelToJson(
        PaymentAttachmentsModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'name': instance.name,
    };
