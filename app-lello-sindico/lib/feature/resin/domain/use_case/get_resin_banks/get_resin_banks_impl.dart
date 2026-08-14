import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks.dart';

class GetResinBanksImpl extends GetResinBanks {
  final ResinBankRepository repository;

  GetResinBanksImpl({required this.repository});

  @override
  Future<Try<List<ResinBank>>> call(GetResinBanksParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return params.origin == DataOrigin.local
        ? await repository.getResinBanksFromCache(params.condominiumId)
        : await repository.getResinBanks(params.condominiumId);
  }

  Failure? _validate(GetResinBanksParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
