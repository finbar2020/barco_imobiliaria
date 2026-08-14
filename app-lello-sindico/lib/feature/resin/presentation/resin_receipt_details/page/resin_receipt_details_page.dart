import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/controller/resin_receipt_details_controller.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/widget/resin_receipt_details_widget.dart';

class ResinReceiptDetailsPageArgs {
  ResinRefund refund;
  ResinReceiptDetailsPageArgs({required this.refund});
}

class ResinReceiptDetailsPage extends StatefulWidget {
  const ResinReceiptDetailsPage({Key? key}) : super(key: key);

  @override
  State<ResinReceiptDetailsPage> createState() =>
      _ResinReceiptDetailsPageState();
}

class _ResinReceiptDetailsPageState extends State<ResinReceiptDetailsPage> {
  ResinReceiptDetailsController controller =
      ApplicationContainer.instance().resolve();
  late ThemeData theme;
  bool firstBuild = true;

  @override
  void dispose() {
    controller.resinRefund = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    ResinReceiptDetailsPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ResinReceiptDetailsPageArgs;
    String refundId = arguments.refund.id ?? "";
    String? appBarTitle = arguments.refund.type == ResinRefundType.advance
        ? getString(context, "resin_receipts_appBar_advance")
        : getString(context, "resin_receipts_appBar_refund");
    if (firstBuild) {
      controller.getRefundDetails(refundId);
      firstBuild = false;
    }
    return BlocProvider.value(
      value: controller.bloc,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: PrimaryAppBar(
              title: appBarTitle,
              theme: theme,
              ),
          body: ResinReceiptDetailsWidget(
            refundId: refundId,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
