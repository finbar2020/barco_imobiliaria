import 'dart:convert';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_bloc.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class InsuranceController {
  final InsuranceBloc bloc;
  final GetInsurance insuranceUseCase;
  final PostInsurance postUseCase;
  final SessionBloc sessionBloc;

  InsuranceController({
    required this.bloc,
    required this.insuranceUseCase,
    required this.postUseCase,
    required this.sessionBloc,
  });

  double minCost = 0.0;

  double maxCost = 0.0;

  InsurancePremiumModel? selectedPremium;
  InsuranceTableModel? insuranceData;

  String linkTermos =
      "https://protecaoresidencial.vilavelha.com.br/site/conteudo/default/produtos/residencial/condicoes-gerais_residencial_plano-basico.pdf";

  String linkTermosCompleto =
      "https://protecaoresidencial.vilavelha.com.br/site/conteudo/default/produtos/residencial/condicoes-gerais_residencial_plano-completo.pdf";

  Future<void> getInsurance() async {
    bloc.add(InsuranceLoadingEvent());

    if (sessionBloc.getRemoteConfig != null) {
      var remoteTermosLink = await sessionBloc.getRemoteConfig
          ?.getString(CustomFirebaseRemoteConfig.insuranceTermsUrl);
      if (remoteTermosLink?.isNotEmpty == true) {
        linkTermos = jsonDecode(remoteTermosLink!)["link"];
      }
      var remoteTermosCompletoLink = await sessionBloc.getRemoteConfig
          ?.getString(CustomFirebaseRemoteConfig.insuranceTermsUrlCompleto);
      if (remoteTermosCompletoLink?.isNotEmpty == true) {
        linkTermosCompleto = jsonDecode(remoteTermosCompletoLink!)["link"];
      }
    }

    final response = await insuranceUseCase.call(
        GetInsuranceParam(unitId: sessionBloc.state.session?.unity?.id ?? ""));

    response.fold((error) => bloc.add(InsuranceFailedEvent()), (response) {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.comodidadesParceiroSegurosAcessar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      insuranceData = sessionBloc.getInsuranceTable();

      if (insuranceData != null && insuranceData!.premio.isNotEmpty == true) {
        for (var premio in insuranceData!.premio) {
          if (minCost == 0.0 || premio.custo < minCost) {
            minCost = premio.custo;
          }
          if (maxCost == 0.0 || premio.custo > maxCost) {
            maxCost = premio.custo;
          }
        }
        selectedPremium = insuranceData!.premio.firstWhereOrNull(
            (element) => element.custo == response.insuranceData?.cost);

        if (selectedPremium != null) {
          bloc.add(InsuranceLoadedEvent(
            model: response,
            selectedPremium: selectedPremium!,
            insuranceData: insuranceData!,
          ));
          return;
        }
      }
      bloc.add(InsuranceFailedEvent());
    });
  }

  Future<void> postInsurance(bool isCancel) async {
    if (insuranceData == null || selectedPremium == null) {
      bloc.add(InsuranceFailedEvent());
      return;
    }

    bloc.add(InsuranceLoadingEvent());

    final response = await postUseCase.call(
        PostInsuranceParam(unitId: sessionBloc.state.session!.unity!.id!));

    response.fold(
      (error) => bloc.add(InsuranceFailedEvent()),
      (response) {
        bloc.add(InsuranceLoadedEvent(
            isCancel: isCancel,
            isPost: true,
            insuranceData: insuranceData!,
            selectedPremium: selectedPremium!));
        if (!isCancel) {
          OwnerAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsOwner.comodidadesParceiroSegurosContratar(),
            userId: sessionBloc.state.session?.me?.id ?? "",
            unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
            referenceValue:
                sessionBloc.state.session!.condominium?.reference?.toString() ??
                    "",
          );
        } else {
          OwnerAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsOwner.comodidadesParceiroSegurosCancelar(),
            userId: sessionBloc.state.session?.me?.id ?? "",
            unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
            referenceValue:
                sessionBloc.state.session!.condominium?.reference?.toString() ??
                    "",
          );
        }
      },
    );
  }
}
