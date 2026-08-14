import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts.dart';

class GetResinBankAccountsImpl extends GetResinBankAccounts {
  final ResinBankRepository repository;

  GetResinBankAccountsImpl({required this.repository});

  @override
  Future<Try<List<ResinBankAccount>>> call(
      GetResinBankAccountsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return params.origin == DataOrigin.local
        ? await repository.getResinBankAccountsFromCache(params.condominiumId)
        : await repository.getResinBankAccounts(params.condominiumId);
  }

  Failure? _validate(GetResinBankAccountsParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
