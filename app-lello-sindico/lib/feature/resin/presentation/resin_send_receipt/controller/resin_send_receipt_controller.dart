import 'package:essentials/enum/data_origin.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinSendReceiptController {
  final ResinSendReceiptBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinRefunds getResinRefunds;
  ResinSendReceiptController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinRefunds,
  }) {
    clearFilters();
  }

  late ResinRefundFilter filter;

  getReceipts() async {
    bloc.add(ResinSendReceiptLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //buscaCache
    final responseCache = await getResinRefunds.call(GetResinRefundsParams(
      condominiumId: condominiumId,
      filter: filter,
      origin: DataOrigin.local,
    ));

    responseCache.fold((error) => bloc.add(ResinSendReceiptLoadingEvent()),
        (data) {
      if (data.isEmpty) return bloc.add(ResinSendReceiptLoadingEvent());
      bloc.add(
          ResinSendReceiptSuccessEvent(refunds: data, loadingRemote: true));
    });

    //buscaRemote
    final responseRemote = await getResinRefunds.call(
      GetResinRefundsParams(
        condominiumId: condominiumId,
        filter: filter,
        origin: DataOrigin.remote,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinSendReceiptErrorEvent(
          errorMessageKey: "resin_advances_history_error")),
      (data) {
        data = data
            .where((element) => element.status != ResinRefundStatus.canceled)
            .toList();
        bloc.add(ResinSendReceiptSuccessEvent(refunds: data));
      },
    );
  }

  clearFilters() {
    filter = ResinRefundFilter(
      type: ResinRefundType.advance,
      startDate: null,
      endDate: null,
    );
  }
}
