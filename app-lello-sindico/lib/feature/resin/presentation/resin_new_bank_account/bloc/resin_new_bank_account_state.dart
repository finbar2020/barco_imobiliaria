import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

abstract class ResinNewBankAccountState {}

class ResinNewBankAccountLoadingState extends ResinNewBankAccountState {}

class ResinNewBankAccountErrorState extends ResinNewBankAccountState {
  String errorMessageKey;
  ResinNewBankAccountErrorState({required this.errorMessageKey});
}

class ResinNewBankAccountLoadedState extends ResinNewBankAccountState {
  List<ResinBank> resinBanks;
  List<ResinPerson> resinPeople;
  bool isUpdating;
  ResinBankAccount? resinAccount;
  String? dialogMessageKey;
  bool? isSuccess;

  ResinNewBankAccountLoadedState({
    required this.resinBanks,
    required this.resinPeople,
    this.isUpdating = false,
    this.resinAccount,
    this.dialogMessageKey,
    this.isSuccess,
  });
}
