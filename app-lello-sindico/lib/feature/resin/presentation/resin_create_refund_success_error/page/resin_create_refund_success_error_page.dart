import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/widgets/resin_create_refund_error_widget.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/widgets/resin_create_refund_success_widget.dart';

class ResinCreateRefundSuccessErrorPageArgs {
  bool isSuccess;
  ResinParams params;
  ResinRefund? refund;
  ResinCreateRefundSuccessErrorPageArgs({
    required this.isSuccess,
    required this.params,
    this.refund,
  });
}

class ResinCreateRefundSuccessErrorPage extends StatefulWidget {
  const ResinCreateRefundSuccessErrorPage({Key? key}) : super(key: key);

  @override
  State<ResinCreateRefundSuccessErrorPage> createState() =>
      _ResinCreateRefundSuccessErrorPageState();
}

class _ResinCreateRefundSuccessErrorPageState
    extends State<ResinCreateRefundSuccessErrorPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ResinCreateRefundSuccessErrorPageArgs;
    ResinRefund? refund = arguments.refund;
    bool isSuccess = arguments.isSuccess;
    ResinParams params = arguments.params;
    return WillPopScope(
      onWillPop: () async {
        // _onPop(comfortMyRequestsBloc);
        return true;
      },
      child: Theme(
        data: theme,
        child: isSuccess
            ? ResinCreateRefundSuccessWidget(params: params, refund: refund)
            : ResinCreateRefundErrorWidget(refundType: refund?.type),
      ),
    );
  }

  // void _onPop(ComfortMyRequestsBloc comfortMyRequestsBloc) {
  //   comfortMyRequestsBloc.getMyRequests();
  // }
}
