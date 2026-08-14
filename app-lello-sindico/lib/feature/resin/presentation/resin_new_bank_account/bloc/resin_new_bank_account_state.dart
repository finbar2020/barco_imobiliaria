import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

abstract class ResinNewBankAccountState extends Equatable {
  const ResinNewBankAccountState();

  @override
  List<Object?> get props => [];
}

class ResinNewBankAccountLoadingState extends ResinNewBankAccountState {
  const ResinNewBankAccountLoadingState();
}

class ResinNewBankAccountErrorState extends ResinNewBankAccountState {
  final String errorMessageKey;

  const ResinNewBankAccountErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinNewBankAccountLoadedState extends ResinNewBankAccountState {
  final List<ResinBank> resinBanks;
  final List<ResinPerson> resinPeople;
  final bool isUpdating;
  final ResinBankAccount? resinAccount;
  final String? dialogMessageKey;
  final bool? isSuccess;

  const ResinNewBankAccountLoadedState({
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
