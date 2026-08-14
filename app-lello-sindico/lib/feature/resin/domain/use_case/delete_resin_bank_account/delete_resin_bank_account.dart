import 'package:essentials/essentials.dart';

abstract class DeleteResinBankAccount
    extends UseCase<bool, DeleteResinBankAccountParams> {}

class DeleteResinBankAccountParams {
  final String condominiumId;
  final String accountId;

  DeleteResinBankAccountParams(
      {required this.condominiumId, required this.accountId});
}
