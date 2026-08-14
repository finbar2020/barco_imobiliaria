import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_failure.dart';

class ListPendencyImpl extends ListPendency {
  final PendencyRepository repository;

  ListPendencyImpl({required this.repository});

  @override
  Future<Try<List<Pendency>>> call(ListPendencyParam params) async {
    if (params.dataOrigin == DataOrigin.local) {
      var result = await repository.selectCache(params.reference);
      return result;
    }
    var result = await repository.selectPagination(params.reference,
        currentSize: params.currentSize);
    return result;
  }

  Failure? validate(ListPendencyParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.reference.isEmpty) return InvalidListPendencyCondominiumFailure();
    return null;
  }
}
