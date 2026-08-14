import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_failure_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/shared_features.dart';

class ScheduleVacationDetailsPageArgs {
  ScheduleVacationBloc scheduleVacationBloc;
  List<PeriodConfig> periodConfig;
  ScheduleVacationDetailsPageArgs(this.periodConfig, this.scheduleVacationBloc);
}

class ScheduleVacationDetailsPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ScheduleVacationDetailsPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  State<ScheduleVacationDetailsPage> createState() =>
      _ScheduleVacationDetailsPageState();
}

class _ScheduleVacationDetailsPageState
    extends State<ScheduleVacationDetailsPage> {
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

    ScheduleVacationDetailsPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ScheduleVacationDetailsPageArgs;

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
                  _backButton(theme, context),
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

  _backButton(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Container(
          width: double.infinity,
          height: 54.0,
          child: PrimaryButton(
            text: getString(context, 'back'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
