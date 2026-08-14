import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetMenuPageArgs {
  TimesheetMenuBloc timesheetMenuBloc;
  TimesheetMenuPageArgs(this.timesheetMenuBloc);
}

class TimesheetMenuPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const TimesheetMenuPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _TimesheetMenuPageState createState() => _TimesheetMenuPageState();
}

class _TimesheetMenuPageState extends State<TimesheetMenuPage> {
  // final TimesheetMenuBloc bloc = ApplicationContainer.instance().resolve();
  late TimesheetMenuBloc bloc;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshKey2 =
      GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;

  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime firstDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    _refreshCompleter = new Completer();
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    bloc.state.selectedMonth =
        ModalRoute.of(context)!.settings.arguments as DateTime?;
    return Theme(
      data: theme,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PrimaryAppBar(
            theme: theme,
            title: getString(context, "gdp_timesheet_appBar"),
            tabs: TabBar(
              indicatorColor: theme.primaryColor,
              tabs: [
                Tab(text: getString(context, "gdp_timesheet_tab_overview")),
                Tab(text: getString(context, "gdp_timesheet_tab_employees")),
              ],
            ),
          ),
          body: BlocProvider.value(
            value: bloc,
            child: BlocConsumer<TimesheetMenuBloc, TimesheetMenuState>(
              listener: (context, state) {
                if (state is TimesheetMenuReportLoadingState) {
                  if (refreshKey.currentState != null) {
                    refreshKey.currentState!.show();
                  }
                  if (refreshKey2.currentState != null) {
                    refreshKey2.currentState!.show();
                  }
                } else {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer<void>();
                }
                if (state is TimesheetMenuWarningState) {
                  pushNamedAndPopUntil(
                      context,
                      SharedApplicationRoute.gdpTimesheetWarning,
                      ModalRoute.withName(SharedApplicationRoute.gdp));
                }
                if (state is TimesheetRequestLoadedState) {
                  pushNamedAndPopUntil(
                      context,
                      SharedApplicationRoute.gdpTimesheetSignSuccess,
                      ModalRoute.withName(SharedApplicationRoute.gdp));
                }
              },
              builder: (context, state) {
                return TabBarView(
                  children: [
                    SingleChildScrollView(
                        child: _buildReportContent(theme, state)),
                    Column(
                      children: [
                        _buildEmployeeContent(theme, state),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Column _buildReportContent(ThemeData theme, TimesheetMenuState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
          child: Text(getString(context, "gdp_timesheet_label_today"),
              style: LelloTextStyles.subtitleBold(theme)),
        ),
        SizedBox(height: Dimens.spacingSmall),
        _buildGrid(theme, state),
        SizedBox(height: Dimens.spacingLarge),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
          child: Text(getString(context, "gdp_timesheet_label_total_month"),
              style: LelloTextStyles.subtitleBold(theme)),
        ),
        Divider(),
        _buildOccurance(theme, context),
        Divider(),
        _buildSign(theme, context),
      ],
    );
  }

  Widget _buildGrid(ThemeData theme, TimesheetMenuState state) {
    if (state is TimesheetMenuEmployeesLoadFailedState ||
        state is TimesheetMenuReportLoadFailedState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Center(
          child: Text(
            getString(context, "gdp_timesheet_error"),
            style: LelloTextStyles.error(theme),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        bloc.beginRefresh();
        return _refreshCompleter.future;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 1.4,
          crossAxisCount: 2,
          mainAxisSpacing: Dimens.spacing,
          crossAxisSpacing: Dimens.spacingSmall,
          children: <Widget>[
            _retangularButton(
                theme,
                state.report?.presentAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_working"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.present,
                      dobFrom: today,
                      dobTo: today));
            }),
            _retangularButton(
                theme,
                state.report?.dayOffAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_day_off"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.dayOff,
                      dobFrom: today,
                      dobTo: today));
            }),
            _retangularButton(
                theme,
                state.report?.vacationAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_vacation"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.vacation,
                      dobFrom: today,
                      dobTo: today));
            }),
            _retangularButton(
                theme,
                state.report?.attestationAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_attestation"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.attestation,
                      dobFrom: today,
                      dobTo: today));
            }),
            _retangularButton(
                theme,
                state.report?.unmarkedAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_unmarked"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.unmarked,
                      dobFrom: today,
                      dobTo: today));
            }),
            _retangularButton(
                theme,
                state.report?.shiftNotStartedAmount?.toString() ?? "0",
                state.report?.totalAmount?.toString() ?? "0",
                getString(context, "gdp_timesheet_grid_shift_not_started"), () {
              Navigator.of(context).pushNamed(
                  SharedApplicationRoute.gdpTimesheetList,
                  arguments: TimesheetFilter(
                      type: TimesheetTypeEnum.shiftNotStarted,
                      dobFrom: today,
                      dobTo: today));
            }),
          ],
        ),
      ),
    );
  }

  Widget _retangularButton(ThemeData theme, String value, String total,
      String title, VoidCallback? onPressed) {
    final pallete = LelloTheme.palleteOf(theme);
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(color: pallete.separator(), width: 1)),
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Dimens.spacing, Dimens.spacing, Dimens.spacing, Dimens.spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: new TextSpan(
                  style: LelloTextStyles.subtitleBold(theme),
                  children: <TextSpan>[
                    TextSpan(
                        text: value,
                        style: LelloTextStyles.title(theme)!
                            .copyWith(color: pallete.hubText())),
                    total != ""
                        ? TextSpan(
                            text: '/' + total,
                            style: LelloTextStyles.subtitle(theme)!
                                .copyWith(color: pallete.hubText()))
                        : TextSpan(),
                  ],
                ),
              ),
              Text(
                title,
                style: LelloTextStyles.subtitleBold(theme)!
                    .copyWith(color: pallete.hubText()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccurance(ThemeData theme, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      leading: SvgPicture.asset("assets/ic_timesheet_occurrences.svg"),
      title: Text(getString(context, "gdp_timesheet_menu_option_event"),
          style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(
          getString(context, "gdp_timesheet_menu_option_event_description"),
          style: LelloTextStyles.subBody(theme)),
      trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
      onTap: () => Navigator.of(context).pushNamed(
          SharedApplicationRoute.gdpTimesheetList,
          arguments: TimesheetFilter(
              type: TimesheetTypeEnum.events,
              dobFrom: today.subtract(Duration(days: 90)),
              dobTo: today)),
    );
  }

  Widget _buildSign(ThemeData theme, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      leading: SvgPicture.asset("assets/ic_timesheet_sign.svg"),
      title: Text(getString(context, "gdp_timesheet_menu_option_sign"),
          style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(
          getString(context, "gdp_timesheet_menu_option_sign_description"),
          style: LelloTextStyles.subBody(theme)),
      trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
      onTap: () => Navigator.of(context).pushNamed(
          SharedApplicationRoute.gdpTimesheetSign,
          arguments: TimesheetFilter(
              type: TimesheetTypeEnum.events,
              dobFrom: firstDayMonth,
              dobTo: today)),
    );
  }

  Widget _buildEmployeeContent(ThemeData theme, TimesheetMenuState state) {
    final itemsCount = state.list.length;
    if (state is TimesheetMenuEmployeesLoadFailedState) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Center(
            child: Text(
              getString(context, "gdp_timesheet_error"),
              style: LelloTextStyles.error(theme),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    if (itemsCount == 0) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacing),
          child: Center(
            child: Text(
              getString(context, "gdp_timesheet_empty"),
              style: LelloTextStyles.bodyBold(theme),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey2,
        onRefresh: () async {
          bloc.beginRefresh();
          return _refreshCompleter.future;
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == state.list.length) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final entity = state.list[index];
              return ListTile(
                contentPadding: EdgeInsets.all(Dimens.spacing),
                title:
                    Text(entity.name!, style: LelloTextStyles.bodyBold(theme)),
                subtitle: Text(entity.role ?? '',
                    style: LelloTextStyles.subBody(theme)),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      SharedApplicationRoute.gdpTimesheetList,
                      arguments: TimesheetFilter(
                          name: entity.name,
                          type: TimesheetTypeEnum.employee,
                          dobFrom: today,
                          dobTo: today));
                },
                trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
              );
            },
            controller: controller,
            separatorBuilder: (context, index) => Container(
                color: LelloTheme.palleteOf(theme).separator(), height: 1),
            itemCount: itemsCount),
      ),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (!(bloc.state is PayslipEmployeesPagingState) &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      // bloc.beginLoadNextPage();
    }
  }
}
