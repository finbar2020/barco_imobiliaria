import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';

class AccessControlVisitantController {
  final AccessControlStore store;
  AccessControlVisitantController({required this.store});

  saveVisitantAccess(
      {required AccessControl model,
      required AccessControlAuthorizations authorizations,
      required bool useFacialBiometric}) async {
    bool success = await store.saveAccess(
        model: model,
        authorizations: authorizations,
        useFacialBiometric: useFacialBiometric);

    if (success) {
      OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner
              .autorizacaoEntradasCadastrarNovoVisitanteSucesso(),
          userId: store.sessionBloc.state.session?.me?.id ?? "",
          unitValue:
              store.sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue: store
                  .sessionBloc.state.session!.condominium?.reference
                  ?.toString() ??
              "",
          otherParameters: {
            "tipo": model.type ?? "",
          });
    }
  }

  saveVisitantVisit(
      {required AccessControl visitant,
      required AccessControlAuthorizations authorizations,
      required String? cpf}) async {
    bool success = await store.saveVisit(
        model: visitant, authorizations: authorizations, cpf: cpf);

    if (success) {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.autorizacaoEntradasAgendamentosSucesso(),
        userId: store.sessionBloc.state.session?.me?.id ?? "",
        unitValue:
            store.sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue: store.sessionBloc.state.session!.condominium?.reference
                ?.toString() ??
            "",
        otherParameters: {
          "tipo agendamento": authorizations.recorrente,
          "tipo": visitant.type ?? ""
        },
      );
    }
  }

  editVisitantScheduledVisit(
      {required AccessControl visitant,
      required AccessControlAuthorizations authorizations,
      required String? cpf}) async {
    return await store.editScheduledVisit(
        model: visitant, authorizations: authorizations, cpf: cpf);
  }
}
