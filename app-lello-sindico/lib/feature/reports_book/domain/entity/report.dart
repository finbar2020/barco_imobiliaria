import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/unit.dart';

class Report {
  String? idReport;
  String? numReport;
  String? typeReport;
  DateTime? dateReport;
  List<ReportContents>? reportContents;
  bool closed;
  bool isPublic;
  bool newMessage;
  Unit? unit;
  String? residentsName;
  String? notificationParameter;

  Report({
    this.idReport,
    this.typeReport,
    this.dateReport,
    this.reportContents,
    this.isPublic = false,
    this.closed = false,
    this.newMessage = false,
    this.numReport,
    this.unit,
    this.residentsName,
    this.notificationParameter,
  });

  @override
  String toString() =>
      'Report(idReport: $idReport, typeReport: $typeReport, dateReport: $dateReport, reportContents: $reportContents, closed: $closed)';

  String getDate() {
    final f = DateFormat('dd/MM/yyyy - HH:mm');

    return '${f.format(dateReport!)}h';
  }

  List<String> get getTypesReport =>
      ["COMPLAINT", "SUGGESTION", "COMPLIMENT", "VIOLENCE_NO", "OTHERS"];

  String get getTypeReport {
    switch (this.typeReport) {
      case "SUGGESTION":
        return "reports_type_suggestion";
      case "COMPLAINT":
        return "reports_type_complaint";
      case "VIOLENCE_NO":
        return "reports_type_violence_no";
      case "COMPLIMENT":
        return "reports_type_compliment";
      case "OTHERS":
        return "reports_type_others";
      default:
        return '';
    }
  }

  void setTypeReport(String type) {
    switch (type) {
      case "Sugestões":
        this.typeReport = "SUGGESTION";
        break;
      case "Suggestion":
        this.typeReport = "SUGGESTION";
        break;
      case "Reclamações":
        this.typeReport = "COMPLAINT";
        break;
      case "Complaint":
        this.typeReport = "COMPLAINT";
        break;
      case "Elogios":
        this.typeReport = "COMPLIMENT";
        break;
      case "Compliment":
        this.typeReport = "COMPLIMENT";
        break;
      case "Violência não":
        this.typeReport = "VIOLENCE_NO";
        break;
      case "Violence no":
        this.typeReport = "VIOLENCE_NO";
        break;
      case "Outros":
        this.typeReport = "OTHERS";
        break;
      case "Others":
        this.typeReport = "OTHERS";
        break;
      default:
        return;
    }
  }

  Widget getNewMessageWidget(BuildContext context, ThemeData theme) {
    return newMessage
        ? Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: reportContents?.length == 1
                        ? theme.primaryColor
                        : LelloTheme.palleteOf(theme).warning(),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    reportContents?.length == 1
                        ? getString(context, 'reports_new_report')
                        : getString(context, 'reports_condominium_replica'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
