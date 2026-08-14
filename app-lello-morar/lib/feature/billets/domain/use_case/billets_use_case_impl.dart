import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:morar/feature/billets/domain/repository/billets_repository.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case.dart';

class BilletsUseCaseImpl extends BilletsUseCase {
  final BilletsRepository repository;

  BilletsUseCaseImpl({required this.repository});
  @override
  Future<Try<Paginator>> call(BilletsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getBillets(params.reference, params.unitId,
        showAll: params.showAll);
  }

  Failure? _validate(BilletsParams params) {
    if (params.reference.isEmpty) return InvalidParamFailure();
    if (params.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
