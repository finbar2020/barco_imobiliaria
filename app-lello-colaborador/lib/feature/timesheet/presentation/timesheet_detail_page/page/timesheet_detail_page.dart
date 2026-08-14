import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_intro_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_list_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class TimesheetDetailPageArgs {
  DateTime period;
  TimesheetDetailPageArgs({required this.period});
}

class TimesheetDetailPage extends StatefulWidget {
  const TimesheetDetailPage({Key? key}) : super(key: key);

  @override
  State<TimesheetDetailPage> createState() => _TimesheetDetailPageState();
}

class _TimesheetDetailPageState extends State<TimesheetDetailPage> {
  TimesheetDetailBloc timesheetDetailBloc =
      ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  bool isFirstBuild = true;
  DateTime period = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (isFirstBuild) {
      isFirstBuild = false;
      TimesheetDetailPageArgs args =
          ModalRoute.of(context)?.settings.arguments as TimesheetDetailPageArgs;
      period = args.period;
      timesheetDetailBloc.getTimesheetDetail(period: period);
    }
    return Scaffold(
      appBar: const CustomAppBar(title: "timesheet_detail_page_appbar"),
      body: BlocProvider(
        create: (context) => timesheetDetailBloc,
        child: BlocBuilder(
          bloc: timesheetDetailBloc,
          builder: (context, state) {
            if (state is TimesheetDetailLoadingState) {
              return const Column(
                children: [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }
            if (state is TimesheetDetailFailedState) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: ErrorHandlingWidget(
                        reTryFunction: () {
                          timesheetDetailBloc.getTimesheetDetail(
                              period: period);
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.failure?.error.toString() ?? "",
                        errorCode: state.failure?.code.toString() ?? "",
                        textReturnButton: "back_to_the_previous_page",
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is TimesheetDetailLoadedState) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: TimesheetDetailIntroWidget(period: period),
                  ),
                  Expanded(
                    child: TimesheetDetailListWidget(
                        timesheetDetail: state.timesheetDetail),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: PrimaryButton(
                        text: getString(context, "timesheet_detail_back"),
                        onPressed: () => Navigator.pop(context)),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
