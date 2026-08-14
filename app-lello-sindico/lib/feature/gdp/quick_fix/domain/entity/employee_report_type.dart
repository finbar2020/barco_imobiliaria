enum EmployeeReportType { vacation, termination }

extension EmployeeReportTypeExt on EmployeeReportType {
  String get value {
    return this.toString().split('.').last;
  }

  String getValue() {
    return this.toString().split('.').last;
  }
}

class EmployeeReportTypeHelper {
  static EmployeeReportType? parse(String value) {
    switch (value) {
      case 'vacation':
        return EmployeeReportType.vacation;
      case 'termination':
        return EmployeeReportType.termination;
      default:
        return null;
    }
  }

  static String parseString(EmployeeReportType value) {
    switch (value) {
      case EmployeeReportType.vacation:
        return 'Férias';
      case EmployeeReportType.termination:
        return 'Rescisão';
      default:
        return '';
    }
  }
}
