import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_bloc.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_event.dart';

class TDBController {
  final TDBBloc bloc;
  final SessionBloc sessionBloc;
  final GetTDBInfoUseCase getTDBInfoUseCase;

  TDBController({
    required this.bloc,
    required this.sessionBloc,
    required this.getTDBInfoUseCase,
  });

  Future<void> getTDB() async {
    bloc.add(TDBLoadingEvent());

    final response = await getTDBInfoUseCase.call(GetTDBInfoParam(
        condominiumId: sessionBloc.state.session?.condominium?.id ?? ""));

    response.fold(
      (error) => bloc.add(TDBErroEvent(errorMessageKey: "tdb_page_error")),
      (tdbInfo) {
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.tdbCadastrar(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        bloc.add(TDBLoadedEvent(tdbInfo: tdbInfo));
      },
    );
  }
}
