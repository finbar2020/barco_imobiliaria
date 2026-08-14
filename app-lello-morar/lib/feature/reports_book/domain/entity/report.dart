import 'package:intl/intl.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';

class Report {
  String? idReport;
  String? numReport;
  String? typeReport;
  DateTime? dateReport;
  List<ReportContents>? reportContents;
  bool? closed;
  bool? newMessage;
  String? notificationParameter;
  bool public;

  Report({
    this.idReport,
    this.typeReport,
    this.dateReport,
    this.reportContents,
    this.closed = false,
    this.newMessage = false,
    this.numReport,
    this.notificationParameter,
    this.public = true,
  });

  @override
  String toString() =>
      'Report(idReport: $idReport, typeReport: $typeReport, dateReport: $dateReport, reportContents: $reportContents, closed: $closed)';

  String get getDate {
    final date = new DateFormat('dd/MM/yyyy');
    final hour = new DateFormat('HH');
    final minutes = new DateFormat('mm');

    return '${date.format(dateReport!)} ${hour.format(dateReport!)}h:${minutes.format(dateReport!)}m';
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

  String get getSituation {
    switch (this.closed) {
      case false:
        return "reports_situation_open";
      case true:
        return "reports_situation_closed";
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
}
