import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/domain/repository/space_type_repository.dart';

import 'list_space_type.dart';

class ListSpaceTypeImpl extends ListSpaceType {
  final SpaceTypeRepository repository;

  ListSpaceTypeImpl({required this.repository});

  @override
  Future<Try<List<SpaceType>>> call(ListSpaceTypeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId);
  }

  Failure? _validate(ListSpaceTypeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
