import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_fill_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_loading_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_success_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetSignDialog {
  static Future<bool?> show(BuildContext context, DateTime period) async {
    return showDialog(
        context: context,
        builder: (context) {
          return TimesheetSignDialogBody(period: period);
        });
  }
}

class TimesheetSignDialogBody extends StatefulWidget {
  final DateTime period;
  const TimesheetSignDialogBody({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  State<TimesheetSignDialogBody> createState() =>
      _TimesheetSignDialogBodyState();
}

class _TimesheetSignDialogBodyState extends State<TimesheetSignDialogBody> {
  TimesheetSignBloc timesheetSignBloc =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider(
        create: (context) => timesheetSignBloc,
        child: BlocBuilder<TimesheetSignBloc, TimesheetSignState>(
          bloc: timesheetSignBloc,
          builder: ((context, state) {
            if (state is TimesheetSignLoadingState) {
              return const TimesheetSignLoadingBody();
            }
            if (state is TimesheetSignFailedState) {
              return TimesheetSignFailedBody(
                tryAgain: () {
                  timesheetSignBloc.timesheetSign(widget.period);
                },
              );
            }
            if (state is TimesheetSignSuccessState) {
              return const TimesheetSignSuccessBody();
            }
            return TimesheetSignFillBody(
              timesheetSign: () {
                timesheetSignBloc.timesheetSign(widget.period);
              },
            );
          }),
        ),
      ),
    );
  }
}
