import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account.dart';

class DeleteResinBankAccountImpl extends DeleteResinBankAccount {
  final ResinBankRepository repository;

  DeleteResinBankAccountImpl({required this.repository});

  @override
  Future<Try<bool>> call(DeleteResinBankAccountParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.deleteResinBankAccount(
        params.condominiumId, params.accountId);
  }

  Failure? _validate(DeleteResinBankAccountParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.accountId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
