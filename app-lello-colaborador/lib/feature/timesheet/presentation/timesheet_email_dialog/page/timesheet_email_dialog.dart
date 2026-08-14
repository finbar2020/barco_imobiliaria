import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_fill_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_loading_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_success_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetEmailDialog {
  static show(BuildContext context, DateTime period) {
    showDialog(
        context: context,
        builder: (context) {
          return TimesheetEmailDialogBody(period: period);
        });
  }
}

class TimesheetEmailDialogBody extends StatefulWidget {
  final DateTime period;
  const TimesheetEmailDialogBody({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  State<TimesheetEmailDialogBody> createState() =>
      _TimesheetEmailDialogBodyState();
}

class _TimesheetEmailDialogBodyState extends State<TimesheetEmailDialogBody> {
  TimesheetEmailBloc timesheetEmailBloc =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider(
        create: (context) => timesheetEmailBloc,
        child: BlocBuilder<TimesheetEmailBloc, TimesheetEmailState>(
          bloc: timesheetEmailBloc,
          builder: ((context, state) {
            if (state is TimesheetEmailLoadingState) {
              return const TimesheetEmailLoadingBody();
            }
            if (state is TimesheetEmailFailedState) {
              return TimesheetEmailFailedBody(
                  email: state.email,
                  tryAgain: (String email) {
                    timesheetEmailBloc.tryAgain(
                        email: email, period: widget.period);
                  });
            }
            if (state is TimesheetEmailSuccessState) {
              return const TimesheetEmailSuccessBody();
            }
            return TimesheetEmailFillBody(
              emailPrevious: state.email,
              sendEmail: ((email) {
                timesheetEmailBloc.sendEmail(
                    email: email, period: widget.period);
              }),
            );
          }),
        ),
      ),
    );
  }
}
