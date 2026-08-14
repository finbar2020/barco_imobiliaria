import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence.dart';

class PostControlOccurrenceImpl extends PostControlOccurrence {
  final TimesheetRepository repository;

  PostControlOccurrenceImpl({required this.repository});

  @override
  Future<Try<String>> call(PostControlOccurrenceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.postControlOccurrence(params.actions);
  }

  Failure? _validate(PostControlOccurrenceParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.actions.isEmpty) return InvalidParamFailure();
    return null;
  }
}
