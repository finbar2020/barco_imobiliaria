import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';
import 'package:morar/feature/change_ownership/domain/repository/change_ownership_repository.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change.dart';

class CanChangeUseCaseImpl extends CanChangeUseCase {
  final ChangeOwnershipRepository repository;

  CanChangeUseCaseImpl({required this.repository});
  @override
  Future<Try<CanChangeEntity>> call(CanChangeParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getCanChange(params.condoId);
  }

  Failure? _validate(CanChangeParams params) {
    if (params.condoId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
