import 'package:essentials/enum/data_origin.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/bloc/resin_history_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/bloc/resin_history_advance_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinHistoryAdvanceController {
  final ResinHistoryAdvanceBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinRefunds getResinRefunds;
  final GetResinRefundDetails getResinRefundDetails;
  final DeleteResinRefund deleteResinRefund;

  List<ResinRefund> refunds = [];

  late ResinRefundFilter filter;

  ResinHistoryAdvanceController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinRefunds,
    required this.getResinRefundDetails,
    required this.deleteResinRefund,
  }) {
    clearFilters();
  }

  historyGetParams() async {
    bloc.add(ResinHistoryAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //buscaCache
    final responseCache = await getResinRefunds.call(GetResinRefundsParams(
      condominiumId: condominiumId,
      filter: filter,
      origin: DataOrigin.local,
    ));

    responseCache.fold((error) => bloc.add(ResinHistoryAdvanceLoadingEvent()),
        (data) {
      if (data.isEmpty) return bloc.add(ResinHistoryAdvanceLoadingEvent());
      refunds = data;
      bloc.add(ResinHistoryAdvanceLoadedEvent(
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
      (error) => bloc.add(ResinHistoryAdvanceErrorEvent(
          errorMessageKey: "resin_advances_history_error")),
      (data) {
        refunds = data;
        bloc.add(ResinHistoryAdvanceLoadedEvent(refunds: data));
      },
    );
  }

  cancelAdvance(String refundId) async {
    bloc.add(ResinHistoryAdvanceDeleteLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await deleteResinRefund.call(DeleteResinRefundParams(
        condominiumId: condominiumId, refundId: refundId));

    response.fold(
      (error) => bloc.add(ResinHistoryAdvanceLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_advances_cancel_error")),
      (data) {
        bloc.add(ResinHistoryAdvanceLoadedEvent(
            refunds: refunds,
            updateRefunds: true,
            flushbarMessageKey: "resin_advances_cancel_success"));
        historyGetParams();
      },
    );
  }

  filterAdvances() async {
    bloc.add(ResinHistoryAdvanceLoadingEvent());

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
      (error) => bloc.add(ResinHistoryAdvanceLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_history_error_filter")),
      (data) {
        if (data.isEmpty) {
          bloc.add(ResinHistoryAdvanceLoadedEvent(
              refunds: refunds,
              flushbarMessageKey: "resin_history_empty_filter"));
        } else {
          bloc.add(ResinHistoryAdvanceLoadedEvent(
            refunds: data,
          ));
        }
      },
    );
  }

  getRefundDetails(String? refundId) async {
    bloc.add(ResinHistoryAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await getResinRefundDetails.call(
        GetResinRefundDetailsParams(
            condominiumId: condominiumId, refundId: refundId ?? ""));

    response.fold(
      (error) => bloc.add(ResinHistoryAdvanceLoadedEvent(
          refunds: refunds, flushbarMessageKey: "resin_refund_details_error")),
      (data) {
        bloc.add(ResinAdvanceDetailsLoadedEvent(data));
      },
    );
    bloc.add(ResinHistoryAdvanceLoadedEvent(refunds: refunds));
  }

  clearFilters() {
    filter = ResinRefundFilter(
      type: ResinRefundType.advance,
      startDate: null,
      endDate: null,
    );
  }
}
