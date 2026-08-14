import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_failure.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency.dart';

class UpdatePendencyImpl extends UpdatePendency {
  final PendencyRepository repository;

  UpdatePendencyImpl({required this.repository});

  @override
  Future<Try<List<Pendency>>> call(UpdatePendencyParam params) async {
    var error = validate(params);
    if (error != null) return Rejection(error);
    var result = await repository.updateNotification(
        params.condominiumId, params.pendencyId);
    return result;
  }

  Failure? validate(UpdatePendencyParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty)
      return InvalidListPendencyCondominiumFailure();
    return null;
  }
}
