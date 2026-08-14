import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/controller/resin_history_advance_controller.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/widgets/resin_history_advance_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_history_filter_widget.dart';

class ResinHistoryAdvancePageArgs {
  ResinParams resinParams;

  ResinHistoryAdvancePageArgs(this.resinParams);
}

class ResinHistoryAdvancePage extends StatefulWidget {
  const ResinHistoryAdvancePage({Key? key}) : super(key: key);

  @override
  State<ResinHistoryAdvancePage> createState() =>
      _ResinHistoryAdvancePageState();
}

class _ResinHistoryAdvancePageState extends State<ResinHistoryAdvancePage> {
  ResinHistoryAdvanceController controller =
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
    ResinHistoryAdvancePageArgs arguments = ModalRoute.of(context)
        ?.settings
        .arguments as ResinHistoryAdvancePageArgs;

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
              title: getString(context, "resin_advances_history"),
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
                  controller.filterAdvances();
                },
              ),
            ),
          ),
          body: ResinHistoryAdvanceWidget(
              resinParams: arguments.resinParams, controller: controller),
        ),
      ),
    );
  }
}
