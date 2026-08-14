import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

class TimesheetSignature {
  int? id;
  Employee? employee;
  DateTime? signatureDateTime;
  DateTime? periodDate;
  bool? approvedFlag;
  String? typeSignature;

  TimesheetSignature(
      {this.id,
      this.employee,
      this.signatureDateTime,
      this.periodDate,
      this.approvedFlag,
      this.typeSignature});
}
