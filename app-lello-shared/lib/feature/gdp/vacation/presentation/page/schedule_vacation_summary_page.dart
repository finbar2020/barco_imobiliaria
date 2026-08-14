import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_failure_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/shared_features.dart';

class ScheduleVacationSummaryPageArgs {
  ScheduleVacationBloc scheduleVacationBloc;
  List<PeriodConfig> periodConfig;
  ScheduleVacationSummaryPageArgs(this.periodConfig, this.scheduleVacationBloc);
}

class ScheduleVacationSummaryPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ScheduleVacationSummaryPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  State<ScheduleVacationSummaryPage> createState() =>
      _ScheduleVacationSummaryPageState();
}

class _ScheduleVacationSummaryPageState
    extends State<ScheduleVacationSummaryPage> {
  // final ScheduleVacationBloc bloc = ApplicationContainer.instance().resolve();
  late ScheduleVacationBloc bloc;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;

    ScheduleVacationSummaryPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ScheduleVacationSummaryPageArgs;

    List<PeriodConfig> info = arguments.periodConfig;
    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme, title: getString(context, 'gdp_vacation_title')),
          body: BlocConsumer<ScheduleVacationBloc, ScheduleVacationState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ScheduleVacationLoadedState) {
                Navigator.pushNamed(context,
                    SharedApplicationRoute.gdpScheduleVacationSucceeded);
              }
              if (state is ScheduleVacationLoadFailedState) {
                Navigator.pushNamed(
                    context, SharedApplicationRoute.gdpScheduleVacationFailure,
                    arguments:
                        ScheduleVacationFailurePageArgs(faliure: state.error));
              }
            },
            builder: (context, state) {
              if (state is ScheduleVacationLoadingState) {
                return Center(child: LoadingWidget());
              }
              return Container(
                child: _buildVacationSummary(theme, context, info),
              );
            },
          ),
        ));
  }

  Widget _buildVacationSummary(
      ThemeData theme, BuildContext context, List<PeriodConfig> info) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.spacingSmall),
                  Text(getString(context, 'gdp_vacation_employee_code'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].employeeRegistrationNumber.toString(),
                      style: LelloTextStyles.body(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, 'gdp_vacation_employee_name'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].employeeName.toString(),
                      style: LelloTextStyles.body(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, 'gdp_vacation_employee_admission'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].admissionDate.toString(),
                      style: LelloTextStyles.body(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(
                      getString(
                          context, 'gdp_vacation_employee_acquisitive_period'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].periodAquisitive.toString(),
                      style: LelloTextStyles.body(theme)),
                  if (info.length > 0 && info[0].days != null)
                    _buildVacationPeriods(theme, context, info, 0),
                  if (info.length > 1 && info[1].days != null)
                    _buildVacationPeriods(theme, context, info, 1),
                  if (info.length > 2 && info[2].days != null)
                    _buildVacationPeriods(theme, context, info, 2),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, 'gdp_vacation_employee_allowance'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].allowanceValue.toString(),
                      style: LelloTextStyles.body(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(
                      getString(
                          context, 'gdp_vacation_employee_superannuation'),
                      style: LelloTextStyles.bodyBold(theme)),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(info[0].formatedAllow13.toString(),
                      style: LelloTextStyles.body(theme)),
                  _schuduleButton(theme, context, info),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVacationPeriods(ThemeData theme, BuildContext context,
      List<PeriodConfig> info, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(
            info.length > 1
                ? "${index + 1} - ${getString(context, "gdp_vacation_period")}"
                : getString(context, "gdp_vacation_period"),
            style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacingXSmall),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getString(
                              context, 'gdp_vacation_employee_started_at'),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingXSmall),
                      Text(info[index].getStartFormatted.toString(),
                          style: LelloTextStyles.body(theme)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(context, 'gdp_vacation_employee_ended_at'),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingXSmall),
                      Text(info[index].getEndFormatted.toString(),
                          style: LelloTextStyles.body(theme)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(context, 'gdp_vacation_employee_days'),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingXSmall),
                      Text(info[index].days.toString(),
                          style: LelloTextStyles.body(theme)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _schuduleButton(
      ThemeData theme, BuildContext context, List<PeriodConfig> info) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Container(
          width: double.infinity,
          height: 54.0,
          child: PrimaryButton(
            text: getString(context, 'gdp_vacation_employee_schedule'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildDialog(context, info),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDialog(BuildContext context, List<PeriodConfig> info) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "chat_error_title")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text())),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "gdp_vacation_confirm_message"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getString(context, "cancel").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight(),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    VacationCreated vacationCreated = VacationCreated(
                        employeeId: info[0].employeeId,
                        company: info[0].employeeCompany,
                        employeeRegistrationNumber:
                            info[0].employeeRegistrationNumber,
                        vacationScheduledPeriods: getScheduledPeriods(info),
                        salaryAllowance: info[0].allowanceValue.round(),
                        advance13: info[0].allow13Value,
                        numbersUnitVacation: info.length);
                    bloc.createScheduledVacation(
                        info[0].employeeRegistrationNumber.toString(),
                        vacationCreated);
                    Navigator.pop(context);
                  },
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getString(context, "confirm").toUpperCase(),
                        style: LelloTextStyles.bodyBold(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).primary(),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<VacationScheduledPeriods> getScheduledPeriods(List<PeriodConfig> info) {
    return info.isEmpty
        ? []
        : info
            .map((e) => VacationScheduledPeriods(
                startDate: e.start,
                scheduledDays: e.days,
                totalVacation: info.indexOf(e) + 1))
            .toList();
  }
}
