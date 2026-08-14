import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

abstract class ResinNewBankAccountEvent extends Equatable {
  const ResinNewBankAccountEvent();

  @override
  List<Object?> get props => [];
}

class ResinNewBankAccountLoadingEvent extends ResinNewBankAccountEvent {
  const ResinNewBankAccountLoadingEvent();
}

class ResinNewBankAccountLoadedEvent extends ResinNewBankAccountEvent {
  final List<ResinBank> resinBanks;
  final List<ResinPerson> resinPeople;
  final bool isUpdating;
  final ResinBankAccount? resinAccount;
  final String? dialogMessageKey;
  final bool? isSuccess;

  const ResinNewBankAccountLoadedEvent({
    required this.resinBanks,
    required this.resinPeople,
    this.isUpdating = false,
    this.resinAccount,
    this.dialogMessageKey,
    this.isSuccess,
  });

  @override
  List<Object?> get props => [
        resinBanks,
        resinPeople,
        isUpdating,
        resinAccount,
        dialogMessageKey,
        isSuccess,
      ];
}

class ResinNewBankAccountErrorEvent extends ResinNewBankAccountEvent {
  final String errorMessageKey;

  const ResinNewBankAccountErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
