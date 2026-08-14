import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_bloc.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_event.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';

class PaymentHistoryController {
  final ListPaymentHistory listPaymentHistoryUseCase;
  final SessionBloc sessionBloc;
  final PaymentHistoryListBloc bloc;

  PaymentHistoryController({
    required this.listPaymentHistoryUseCase,
    required this.sessionBloc,
    required this.bloc,
  });

  DateTime startDate = DateTime.now().firstDayOfMonth();
  DateTime endDate = DateTime.now().lastDayOfMonth();
  String? numDoc;

  setFilter({
    DateTime? start,
    DateTime? end,
    String? doc,
  }) {
    startDate = start ?? DateTime.now().firstDayOfMonth();
    endDate = end ?? DateTime.now().lastDayOfMonth();
    numDoc = doc;
  }

  Future<void> fetchPaymentFilter() async {
    bloc.add(PaymentHistoryLoadingEvent());
    final result = await listPaymentHistoryUseCase(
      ListPaymentHistoryParam(
        condominiumId: condominiumId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    result.fold(
      (err) => bloc.add(PaymentHistoryFailureEvent(error: err)),
      (items) {
        if (items.isEmpty) {
          return bloc.add(PaymentHistoryEmptyEvent());
        }
        if (numDoc != null) {
          items = items
              .where((element) => element.releaseId?.contains(numDoc!) ?? false)
              .toList();
        }
        bloc.add(
          PaymentHistorySuccessEvent(
            data: items,
          ),
        );
      },
    );
  }

  void clearFilters() {
    startDate = DateTime.now().firstDayOfMonth();
    endDate = DateTime.now().lastDayOfMonth();
    numDoc = null;
  }

  String get condominiumId =>
      sessionBloc.state.session!.selectedCondominium!.id;
}
