import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_period.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_bloc.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccountabilityController {
  final AccountabilityBloc bloc;
  final GetAccountability getAccountability;
  final GetAccountabilityPeriod getAccountabilityPeriod;
  final SessionBloc sessionBloc;

  AccountabilityController({
    required this.bloc,
    required this.getAccountability,
    required this.getAccountabilityPeriod,
    required this.sessionBloc,
  });

  Future<void> getPeriods() async {
    bloc.add(AccountabilityLoadingEvent());

    if (sessionBloc.state.session?.condominium?.id == null) {
      bloc.add(AccountabilityFailureEvent(error: null));
      return;
    }

    final response = await getAccountabilityPeriod
        .call(sessionBloc.state.session!.condominium!.id!);

    response.fold((error) => bloc.add(AccountabilityFailureEvent(error: error)),
        (res) {
      if (res.isEmpty) {
        bloc.add(AccountabilityEmptyEvent());
        return;
      }
      List<String> months = List.generate(res.length, (index) {
        return res[index].periodo;
      });
      bloc.add(AccountabilityLoadedEvent(periodos: months));
    });
  }

  Future<void> getAccountabilityController(DateTime period) async {
    bloc.add(AccountabilityLoadingEvent());

    if (sessionBloc.state.session?.condominium?.id == null) {
      bloc.add(AccountabilityFailureEvent(error: null));
      return;
    }

    try {
      final response = await getAccountability.call(
        GetAccountabilityParam(
          period: period,
          condominiumId: sessionBloc.state.session!.condominium!.id!,
        ),
      );
      response.fold(
          (error) => bloc.add(AccountabilityFailureEvent(error: error)), (res) {
        bloc.add(AccountabilityPeriodsLoadedEvent(accountability: res));
        OwnerAnalyticsLogEvents.logEvent(
          userId: sessionBloc.state.session?.me?.id ?? "",
          event: AnalyticsEventsOwner.ppcAcessarMesConsultar(),
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
      });
    } catch (e) {
      bloc.add(AccountabilityFailureEvent(error: null));
    }
  }
}
