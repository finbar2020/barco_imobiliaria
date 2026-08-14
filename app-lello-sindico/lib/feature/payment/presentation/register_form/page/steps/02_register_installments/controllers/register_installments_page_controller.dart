import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/bloc/register_installments_page_bloc.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class RegisterInstallmentsController {
  final GetResinBanks getResinBanksUseCase;

  PageController pageController = PageController(initialPage: 0);

  List<ResinBank> banksList = [];

  final RegisterInstallmentsBloc bloc;
  final SessionBloc sessionBloc;

  RegisterInstallmentsController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinBanksUseCase,
  });

  void getBanks() async {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    // buscaCache
    final banksCache = await getResinBanksUseCase.call(
      GetResinBanksParams(
        condominiumId: condominiumId,
        origin: DataOrigin.local,
      ),
    );

    var resultLocal = banksCache.fold(
      (banksError) => false,
      (banksCacheData) {
        banksList = banksCacheData;
        return banksCacheData.isNotEmpty;
      },
    );
    if (resultLocal == false) {
      // buscaRemote
      final banksRemote = await getResinBanksUseCase.call(
        GetResinBanksParams(
          condominiumId: condominiumId,
          origin: DataOrigin.remote,
        ),
      );
      banksRemote.fold(
        (banksError) => banksList = [],
        (banksRemoteData) {
          banksList = banksRemoteData;
        },
      );
    }
  }
}
