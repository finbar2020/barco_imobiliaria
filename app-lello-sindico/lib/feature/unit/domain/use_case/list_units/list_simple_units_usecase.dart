import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/unit/domain/repository/unit_repository.dart';

import 'package:essentials/essentials.dart';

class ListUnitSimpleUsecase
    extends UseCase<List<UnitSimple>, ListUnitSimpleParam> {
  final UnitRepository repository;

  ListUnitSimpleUsecase({required this.repository});

  @override
  Future<Try<List<UnitSimple>>> call(ListUnitSimpleParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.listSimple(
      params.condominiumId,
    );
    return result;
  }

  Failure? validate(ListUnitSimpleParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class ListUnitSimpleParam {
  final String condominiumId;

  ListUnitSimpleParam({
    required this.condominiumId,
  });
}
