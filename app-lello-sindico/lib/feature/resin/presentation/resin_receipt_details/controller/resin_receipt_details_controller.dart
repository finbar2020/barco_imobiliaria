import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinReceiptDetailsController {
  final ResinReceiptDetailsBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinRefundDetails getResinRefundDetails;
  final UploadNewReceipt uploadNewReceipt;

  ResinRefund? resinRefund;

  ResinReceiptDetailsController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinRefundDetails,
    required this.uploadNewReceipt,
  });

  getRefundDetails(String refundId) async {
    bloc.add(ResinReceiptDetailsLoadingEvent());

    if (refundId.isEmpty) {
      bloc.add(ResinReceiptDetailsErrorEvent(errorMessageKey: "error_unknown"));
    }

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await getResinRefundDetails.call(
        GetResinRefundDetailsParams(
            condominiumId: condominiumId, refundId: refundId));

    response.fold(
      (error) => bloc
          .add(ResinReceiptDetailsErrorEvent(errorMessageKey: "error_unknown")),
      (data) {
        resinRefund = data;
        bloc.add(ResinReceiptDetailsLoadedEvent(refund: data));
      },
    );
  }

  uploadReceipt(String refundId, ResinRefundReceipt receipt) async {
    bloc.add(ResinReceiptDetailsLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await uploadNewReceipt.call(UploadNewReceiptParams(
      condominiumId: condominiumId,
      refundId: refundId,
      receipt: receipt,
    ));

    response.fold(
      (error) => bloc
          .add(ResinReceiptDetailsErrorEvent(errorMessageKey: "error_unknown")),
      (data) {
        resinRefund!.receipts.add(data);
        bloc.add(ResinReceiptDetailsLoadedEvent(
          refund: resinRefund!,
          flushbarMessageKey: "resin_receipts_upload_success",
        ));
      },
    );
  }
}
