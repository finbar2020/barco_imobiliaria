import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

part 'digital_meeting_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DigitalMeetingModel {
  String? idMeetingUser;
  String? idMeeting;
  String? nameUsuario;
  DateTime? dateFirstAccess;
  DateTime? dateLastAccess;
  String? token;
  String? login;
  String? email;
  // Long idMeetingType;
  DateTime? dateStat;
  DateTime? dateFinish;
  DateTime? dateVirtualMeeting;
  String? tokenGuest;
  String? idVirtualMeeting;
  double? idDigitalMeetingType;
  String? presidentName;
  double? idStatusMeeting;
  String? statusMeeting;
  String? idCondo;
  String? name;
  String? reference;
  String? type;
  String? cNPJ;
  String? idWallet;
  String? nameWallet;
  String? idRegion;
  String? nameRegion;
  String? idBusinessUnit;
  String? nameBusinessUnit;
  String? nameConsultant;
  String? emailConsultant;
  String? nameManager;
  String? emailManager;
  String? flagActive;
  String? tokenHash;
  String? link;
  DateTime? validtUntul;
  String? userAuth;

  DigitalMeetingModel();

  factory DigitalMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$DigitalMeetingModelFromJson(json);
  Map<String, dynamic> toJson() => _$DigitalMeetingModelToJson(this);

  static DigitalMeetingModel? fromEntity(DigitalMeeting? entity) =>
      entity == null
          ? null
          : (DigitalMeetingModel()
            ..idMeetingUser = entity.idMeetingUser
            ..idMeeting = entity.idMeeting
            ..nameUsuario = entity.nameUsuario
            ..dateFirstAccess = entity.dateFirstAccess
            ..dateLastAccess = entity.dateLastAccess
            ..token = entity.token
            ..login = entity.login
            ..email = entity.email
            // ..idMeetingType = entity.idMeetingType
            ..dateStat = entity.dateStat
            ..dateFinish = entity.dateFinish
            ..dateVirtualMeeting = entity.dateVirtualMeeting
            ..tokenGuest = entity.tokenGuest
            ..idVirtualMeeting = entity.idVirtualMeeting
            ..idDigitalMeetingType = entity.idDigitalMeetingType
            ..presidentName = entity.presidentName
            ..idStatusMeeting = entity.idStatusMeeting
            ..statusMeeting = entity.statusMeeting
            ..idCondo = entity.idCondo
            ..name = entity.name
            ..reference = entity.reference
            ..type = entity.type
            ..cNPJ = entity.cNPJ
            ..idWallet = entity.idWallet
            ..nameWallet = entity.nameWallet
            ..idRegion = entity.idRegion
            ..nameRegion = entity.nameRegion
            ..idBusinessUnit = entity.idBusinessUnit
            ..nameBusinessUnit = entity.nameBusinessUnit
            ..nameConsultant = entity.nameConsultant
            ..emailConsultant = entity.emailConsultant
            ..nameManager = entity.nameManager
            ..emailManager = entity.emailManager
            ..flagActive = entity.flagActive
            ..tokenHash = entity.tokenHash
            ..link = entity.link
            ..validtUntul = entity.validtUntul
            ..userAuth = entity.userAuth);

  DigitalMeeting toEntity() => DigitalMeeting()
// ..idMeetingUser = entity.idMeetingUser
    ..idMeeting = this.idMeeting
    ..nameUsuario = this.nameUsuario
    ..dateFirstAccess = this.dateFirstAccess
    ..dateLastAccess = this.dateLastAccess
    ..token = this.token
    ..login = this.login
    ..email = this.email
    // ..idMeetingType = this.idMeetingType
    ..dateStat = this.dateStat
    ..dateFinish = this.dateFinish
    ..dateVirtualMeeting = this.dateVirtualMeeting
    ..tokenGuest = this.tokenGuest
    ..idVirtualMeeting = this.idVirtualMeeting
    ..idDigitalMeetingType = this.idDigitalMeetingType
    ..presidentName = this.presidentName
    ..idStatusMeeting = this.idStatusMeeting
    ..statusMeeting = this.statusMeeting
    ..idCondo = this.idCondo
    ..name = this.name
    ..reference = this.reference
    ..type = this.type
    ..cNPJ = this.cNPJ
    ..idWallet = this.idWallet
    ..nameWallet = this.nameWallet
    ..idRegion = this.idRegion
    ..nameRegion = this.nameRegion
    ..idBusinessUnit = this.idBusinessUnit
    ..nameBusinessUnit = this.nameBusinessUnit
    ..nameConsultant = this.nameConsultant
    ..emailConsultant = this.emailConsultant
    ..nameManager = this.nameManager
    ..emailManager = this.emailManager
    ..flagActive = this.flagActive
    ..tokenHash = this.tokenHash
    ..link = this.link
    ..validtUntul = this.validtUntul
    ..userAuth = this.userAuth;

  @override
  String toString() {
    return 'DigitalMeetingModel(idMeetingUser: $idMeetingUser, idMeeting: $idMeeting, nameUsuario: $nameUsuario, dateFirstAccess: $dateFirstAccess, dateLastAccess: $dateLastAccess, token: $token, login: $login, email: $email, dateStat: $dateStat, dateFinish: $dateFinish, dateVirtualMeeting: $dateVirtualMeeting, tokenGuest: $tokenGuest, idVirtualMeeting: $idVirtualMeeting, idDigitalMeetingType: $idDigitalMeetingType, presidentName: $presidentName, idStatusMeeting: $idStatusMeeting, statusMeeting: $statusMeeting, idCondo: $idCondo, name: $name, reference: $reference, type: $type, cNPJ: $cNPJ, idWallet: $idWallet, nameWallet: $nameWallet, idRegion: $idRegion, nameRegion: $nameRegion, idBusinessUnit: $idBusinessUnit, nameBusinessUnit: $nameBusinessUnit, nameConsultant: $nameConsultant, emailConsultant: $emailConsultant, nameManager: $nameManager, emailManager: $emailManager, flagActive: $flagActive, tokenHash: $tokenHash, link: $link, validtUntul: $validtUntul, userAuth: $userAuth)';
  }
}
