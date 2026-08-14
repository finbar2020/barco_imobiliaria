import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror.dart';

class GetPointMirrorImpl extends GetPointMirror {
  final TimesheetRepository repository;

  GetPointMirrorImpl({required this.repository});

  @override
  Future<Try<List<TimesheetEntity>>> call(GetPointMirrorParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPointMirrorList(params.date);
  }

  Failure? _validate(GetPointMirrorParam? param) {
    if (param == null) return InvalidParamFailure();
    return null;
  }
}
