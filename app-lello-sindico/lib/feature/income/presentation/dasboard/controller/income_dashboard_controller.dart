import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_event.dart';

import '../../../../../core/analytics/analytics_log_events.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/use_case/get_monthly_income/get_income.dart';
import '../bloc/income_dashboard_bloc.dart';

class IncomeDashboardController {
  final SessionBloc sessionBloc;
  final IncomeDashboardBloc incomeDashboardBloc;
  final GetIncome getMonthlyIncome;

  IncomeDashboardController({
    required this.sessionBloc,
    required this.incomeDashboardBloc,
    required this.getMonthlyIncome,
  });

  DateTime? selectedPeriod;

  Future<void> getIncomes({required DateTime period}) async {
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;

    incomeDashboardBloc.add(IncomeDashboardLoadingEvent());

    final result = await getMonthlyIncome(
      GetIncomeParam(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
        period: period,
      ),
    );

    result.fold(
      (failure) async {
        final cache = await getMonthlyIncome(
          GetIncomeParam(
            condominiumId: condominiumId,
            origin: DataOrigin.local,
            period: DateTime.now(),
          ),
        );

        cache.fold(
          (failure) => incomeDashboardBloc.add(
            IncomeDashboardFailureEvent(error: failure),
          ),
          (income) => incomeDashboardBloc.add(
            IncomeDashboardSuccessEvent(income: income!),
          ),
        );
      },
      (income) {
        String reference = sessionBloc
                .state.session!.selectedCondominium?.reference
                .toString() ??
            "";
        ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.receitasControleAcessar(),
          referenceValue: reference,
        );
        incomeDashboardBloc.add(IncomeDashboardSuccessEvent(income: income!));
      },
    );
  }

  void dispose() {
    selectedPeriod = null;
  }
}
