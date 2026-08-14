import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/controller/resin_send_receipt_controller.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/widgets/resin_send_receipt_widget.dart';

class ResinSendReceiptPageArgs {
  ResinParams resinParams;

  ResinSendReceiptPageArgs({
    required this.resinParams,
  });
}

class ResinSendReceiptPage extends StatefulWidget {
  const ResinSendReceiptPage({Key? key}) : super(key: key);

  @override
  State<ResinSendReceiptPage> createState() => _ResinSendReceiptPageState();
}

class _ResinSendReceiptPageState extends State<ResinSendReceiptPage> {
  ResinSendReceiptController controller =
      ApplicationContainer.instance().resolve();

  late ResinParams resinParams;

  @override
  void initState() {
    controller.clearFilters();
    controller.getReceipts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    ResinSendReceiptPageArgs args =
        ModalRoute.of(context)?.settings.arguments as ResinSendReceiptPageArgs;
    resinParams = args.resinParams;

    return BlocProvider.value(
      value: controller.bloc,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: PrimaryAppBar(
              title: getString(context, "resin_advances"),
              theme: theme,
              ),
          body: ResinSendReceiptWidget(
            params: resinParams,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
