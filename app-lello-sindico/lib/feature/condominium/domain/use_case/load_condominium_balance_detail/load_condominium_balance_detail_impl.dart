import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_detail_repository.dart';

import 'load_condominium_balance_detail.dart';

class LoadCondominiumBalanceDetailImpl extends LoadCondominiumBalanceDetail {
  final CondominiumBalanceDetailRepository repository;

  LoadCondominiumBalanceDetailImpl({required this.repository});

  @override
  Future<Try<CondominiumBalanceDetail?>> call(
      LoadCondominiumBalanceDetailParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    final future = params.origin == DataOrigin.local
        ? repository.selectFromCache(params)
        : repository.select(params);

    return await future;
  }

  Failure? _validate(LoadCondominiumBalanceDetailParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isNotEmpty != true) return InvalidParamFailure();
    if (params.reference.isNotEmpty != true) return InvalidParamFailure();
    return null;
  }
}
