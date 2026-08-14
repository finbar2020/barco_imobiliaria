import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/billets/data/model/billet_model.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_bloc.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class BilletsController {
  final BilletsBloc bloc;
  final BilletsUseCase billetsUseCase;
  final BilletsPdfUseCase billetsPdf;
  final SessionBloc sessionBloc;

  BilletsController({
    required this.bloc,
    required this.billetsUseCase,
    required this.billetsPdf,
    required this.sessionBloc,
  });

  Future<void> getBillets() async {
    bloc.add(BilletsLoadingEvent());

    final response = await billetsUseCase.call(BilletsParams(
      reference: sessionBloc.state.session?.condominium?.reference ?? "",
      unitId: sessionBloc.state.session?.unity?.title ?? "",
    ));

    response
        .fold((error) => bloc.add(BilletsFailureEvent(error: "billets_error")),
            (res) {
      try {
        List<Billet> billets = [];
        if (res.data.length != null || res.data.isNotEmpty) {
          List.generate(res.data.length, (i) {
            Map<String, dynamic> map = res.data[i];
            BilletModel model = BilletModel.fromJson(map);
            billets.add(model.toEntity());
          });
        }
        if (billets.length == 0) {
          bloc.add(BilletsEmptyEvent());
        } else {
          OwnerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsOwner.boletosAcessar(),
              userId: sessionBloc.state.session?.me?.id ?? "",
              unitValue:
                  sessionBloc.state.session!.unity?.title.toString() ?? "",
              referenceValue:
                  sessionBloc.state.session!.condominium!.reference.toString());
          bloc.add(BilletsLoadedEvent(
            billets: billets,
            allBillets: res.meta?.totalItems ?? 0,
          ));
        }
      } catch (e) {
        bloc.add(BilletsFailureEvent(error: "billets_error"));
      }
    });
  }

  Future<void> showBillet(Billet billet) async {
    if (billet.situation != BilletStatusEnum.pendente &&
        billet.situation != BilletStatusEnum.baixado) {
      bloc.add(BilletsShowInfoEvent(billet: billet));
      return;
    }

    bloc.add(BilletsLoadingEvent(billet: billet));

    final response =
        await billetsPdf.call(BilletsPdfParams(nrBillet: billet.nrBillet!));
    response.fold(
        (error) => bloc
            .add(BilletsFailureEvent(error: "billets_error", billet: billet)),
        (data) {
      bloc.add(BilletsShowInfoEvent(
          billet: billet, pdf: data.data, fileName: data.name));
    });

    if (billet.situation == BilletStatusEnum.pendente) {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.boletosAcessarVencido(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium!.reference.toString(),
      );
    }
  }
}
