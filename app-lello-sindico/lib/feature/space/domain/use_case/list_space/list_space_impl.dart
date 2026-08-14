import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';

class ListSpaceImpl extends ListSpace {
  final SpaceRepository repository;

  ListSpaceImpl({required this.repository});
  @override
  Future<Try<List<Space>>> call(ListSpaceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId, params.origin);
  }

  Failure? _validate(ListSpaceParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
