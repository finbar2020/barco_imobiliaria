import 'package:intl/intl.dart';

class ReportFilter {
  DateTime? dateFrom;
  DateTime? dateTo;
  int? type;
  bool? closed;
  String? unitId;
  String? unitName;
  bool showOnlyNewReports;
  bool showOnlyReplies;
  int page;

  ReportFilter({
    this.dateFrom,
    this.dateTo,
    this.type,
    this.closed = false,
    this.unitId,
    this.showOnlyNewReports = false,
    this.showOnlyReplies = false,
    this.page = 1,
  });

  @override
  String toString() {
    return 'ReportFilter(dateFrom: $dateFrom, dateTo: $dateTo, type: $type, closed: $closed, unitId: $unitId, unitName: $unitName, showNewMessages: $showOnlyNewReports, showReplies: $showOnlyReplies)';
  }

  void setTypeReport(String typeReport) {
    switch (typeReport) {
      case "Reclamações":
        type = 0;
        break;
      case "Complaint":
        type = 0;
        break;
      case "Sugestões":
        type = 1;
        break;
      case "Suggestion":
        type = 1;
        break;
      case "Elogios":
        type = 2;
        break;
      case "Compliment":
        type = 2;
        break;
      case "Outros":
        type = 3;
        break;
      case "Others":
        type = 3;
        break;
      default:
        return;
    }
  }

  void setStatusReport(String statusReport) {
    switch (statusReport) {
      case "Abertas":
        closed = false;
        break;
      case "Open":
        closed = false;
        break;
      case "Encerradas":
        closed = true;
        break;
      case "Closed":
        closed = true;
        break;
      case "Todas":
        closed = null;
        break;
      case "All":
        closed = null;
        break;
      default:
        return;
    }
  }

  String getStatusReport() {
    switch (closed) {
      case false:
        return "reports_filter_selected_status_open";
      case true:
        return "reports_filter_selected_status_closed";
      default:
        return "reports_filter_selected_status_all";
    }
  }

  String getTypeReport() {
    switch (type) {
      case 0:
        return "reports_filter_selected_subject_complaint";
      case 1:
        return "reports_filter_selected_subject_suggestion";
      case 2:
        return "reports_filter_selected_subject_compliment";
      case 3:
        return "reports_filter_selected_subject_others";
      default:
        return "";
    }
  }

  String? getUnidId() {
    return unitName;
  }

  String getPeriodReport() {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    String? dateFrom =
        this.dateFrom == null ? "" : dateFormat.format(this.dateFrom!);

    String? dateTo = this.dateTo == null ? "" : dateFormat.format(this.dateTo!);

    return "$dateFrom - $dateTo";
  }
}
