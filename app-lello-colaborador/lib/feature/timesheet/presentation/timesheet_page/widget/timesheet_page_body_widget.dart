import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/page/timesheet_sign_dialog.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/page/timesheet_email_dialog.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_intro_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_list_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetPageBody extends StatefulWidget {
  final List<TimesheetPeriods> timesheetPeriods;
  final String? selectedPeriod;
  const TimesheetPageBody(
      {Key? key, required this.timesheetPeriods, this.selectedPeriod})
      : super(key: key);

  @override
  State<TimesheetPageBody> createState() => _TimesheetPageBodyState();
}

class _TimesheetPageBodyState extends State<TimesheetPageBody> {
  TimesheetBloc timesheetBloc = ApplicationContainer.instance().resolve();
  TimesheetPeriods? selectedDate;
  DateTime? periodStartDate;
  DateTime? periodEndDate;

  @override
  void initState() {
    super.initState();
    if (widget.timesheetPeriods.isNotEmpty) {
      if (widget.selectedPeriod != null && loadedFromNotification == false) {
        try {
          loadedFromNotification = true;
          selectedDate = widget.timesheetPeriods.firstWhere(
            (element) =>
                element.periodMonth ==
                DateFormat("dd/MM/yyyy").parse("01/${widget.selectedPeriod}"),
          );
        } catch (e) {
          debugPrint("invalid date format");
        }
      }
      periodStartDate =
          selectedDate?.startDate ?? widget.timesheetPeriods.first.startDate;
      periodEndDate =
          selectedDate?.endDate ?? widget.timesheetPeriods.first.endDate;
      timesheetBloc.getTimesheet(
          period: selectedDate?.periodMonth ??
              widget.timesheetPeriods.first.periodMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (selectedDate == null && timesheetBloc.availableDates.isNotEmpty) {
      timesheetBloc.availableDates.first;
    }
    return Center(
      child: BlocProvider(
        create: (context) => timesheetBloc,
        child: BlocBuilder(
          bloc: timesheetBloc,
          builder: (context, state) {
            if (state is TimesheetLoadingState) {
              return const Column(
                children: [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }
            if (state is TimesheetFailedState) {
              return Column(
                children: [
                  _buildIntro(),
                  SizedBox(height: Dimens.spacingMedium),
                  Expanded(
                    child: Text(
                      getString(context, "timesheet_page_get_error"),
                      style: LelloTextStyles.subtitle(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).hubText()),
                    ),
                  ),
                ],
              );
            }

            if (state is TimesheetLoadedState) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildIntro(
                            timesheetStatus: state.timesheet.timesheetStatus,
                            timeSheet: state.timesheet,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          TimesheetListWidget(timesheet: state.timesheet),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  if (state.timesheet.timesheetElements.isNotEmpty &&
                      state.timesheet.timesheetStatus ==
                          TimesheetStatusEnum.notAssigned)
                    PrimaryButton(
                        buttonColor: LelloTheme.palleteOf(theme).warning(),
                        text: getString(context, "timesheet_page_assign"),
                        onPressed: () {
                          TimesheetSignDialog.show(
                                  context, state.timesheet.dateTo)
                              .then((value) {
                            if (value == true) {
                              timesheetBloc.getTimesheet(
                                  period: state.timesheet.dateTo);
                            }
                          });
                        }),
                  SizedBox(height: Dimens.spacingSmall),
                  if (state.timesheet.timesheetElements.isNotEmpty)
                    PrimaryButton(
                        text: getString(context, "timesheet_page_send_email"),
                        onPressed: () {
                          TimesheetEmailDialog.show(
                              context, state.timesheet.dateFrom);
                        }),
                ],
              );
            }
            return Column(
              children: [
                _buildIntro(),
                SizedBox(height: Dimens.spacingMedium),
              ],
            );
          },
        ),
      ),
    );
  }

  bool loadedFromNotification = false;
  Widget _buildIntro(
      {TimesheetStatusEnum? timesheetStatus, Timesheet? timeSheet}) {
    if (timesheetBloc.availableDates.isNotEmpty) {
      return TimesheetIntro(
          date: selectedDate?.periodMonth ?? timesheetBloc.availableDates.first,
          onDateSelected: _onDateSelected,
          timesheet: timeSheet,
          timesheetStatus: timesheetStatus,
          periodEndDate: periodEndDate,
          periodStartDate: periodStartDate,
          setPeriods: _setPeriods);
    }
    return Container();
  }

  void _onDateSelected(DateTime? value) {
    if (value != null) {
      timesheetBloc.getTimesheet(period: value);
      selectedDate = widget.timesheetPeriods
          .firstWhere((element) => element.periodMonth == value);
    }
  }

  void _setPeriods(int index, List<TimesheetPeriods> timesheetPeriods) {
    if (timesheetPeriods.isNotEmpty) {
      setState(() {
        periodStartDate = timesheetPeriods[index].startDate;
        periodEndDate = timesheetPeriods[index].endDate;
      });
    }
  }
}
