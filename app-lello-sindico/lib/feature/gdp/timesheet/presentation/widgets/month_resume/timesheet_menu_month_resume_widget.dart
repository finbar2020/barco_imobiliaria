import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_extra_hour_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_grid_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_buttons.dart';
import 'package:shared_features/core/modal/month_picker.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class TimesheetMenuMonthResumeWidget extends StatefulWidget {
  final TimesheetMenuBloc bloc;
  const TimesheetMenuMonthResumeWidget({
    super.key,
    required this.bloc,
  });

  @override
  State<TimesheetMenuMonthResumeWidget> createState() =>
      _TimesheetMenuMonthResumeWidgetState();
}

class _TimesheetMenuMonthResumeWidgetState
    extends State<TimesheetMenuMonthResumeWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<TimesheetMenuBloc, TimesheetMenuState>(
      bloc: widget.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimens.spacing),
            InkWell(
              onTap: () async {
                var select = await showMonthPicker(
                    context: context,
                    initialDate: widget.bloc.selectDate,
                    firstDate: widget.bloc.listPeriods.last.periodMonth,
                    lastDate: widget.bloc.listPeriods.first.periodMonth);
                if (select != null) {
                  setState(() {
                    widget.bloc.selectDate = select;
                  });
                  widget.bloc.getMonthResume(select);
                }
              },
              child: Row(
                children: [
                  Text(getString(context, "gdp_timesheet_type_month_analyze"),
                      style: LelloTextStyles.subBody(theme)),
                  Text(
                      '${transformDateInText(widget.bloc.selectDate)}/${widget.bloc.selectDate.year}',
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: LelloTheme.palleteOf(theme).hubText(),
                      )),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Expanded(child: body(state, theme)),
          ],
        );
      },
    );
  }

  transformDateInText(DateTime date) {
    var format = DateFormat.MMMM().format(date);
    return toBeginningOfSentenceCase(format);
  }

  Widget body(TimesheetMenuState state, ThemeData theme) {
    if (state is TimesheetMonthResumeLoadingState) {
      return const LoadingWidget();
    } else if (state is TimesheetMonthResumeFailedState) {
      return ErrorMessageWidget(
          message: getString(context, "agreements_analysis_not_found"));
    } else if (state is TimesheetMonthResumeLoadedState) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimesheetMenuGridWidget(
                state: state, dateList: widget.bloc.listPeriods),
            if (state.entity.showExtraHours)
              SizedBox(height: Dimens.spacingLarge),
            if (state.entity.showExtraHours)
              TimesheetMenuExtraHourWidget(state: state),
            SizedBox(height: Dimens.spacingMedium),
            const Divider(),
            SizedBox(height: Dimens.spacing),
            TimesheetButtons(
                date: widget.bloc.selectDate,
                dateList: widget.bloc.listPeriods),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
