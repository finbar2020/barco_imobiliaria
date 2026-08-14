import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_page_body_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class TimesheetPageArgs {
  String? period;
  TimesheetPageArgs({this.period});
}

class TimesheetPage extends StatefulWidget {
  const TimesheetPage({Key? key}) : super(key: key);

  @override
  State<TimesheetPage> createState() => _TimesheetPageState();
}

class _TimesheetPageState extends State<TimesheetPage> {
  TimesheetBloc timesheetBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    ThemeData theme = Theme.of(context);

    TimesheetPageArgs? arguments =
        ModalRoute.of(context)?.settings.arguments as TimesheetPageArgs?;

    return Scaffold(
      appBar: const CustomAppBar(title: "timesheet_page_appbar"),
      body: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: BlocProvider(
          create: (context) => timesheetBloc,
          child: BlocBuilder(
            bloc: timesheetBloc,
            builder: (context, state) {
              if (state is TimesheetPeriodsLoadingState) {
                return const Column(
                  children: [
                    Expanded(child: LoadingWidget()),
                  ],
                );
              }
              if (state is TimesheetPeriodsEmptyState) {
                return Column(
                  children: [
                    Expanded(
                      child: Text(
                        getString(context, "timesheet_page_get_periods_empty"),
                        style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText()),
                      ),
                    ),
                  ],
                );
              }
              if (state is TimesheetPeriodsFailedState) {
                return ErrorHandlingWidget(
                  errorCode: state.errorCode,
                  error: state.errorDescription,
                  reTryFunction: () => timesheetBloc.getTimesheetPeriods(),
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: env.isProduction,
                );
              }
              if (state is TimesheetPeriodsLoadedState) {
                return TimesheetPageBody(
                    timesheetPeriods: state.timesheetPeriods,
                    selectedPeriod: arguments?.period);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
