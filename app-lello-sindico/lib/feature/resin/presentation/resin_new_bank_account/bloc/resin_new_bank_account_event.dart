import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

abstract class ResinNewBankAccountEvent {
  ResinNewBankAccountEvent();
}

class ResinNewBankAccountLoadingEvent extends ResinNewBankAccountEvent {}

class ResinNewBankAccountLoadedEvent extends ResinNewBankAccountEvent {
  List<ResinBank> resinBanks;
  List<ResinPerson> resinPeople;
  bool isUpdating;
  ResinBankAccount? resinAccount;
  String? dialogMessageKey;
  bool? isSuccess;

  ResinNewBankAccountLoadedEvent({
    required this.resinBanks,
    required this.resinPeople,
    this.isUpdating = false,
    this.resinAccount,
    this.dialogMessageKey,
    this.isSuccess,
  });
}

class ResinNewBankAccountErrorEvent extends ResinNewBankAccountEvent {
  String errorMessageKey;
  ResinNewBankAccountErrorEvent({required this.errorMessageKey});
}
