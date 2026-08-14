import 'package:cross_file/cross_file.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_event.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_details_bloc.dart';

import '../../../../../session/presentation/bloc/session_bloc.dart';
import '../../../../../unit/domain/entity/unit.dart';
import '../../../../domain/entity/billet.dart';
import '../../../../domain/use_case/download_billet_usecase.dart';
import '../../../../domain/use_case/get_billets.dart';

class BilletsDetailsController {
  final GetBillets getBillets;
  final SessionBloc sessionBloc;
  final DownloadBilletUsecase downloadBilletUsecase;
  final BilletsDetailBloc bloc;

  BilletsDetailsController({
    required this.getBillets,
    required this.sessionBloc,
    required this.downloadBilletUsecase,
    required this.bloc,
  });

  Unit? selectedUnit;
  DateTime? selectedDateTime;

  XFile? file;

  Billet? selectedBillet;

  bool get isDateValid {
    if (selectedBillet?.bankPeriod == null) return false;

    final now = DateTime.now();
    final compareDates =
        now.compareTo(selectedBillet!.bankPeriod!);
    if (compareDates <= 0) {
      return true;
    }
    return false;
  }

  Future<void> getBillet({
    required Unit unit,
    required DateTime period,
  }) async {
    final condominium = sessionBloc.state.session!.selectedCondominium!;
    bloc.add(BilletsDetailLoadingEvent());

    final result = await getBillets.call(
      GetBilletsParam(
        condominiumId: condominium.id,
        unitId: unit.title.toString().padLeft(6, '0'),
        period: period,
      ),
    );

    result.fold(
      (failure) => bloc.add(
        BilletsDetailFailureEvent(failure: failure),
      ),
      (billet) async {
        String reference = sessionBloc
                .state.session!.selectedCondominium?.reference
                .toString() ??
            "";

        ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condBoletosAcessar(),
          referenceValue: reference,
        );
        selectedBillet = billet;
        bloc.add(
          BilletsDetailSuccessEvent(billet: billet),
        );
        if (billet != null) {
          final resultPdf = await downloadBilletUsecase(
            DownloadBilletUsecaseParams(
              billet: billet,
              reference: reference,
            ),
          );
          resultPdf.fold((failure) => null, (pdf) => file = pdf);
          bloc.add(
            BilletsDetailSuccessEvent(billet: billet),
          );
        }
      },
    );
  }
}
