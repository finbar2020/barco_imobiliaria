import 'package:intl/intl.dart';

class DigitalMeeting {
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

  String get inicio =>
      "${DateFormat.yMd().format(this.dateStat!)} às ${DateFormat.jm().format(this.dateStat!)}";

  String get fim =>
      "${DateFormat.yMd().format(this.dateFinish!)} às ${DateFormat.jm().format(this.dateFinish!)}";

  String get reuniao => dateVirtualMeeting != null && dateVirtualMeeting!.millisecondsSinceEpoch > 0
      ? "${DateFormat.yMd().format(this.dateVirtualMeeting!)} às ${DateFormat.jm().format(this.dateVirtualMeeting!)}"
      : "";

  bool get validandoAcesso => this.validtUntul != null;
}
