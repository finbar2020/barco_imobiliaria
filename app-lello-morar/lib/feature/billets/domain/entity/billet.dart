import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/billets/domain/entity/billet_found.dart';
import 'package:morar/feature/billets/domain/entity/billet_instructions.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';

class Billet {
  String? id;
  double? value;
  DateTime? period;
  BilletStatusEnum situation;
  String? nrBillet;
  String? code;
  String? notificationParameter;
  String? name;
  bool? isDuplicate;
  List<BilletFound> founds;
  BilletInstructions? instructions;

  Billet({
    this.id,
    this.value,
    this.period,
    this.situation = BilletStatusEnum.outros,
    this.code,
    this.nrBillet,
    this.founds = const [],
    this.instructions,
    this.name,
    this.isDuplicate,
  });

  bool? get vencido => period == null
      ? null
      : this.situation == BilletStatusEnum.pendente &&
          DateTime.now().difference(this.period!).inDays > 0;

  String get vencimentoMesDia =>
      period == null ? " - " : DateFormat("dd/MM").format(this.period!);
  String get vencimentoFullDate =>
      period == null ? " - " : DateFormat.yMd().format(this.period!);
  String get mes => period == null
      ? " - "
      : toBeginningOfSentenceCase(DateFormat('MMMM').format(this.period!)) ??
          "";

  String get statusText {
    switch (this.situation) {
      case BilletStatusEnum.pendente:
        return "income_billet_detail_situation_open";
      case BilletStatusEnum.cancelado:
        return "income_billet_detail_situation_canceled";
      case BilletStatusEnum.baixado:
        return "income_billet_detail_situation_paid_out";
      case BilletStatusEnum.acordo:
        return "income_billet_detail_situation_agreement";
      default:
        return "income_billet_detail_situation_other";
    }
  }

  Color color(ThemeData theme) {
    switch (situation) {
      case BilletStatusEnum.pendente:
        return LelloTheme.palleteOf(theme).warning();
      case BilletStatusEnum.cancelado:
        return theme.primaryColor;
      case BilletStatusEnum.baixado:
        return LelloTheme.palleteOf(theme).success();
      default:
        return LelloTheme.palleteOf(theme).text();
    }
  }

  String get dueDate {
    if (situation == BilletStatusEnum.pendente && vencido == true) {
      return "Vencido em $vencimentoMesDia";
    } else if (situation == BilletStatusEnum.pendente && vencido == false) {
      return "Vence em $vencimentoMesDia";
    } else {
      return "";
    }
  }

  Color get colorDueDate {
    if (situation == BilletStatusEnum.pendente && vencido == true) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
