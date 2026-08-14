// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalMeetingModel _$DigitalMeetingModelFromJson(Map<String, dynamic> json) =>
    DigitalMeetingModel()
      ..idMeetingUser = json['id_meeting_user'] as String?
      ..idMeeting = json['id_meeting'] as String?
      ..nameUsuario = json['name_usuario'] as String?
      ..dateFirstAccess = json['date_first_access'] == null
          ? null
          : DateTime.parse(json['date_first_access'] as String)
      ..dateLastAccess = json['date_last_access'] == null
          ? null
          : DateTime.parse(json['date_last_access'] as String)
      ..token = json['token'] as String?
      ..login = json['login'] as String?
      ..email = json['email'] as String?
      ..dateStat = json['date_stat'] == null
          ? null
          : DateTime.parse(json['date_stat'] as String)
      ..dateFinish = json['date_finish'] == null
          ? null
          : DateTime.parse(json['date_finish'] as String)
      ..dateVirtualMeeting = json['date_virtual_meeting'] == null
          ? null
          : DateTime.parse(json['date_virtual_meeting'] as String)
      ..tokenGuest = json['token_guest'] as String?
      ..idVirtualMeeting = json['id_virtual_meeting'] as String?
      ..idDigitalMeetingType =
          (json['id_digital_meeting_type'] as num?)?.toDouble()
      ..presidentName = json['president_name'] as String?
      ..idStatusMeeting = (json['id_status_meeting'] as num?)?.toDouble()
      ..statusMeeting = json['status_meeting'] as String?
      ..idCondo = json['id_condo'] as String?
      ..name = json['name'] as String?
      ..reference = json['reference'] as String?
      ..type = json['type'] as String?
      ..cNPJ = json['c_n_p_j'] as String?
      ..idWallet = json['id_wallet'] as String?
      ..nameWallet = json['name_wallet'] as String?
      ..idRegion = json['id_region'] as String?
      ..nameRegion = json['name_region'] as String?
      ..idBusinessUnit = json['id_business_unit'] as String?
      ..nameBusinessUnit = json['name_business_unit'] as String?
      ..nameConsultant = json['name_consultant'] as String?
      ..emailConsultant = json['email_consultant'] as String?
      ..nameManager = json['name_manager'] as String?
      ..emailManager = json['email_manager'] as String?
      ..flagActive = json['flag_active'] as String?
      ..tokenHash = json['token_hash'] as String?
      ..link = json['link'] as String?
      ..validtUntul = json['validt_untul'] == null
          ? null
          : DateTime.parse(json['validt_untul'] as String)
      ..userAuth = json['user_auth'] as String?;

Map<String, dynamic> _$DigitalMeetingModelToJson(
        DigitalMeetingModel instance) =>
    <String, dynamic>{
      'id_meeting_user': instance.idMeetingUser,
      'id_meeting': instance.idMeeting,
      'name_usuario': instance.nameUsuario,
      'date_first_access': instance.dateFirstAccess?.toIso8601String(),
      'date_last_access': instance.dateLastAccess?.toIso8601String(),
      'token': instance.token,
      'login': instance.login,
      'email': instance.email,
      'date_stat': instance.dateStat?.toIso8601String(),
      'date_finish': instance.dateFinish?.toIso8601String(),
      'date_virtual_meeting': instance.dateVirtualMeeting?.toIso8601String(),
      'token_guest': instance.tokenGuest,
      'id_virtual_meeting': instance.idVirtualMeeting,
      'id_digital_meeting_type': instance.idDigitalMeetingType,
      'president_name': instance.presidentName,
      'id_status_meeting': instance.idStatusMeeting,
      'status_meeting': instance.statusMeeting,
      'id_condo': instance.idCondo,
      'name': instance.name,
      'reference': instance.reference,
      'type': instance.type,
      'c_n_p_j': instance.cNPJ,
      'id_wallet': instance.idWallet,
      'name_wallet': instance.nameWallet,
      'id_region': instance.idRegion,
      'name_region': instance.nameRegion,
      'id_business_unit': instance.idBusinessUnit,
      'name_business_unit': instance.nameBusinessUnit,
      'name_consultant': instance.nameConsultant,
      'email_consultant': instance.emailConsultant,
      'name_manager': instance.nameManager,
      'email_manager': instance.emailManager,
      'flag_active': instance.flagActive,
      'token_hash': instance.tokenHash,
      'link': instance.link,
      'validt_untul': instance.validtUntul?.toIso8601String(),
      'user_auth': instance.userAuth,
    };
