import 'package:intl/intl.dart';

class Mailing {
  final String? id;
  final DateTime? pickUpDate;
  final DateTime? arrivalDate;
  final String? addressee;
  final String? category;
  final String? size;
  final String? status;
  final String? pickUpResident;
  final String? notificationParameter;
  final String? photo;
  final String? trackingCode;
  final String? description;
  final String? observation;

  bool highlight = false;

  Mailing({
    this.id,
    this.pickUpDate,
    this.arrivalDate,
    this.addressee,
    this.category,
    this.size,
    this.status,
    this.pickUpResident,
    this.notificationParameter,
    this.photo,
    this.trackingCode,
    this.description,
    this.observation,
  });

  String get statusMailing {
    switch (this.status) {
      case "PENDENTE":
        return "mailing_available";
      case "RETIRADA":
        return "mailing_withdrawn";
      default:
        return "";
    }
  }

  bool get retirado => this.status == "RETIRADA";

  String get arrivalFullDate => DateFormat.yMd().format(this.arrivalDate!);
  String get arrivalHourMinute => DateFormat.Hm().format(this.arrivalDate!);

  String get pickUpFullDate =>
      DateFormat.yMd().format(this.pickUpDate ?? DateTime.now());
  String get pickUpHourMinute =>
      DateFormat.Hm().format(this.pickUpDate ?? DateTime.now());
}
