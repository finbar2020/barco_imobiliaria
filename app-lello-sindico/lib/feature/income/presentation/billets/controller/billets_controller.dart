import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/income/domain/entity/billet_status_enum.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

import '../../../../unit/domain/entity/unit.dart';

class BilletsController {
  final SessionBloc sessionBloc;
  final BilletsBloc billetsBloc;
  final GetUnitsByBilletsUseCase getUnitsByBilletsUseCase;
  final GetBilletPeriodAvailabilityUseCase getBilletPeriodAvailabilityUseCase;
  String? pendingSearch;
  String? pendingIgnoreWords;
  String query = "";
  BilletStatus? status = BilletStatus.open;
  DateTime? period;
  String? lastUnitId;
  bool isDone = false;
  bool isDebouncingBillets = false;
  DateTime? selectedPeriod;
  DateTime? initialDate;
  DateTime? lastDate;

  List<Unit> units = [];
  List<DateTime> billetsPeriodsAvailability = [];

  BilletsController({
    required this.sessionBloc,
    required this.billetsBloc,
    required this.getUnitsByBilletsUseCase,
    required this.getBilletPeriodAvailabilityUseCase,
  }) {
    String reference =
        sessionBloc.state.session!.selectedCondominium?.reference.toString() ??
            "";
    ManagerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.detalhesReceitasAcessar(),
      referenceValue: reference,
    );
  }

  void setBilletState({required BilletStatus billetStatus}) {
    if (billetStatus == status) {
      status = null;
    } else {
      status = billetStatus;
    }
    resetBillets();
  }

  void resetBillets() {
    isDone = false;
    lastUnitId = null;
    units = [];
  }

  Future<void>? getBilletsPeriodsAvailability() async {
    billetsBloc.add(BilletsLoadingEvent(units: units));
    String condominiumId =
        sessionBloc.state.session!.selectedCondominium?.id.toString() ?? "";
    final response = await getBilletPeriodAvailabilityUseCase.call(
        GetBilletPeriodAvailabilityParam(
            condominiumId: condominiumId, limit: null, page: null));
    response.fold(
      (error) {
        isDebouncingBillets = false;
        billetsBloc.add(
          BilletsLoadFailedEvent(error: error),
        );
      },
      (data) {
        if (data != null && data.months.isNotEmpty) {
          billetsPeriodsAvailability = data.months
              .map((month) => DateFormat('MM/yyyy').parse(month))
              .toList();
          initialDate = billetsPeriodsAvailability.reduce(
              (value, element) => value.isBefore(element) ? value : element);
          lastDate = billetsPeriodsAvailability.reduce(
              (value, element) => value.isAfter(element) ? value : element);
          selectedPeriod = lastDate;
          getUnits(ignoreWords: "");
        } else {
          status = null;
          billetsBloc.add(
            BilletsLoadedEvent(units: units),
          );
        }
      },
    );
  }

  Future<void> getUnits({
    required String ignoreWords,
  }) async {
    if (isDebouncingBillets || isDebouncingBillets) return;
    isDebouncingBillets = true;
    String condominiumId =
        sessionBloc.state.session!.selectedCondominium?.id.toString() ?? "";
    billetsBloc.add(UnitsLoadingEvent(units: units));
    query = _getCleanValue(query, ignoreWords);

    final response = await getUnitsByBilletsUseCase(
      GetUnitsByBilletsParam(
        condominiumId: condominiumId,
        filter: BilletFilter(
          lastUnitId: null,
          period: selectedPeriod,
          query: query,
          status: status,
        ),
      ),
    );
    response.fold(
      (error) {
        isDebouncingBillets = false;
        billetsBloc.add(
          BilletsLoadFailedEvent(error: error),
        );
      },
      (data) {
        isDebouncingBillets = false;
        isDone = false;
        units = data;
        units = units.toSet().toList();
        lastUnitId = data.isNotEmpty ? data.last.id : null;

        billetsBloc.add(
          BilletsLoadedEvent(units: units),
        );
      },
    );
  }

  Future<void> getUnitsPaginated({
    required String ignoreWords,
  }) async {
    if (isDone) return;
    String condominiumId =
        sessionBloc.state.session!.selectedCondominium?.id.toString() ?? "";
    billetsBloc.add(BilletsPagingEvent(units: units));
    query = _getCleanValue(query, ignoreWords);

    final response = await getUnitsByBilletsUseCase(
      GetUnitsByBilletsParam(
        condominiumId: condominiumId,
        filter: BilletFilter(
          lastUnitId: lastUnitId,
          period: selectedPeriod,
          query: query,
          status: status,
        ),
      ),
    );
    //await Future.delayed(Duration(seconds: 3));
    response.fold(
      (error) {
        isDebouncingBillets = false;
        billetsBloc.add(
          BilletsLoadFailedEvent(error: error),
        );
      },
      (data) {
        isDebouncingBillets = false;
        if (data.isEmpty) {
          isDone = true;
        }
        units.addAll(data);
        units = units.toSet().toList();
        lastUnitId = data.isNotEmpty ? data.last.id : null;
        billetsBloc.add(
          BilletsLoadedEvent(units: units),
        );
      },
    );
  }

  void dispose() {
    billetsBloc.add(BilletsEmptyEvent());
    units.clear();
    query = "";
    billetsPeriodsAvailability.clear();
    lastUnitId = null;
    status = BilletStatus.open;
  }

  String _getCleanValue(String value, String ignoreWords) => value
      .toLowerCase()
      .replaceAll(" ", "")
      .replaceAll(ignoreWords.toLowerCase(), "");
}
