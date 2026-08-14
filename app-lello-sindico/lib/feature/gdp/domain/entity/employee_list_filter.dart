class EmployeeListFilter {
  String? name;
  String? role;
  double? salaryFrom;
  double? salaryTo;
  DateTime? dobFrom;
  String? status;
  DateTime? dobTo;
  DateTime? hiringDateFrom;
  DateTime? hiringDateTo;
  String? conditionName;
  EmployeeListFilter(
      {this.name,
      this.role,
      this.salaryFrom,
      this.salaryTo,
      this.dobFrom,
      this.status,
      this.dobTo,
      this.hiringDateTo,
      this.conditionName});
}
