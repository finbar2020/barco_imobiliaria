import 'package:essentials/enum/data_origin.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinNewBankAccountController {
  final ResinNewBankAccountBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinBanks getResinBanksUseCase;
  final GetResinPeople getResinPeopleUseCase;
  final CreateResinBankAccount createResinBankAccountUseCase;

  List<ResinPerson> resinPeople = [];
  List<ResinBank> resinBanks = [];

  ResinNewBankAccountController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinBanksUseCase,
    required this.getResinPeopleUseCase,
    required this.createResinBankAccountUseCase,
  });

  resinNewBankAccountSetUp() async {
    bloc.add(ResinNewBankAccountLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    // buscaCache
    final banksCache = await getResinBanksUseCase.call(
      GetResinBanksParams(
        condominiumId: condominiumId,
        origin: DataOrigin.local,
      ),
    );

    final peopleCache = await getResinPeopleUseCase.call(
      GetResinPeopleParams(
        condominiumId: condominiumId,
        origin: DataOrigin.local,
      ),
    );

    banksCache.fold(
      (banksError) => bloc.add(ResinNewBankAccountLoadingEvent()),
      (banksCacheData) {
        return peopleCache
            .fold((peopleError) => bloc.add(ResinNewBankAccountLoadingEvent()),
                (peopleCacheData) {
          resinPeople = peopleCacheData;
          resinBanks = banksCacheData;
          bloc.add(ResinNewBankAccountLoadedEvent(
              resinBanks: resinBanks,
              resinPeople: resinPeople,
              isUpdating: true));
        });
      },
    );

    // buscaRemote
    final banksRemote = await getResinBanksUseCase.call(
      GetResinBanksParams(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
      ),
    );

    final peopleRemote = await getResinPeopleUseCase.call(
      GetResinPeopleParams(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
      ),
    );

    banksRemote.fold(
      (banksError) => bloc.add(ResinNewBankAccountErrorEvent(
          errorMessageKey: 'resin_bank_accounts_get_error')),
      (banksRemoteData) {
        return peopleRemote.fold(
            (peopleError) => bloc.add(ResinNewBankAccountErrorEvent(
                errorMessageKey: 'resin_bank_accounts_get_error')),
            (peopleRemoteData) {
          resinPeople = peopleRemoteData;
          resinBanks = banksRemoteData;
          bloc.add(ResinNewBankAccountLoadedEvent(
              resinBanks: resinBanks, resinPeople: resinPeople));
        });
      },
    );
  }

  resinNewBankAccountCreate(ResinBankAccount newAccount) async {
    bloc.add(ResinNewBankAccountLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await createResinBankAccountUseCase.call(
      CreateResinBankAccountParams(
        condominiumId: condominiumId,
        newAccount: newAccount,
      ),
    );

    response.fold(
      (err) => bloc.add(ResinNewBankAccountLoadedEvent(
        dialogMessageKey: "resin_new_account_create_error",
        resinBanks: resinBanks,
        resinPeople: resinPeople,
        resinAccount: newAccount,
      )),
      (data) {
        bloc.add(ResinNewBankAccountLoadedEvent(
          dialogMessageKey: "resin_new_account_create_success",
          resinBanks: resinBanks,
          resinPeople: resinPeople,
          resinAccount: newAccount,
          isSuccess: true,
        ));
      },
    );
  }
}
