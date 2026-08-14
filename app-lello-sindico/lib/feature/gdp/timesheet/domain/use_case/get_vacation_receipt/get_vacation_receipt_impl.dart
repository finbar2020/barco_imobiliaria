import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt.dart';

class GetVacationReceiptImpl extends GetVacationReceipt {
  final TimesheetRepository repository;

  GetVacationReceiptImpl({required this.repository});

  @override
  Future<Try<File>> call(GetVacationReceiptParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getVacationReceipt(params.archiveName);
  }

  Failure? _validate(GetVacationReceiptParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.archiveName.isEmpty) return InvalidParamFailure();
    return null;
  }
}
