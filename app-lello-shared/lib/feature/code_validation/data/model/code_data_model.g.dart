// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeDataModel _$CodeDataModelFromJson(Map<String, dynamic> json) =>
    CodeDataModel(
      emailContacts: (json['email_contacts'] as List<dynamic>?)
          ?.map((e) => CodeDataContactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      smsContacts: (json['sms_contacts'] as List<dynamic>?)
          ?.map((e) => CodeDataContactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      registered: json['registered'] as bool?,
    );

Map<String, dynamic> _$CodeDataModelToJson(CodeDataModel instance) =>
    <String, dynamic>{
      'email_contacts': instance.emailContacts,
      'sms_contacts': instance.smsContacts,
      'registered': instance.registered,
    };
