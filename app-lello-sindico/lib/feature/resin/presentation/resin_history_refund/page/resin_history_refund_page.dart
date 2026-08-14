import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/controller/resin_history_refund_controller.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/widgets/resin_history_refund_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_history_filter_widget.dart';

class ResinHistoryRefundPageArgs {
  ResinParams resinParams;

  ResinHistoryRefundPageArgs(this.resinParams);
}

class ResinHistoryRefundPage extends StatefulWidget {
  const ResinHistoryRefundPage({Key? key}) : super(key: key);

  @override
  State<ResinHistoryRefundPage> createState() => _ResinHistoryRefundPageState();
}

class _ResinHistoryRefundPageState extends State<ResinHistoryRefundPage> {
  ResinHistoryRefundController controller =
      ApplicationContainer.instance().resolve();

  late ResinParams resinParams;

  @override
  void initState() {
    controller.clearFilters();
    controller.historyGetParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResinHistoryRefundPageArgs arguments = ModalRoute.of(context)
        ?.settings
        .arguments as ResinHistoryRefundPageArgs;

    if (controller.filter.endDate == null) {
      controller.filter.startDate = arguments.resinParams.filterStartDate;
      controller.filter.endDate = arguments.resinParams.filterEndDate;
    }

    return BlocProvider.value(
      value: controller.bloc,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              title: getString(context, "resin_refund_history"),
              theme: theme,
              ),
          endDrawer: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Drawer(
              backgroundColor: theme.primaryColor,
              child: ResinHistoryFilterWidget(
                filter: controller.filter,
                params: arguments.resinParams,
                onSearch: () {
                  controller.filterRefunds();
                },
              ),
            ),
          ),
          body: ResinHistoryRefundWidget(
              resinParams: arguments.resinParams, controller: controller),
        ),
      ),
    );
  }
}
