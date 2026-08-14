import 'package:essentials/enum/data_origin.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinHistoryRefundController {
  final ResinHistoryRefundBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinRefunds getResinRefunds;
  final GetResinRefundDetails getResinRefundDetails;
  final DeleteResinRefund deleteResinRefund;

  List<ResinRefund> refunds = [];

  late ResinRefundFilter filter;

  ResinHistoryRefundController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinRefunds,
    required this.getResinRefundDetails,
    required this.deleteResinRefund,
  }) {
    clearFilters();
  }

  historyGetParams() async {
    bloc.add(ResinHistoryRefundLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //buscaCache
    final responseCache = await getResinRefunds.call(GetResinRefundsParams(
      condominiumId: condominiumId,
      filter: filter,
      origin: DataOrigin.local,
    ));

    responseCache.fold((error) => bloc.add(ResinHistoryRefundLoadingEvent()),
        (data) {
      if (data.isEmpty) return bloc.add(ResinHistoryRefundLoadingEvent());
      refunds = data;
      bloc.add(ResinHistoryRefundLoadedEvent(
        refunds: data,
        loadingRemote: true,
      ));
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
      (error) => bloc.add(ResinHistoryRefundErrorEvent(
          errorMessageKey: "resin_advances_history_error")),
      (data) {
        refunds = data;
        bloc.add(ResinHistoryRefundLoadedEvent(refunds: data));
      },
    );
  }

  cancelRefund(String refundId) async {
    bloc.add(ResinHistoryRefundDeleteLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await deleteResinRefund.call(DeleteResinRefundParams(
        condominiumId: condominiumId, refundId: refundId));

    response.fold(
      (error) => bloc.add(ResinHistoryRefundLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_advances_cancel_error")),
      (data) {
        bloc.add(ResinHistoryRefundLoadedEvent(
            refunds: refunds,
            updateRefunds: true,
            flushbarMessageKey: "resin_advances_cancel_success"));
        historyGetParams();
      },
    );
  }

  filterRefunds() async {
    bloc.add(ResinHistoryRefundLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final responseRemote = await getResinRefunds.call(
      GetResinRefundsParams(
        condominiumId: condominiumId,
        filter: filter,
        origin: DataOrigin.remote,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinHistoryRefundLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_history_error_filter")),
      (data) {
        if (data.isEmpty) {
          bloc.add(ResinHistoryRefundLoadedEvent(
              refunds: refunds,
              flushbarMessageKey: "resin_history_empty_filter"));
        } else {
          bloc.add(ResinHistoryRefundLoadedEvent(
            refunds: data,
          ));
        }
      },
    );
  }

  getRefundDetails(String? refundId) async {
    bloc.add(ResinHistoryRefundLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await getResinRefundDetails.call(
        GetResinRefundDetailsParams(
            condominiumId: condominiumId, refundId: refundId ?? ""));

    response.fold(
      (error) => bloc.add(ResinHistoryRefundLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_refund_details_error")),
      (data) {
        bloc.add(ResinRefundDetailsLoadedEvent(data));
      },
    );
    bloc.add(ResinHistoryRefundLoadedEvent(refunds: refunds));
  }

  clearFilters() {
    filter = ResinRefundFilter(
      type: ResinRefundType.refund,
      startDate: null,
      endDate: null,
    );
  }
}
