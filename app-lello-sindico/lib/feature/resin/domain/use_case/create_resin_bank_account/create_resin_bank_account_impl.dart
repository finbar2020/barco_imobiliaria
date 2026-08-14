import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account.dart';

class CreateResinBankAccountImpl extends CreateResinBankAccount {
  final ResinBankRepository repository;

  CreateResinBankAccountImpl({required this.repository});

  @override
  Future<Try<ResinBankAccount>> call(
      CreateResinBankAccountParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.createResinBankAccount(
        params.condominiumId, params.newAccount);
  }

  Failure? _validate(CreateResinBankAccountParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.newAccount.bank == null) return InvalidParamFailure();
    if (param.newAccount.agency.isEmpty) return InvalidParamFailure();
    if (param.newAccount.accountNumber.isEmpty) return InvalidParamFailure();
    if (param.newAccount.document.isEmpty) return InvalidParamFailure();
    if (param.newAccount.supplierName.isEmpty) return InvalidParamFailure();

    return null;
  }
}
