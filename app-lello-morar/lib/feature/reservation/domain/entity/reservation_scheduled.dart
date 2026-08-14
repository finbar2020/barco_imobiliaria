import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/reservation/domain/entity/reservatio_chargin.dart';

class ReservationScheduled {
  String? areaId;
  int? id;
  String? cancelingDate;
  String? inclusionDate;
  String? sendedEmailPaidBilletDate;
  String? area;
  int? flagUtitlityTerm;
  double? reservationValue;
  String? startReservationDate;
  String? endReservationDate;
  String? observations;
  int? unitId;
  String? unitName;
  String? reservationTypeDate;
  String? receipt;
  String? emailSendDate;
  String? updateDate;
  int? userAlteration;
  String? reference;
  String? reservationType;
  int? idStatus;
  ReservationCharging? flagChargingForm;
  String? reservationTypeDescription;
  ReservationCharging? charginFormDescription;
  String? idStatusDecription;
  String? flagChargingStatus;
  double? billetValue;
  DateTime? billetPeriod;
  String? billetSituation;
  int? billetInvoice;
  String? billetCode;
  String? canCancelUntil;

  bool highlight = false;

  String get diaMes => this.startReservationDate!.substring(0, 5);
  String get horaInicial => this.startReservationDate!.substring(11, 13);
  String get horaFinal => this.endReservationDate!.substring(11, 13);

  String get vencidomentoMesDia => DateFormat.Md().format(this.billetPeriod!);
  String get vencimento => DateFormat.yMd().format(this.billetPeriod!);

  String get tituloReserva {
    String titulo = area!;
    if (flagChargingForm != null) {
      titulo =
          "$area - ${NumberFormat.currency(symbol: "R\$").format(reservationValue ?? 0.0)}";
    }
    if (flagChargingForm == ReservationCharging.quota) {
      titulo = "$area";
    }
    return titulo;
  }

  String get subTituloReserva {
    String titulo = "";
    if (flagChargingForm != null) {
      titulo = "Vence em $vencidomentoMesDia";
    }
    if (flagChargingForm == ReservationCharging.quota) {
      titulo = "A taxa de reserva virá junto à sua cota condominial";
    }
    return titulo;
  }

  String get status {
    if (idStatus != null) {
      switch (idStatus) {
        case 83:
        case 7610:
        case 7640:
        case 7650:
          return "space_reserved";
        case 90:
          return "income_billet_detail_situation_canceled";
        case 7620:
          return "space_reserved_waiting_payment";
        case 7630:
          return "space_reserved_waiting_raffle";
      }
    }
    return "income_billet_detail_situation_canceled";
  }

  String get color {
    switch (this.status) {
      case "space_reserved":
        return "#219653";
      case "income_billet_detail_situation_canceled":
        return "#FF5341";
      case "space_reserved_waiting":
      case "space_reserved_waiting_raffle":
      case "space_reserved_waiting_payment":
        return "#E37F22";
      default:
        return '#000000';
    }
  }

  bool get payment => this.flagChargingStatus == "OPEN" && billetCode != null;

  bool get canCancel {
    if (idStatus == 90) return false;
    if (new DateFormat("dd/MM/yyyy HH:mm:ss")
        .parse(startReservationDate!)
        .isBefore(DateTime.now())) return false;
    if (canCancelUntil != null &&
        new DateFormat("dd/MM/yyyy HH:mm:ss")
            .parse(canCancelUntil!)
            .isBefore(DateTime.now())) return false;
    //TODO: Verificar se pode cancelar baseado na data de cancelamento limite
    return true;
  }

  String paymentMethodTile(BuildContext context) {
    switch (charginFormDescription) {
      case ReservationCharging.quota:
        return getString(context, "space_reservation_payment_quota");
      case ReservationCharging.billet:
        return getString(context, "space_reservation_payment_billet");
      case ReservationCharging.guarantor:
        return getString(context, "space_reservation_payment_guarantor");
      default:
        return "";
    }
  }

  @override
  String toString() {
    return 'ReservationScheduled(id: $id, cancelingDate: $cancelingDate, inclusionDate: $inclusionDate, sendedEmailPaidBilletDate: $sendedEmailPaidBilletDate, area: $area, flagUtitlityTerm: $flagUtitlityTerm, reservationValue: $reservationValue, startReservationDate: $startReservationDate, endReservationDate: $endReservationDate, observations: $observations, unitId: $unitId, unitName: $unitName, reservationTypeDate: $reservationTypeDate, receipt: $receipt, emailSendDate: $emailSendDate, updateDate: $updateDate, userAlteration: $userAlteration, reference: $reference, reservationType: $reservationType, idStatus: $idStatus, flagChargingForm: $flagChargingForm, reservationTypeDescription: $reservationTypeDescription, charginFormDescription: $charginFormDescription, idStatusDecription: $idStatusDecription, canCancelUntil: $canCancelUntil)';
  }
}
