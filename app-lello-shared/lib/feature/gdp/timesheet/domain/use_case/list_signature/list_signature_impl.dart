import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature.dart';

class ListSignatureImpl extends ListSignature {
  final TimesheetGDPRepository repository;

  ListSignatureImpl({required this.repository});

  @override
  Future<Try<List<TimesheetSignature>>> call(ListSignatureParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listSignature(params.condominiumId, params.filter);
  }

  Failure? _validate(ListSignatureParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
