import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/modal/month_picker.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetListPageArgs {
  TimesheetListBloc timesheetListBloc;
  TimesheetListPageArgs(this.timesheetListBloc);
}

class TimesheetListPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const TimesheetListPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _TimesheetListPageState createState() => _TimesheetListPageState();
}

class _TimesheetListPageState extends State<TimesheetListPage> {
  // final TimesheetListBloc bloc = ApplicationContainer.instance().resolve();
  late TimesheetListBloc bloc;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;

  /// Marca a recarga disparada pelo próprio listener (`refreshKey.show()`),
  /// para que o `onRefresh` do RefreshIndicator não peça outra recarga.
  bool _programmaticRefresh = false;
  late ScrollController controller2;
  bool periodValidAllowEdit = false;
  DateTime firstDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  final dateFormat = DateFormat(DateFormat.MONTH, 'pt_Br');
  final today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    _refreshCompleter = new Completer();
    controller2 = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    TimesheetListState state = bloc.state;
    state.query = ModalRoute.of(context)!.settings.arguments as TimesheetFilter;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "gdp_timesheet_appBar")),
        body: BlocProvider.value(
          value: bloc,
          child: BlocConsumer<TimesheetListBloc, TimesheetListState>(
            listener: (context, state) {
              if (state is TimesheetInsertedState) {
                Flushbar(
                  message: getString(
                      context, "gdp_timesheet_flushbar_event_insert_success"),
                  duration: Duration(seconds: 5),
                )..show(context);
              }
              if (state is TimesheetInsertFailedState) {
                Flushbar(
                  message: getString(
                      context, "gdp_timesheet_flushbar_event_insert_error"),
                  duration: Duration(seconds: 5),
                )..show(context);
              }
              if (state is TimesheetListLoadingState) {
                if (refreshKey.currentState != null) {
                  _programmaticRefresh = true;
                  refreshKey.currentState!.show();
                }
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              if (state is TimesheetListLoadedState) {
                if (state.list.isEmpty) {
                  return Center(
                      child: Text("Não encontramos nenhuma ocorrência."));
                }
                periodValidAllowEdit =
                    state.list.any((element) => element.date == today);
              }
              if (state is TimesheetListLoadFailedState) {
                return Center(
                  child: Text(
                    getString(context, "gdp_timesheet_error"),
                    style: LelloTextStyles.error(theme),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return state is TimesheetListLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, state),
                        _buildList(theme, state),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, TimesheetListState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      decoration: BoxDecoration(
          // color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(Dimens.spacingSmall),
        bottomRight: Radius.circular(Dimens.spacingSmall),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: Dimens.spacing),
          Text(
              "${capitalize(timesheetTypeToString(context, state.query!.type!).toLowerCase())}",
              style: LelloTextStyles.subtitleBold(theme)),
          state.query!.type == TimesheetTypeEnum.employee
              ? _buildEmployeeDetails(theme, state)
              : Container(),
          state.query!.type == TimesheetTypeEnum.events
              ? _buildMonthSelector(theme, state)
              : Container(),
          SizedBox(height: Dimens.spacing),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme, TimesheetListState state) {
    return Row(
      children: [
        SizedBox(height: Dimens.spacing),
        Text(
          getString(context, "gdp_timesheet_select"),
          style: LelloTextStyles.body(theme),
        ),
        InkWell(
            onTap: () async {
              final period = await showMonthPicker(
                  context: context,
                  initialDate: state.list.first.monthClosing != null
                      ? state.list.first.monthClosing!
                      : DateTime.now());
              if (period != null) {
                //Backend will handle the right period for the month selected
                state.query!.dobTo = period;
                state.query!.dobFrom = period;
                bloc.beginRefresh();
              }
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(Dimens.spacingSmall, 0, 0, 0),
              child: Row(children: [
                Text(
                    state.list.first.monthClosing != null
                        ? capitalize(
                            dateFormat.format(state.list.first.monthClosing!))
                        : getString(context, "gdp_timesheet_select"),
                    style: LelloTextStyles.bodyBold(theme)),
                Padding(
                  padding: EdgeInsets.all(Dimens.spacing).copyWith(right: 0),
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ]),
            ))
      ],
    );
  }

  Widget _buildEmployeeDetails(ThemeData theme, TimesheetListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimens.spacing),
        Text(
          getString(context, "gdp_timesheet_employee_name"),
          style: LelloTextStyles.bodyBold(theme),
        ),
        Text(
          state.list.first.employee?.name ?? "-",
          style: LelloTextStyles.body(theme),
        ),
        SizedBox(
          height: Dimens.spacingSmall,
        ),
        Text(
          getString(context, "gdp_timesheet_employee_occupation"),
          style: LelloTextStyles.bodyBold(theme),
        ),
        Text(
          state.list.first.employee?.role ?? "-",
          style: LelloTextStyles.body(theme),
        ),
        SizedBox(
          height: Dimens.spacingSmall,
        ),
        Text(
          getString(context, "gdp_timesheet_selected"),
          style: LelloTextStyles.bodyBold(theme),
        ),
        Text(
            state.list.first.monthClosing != null
                ? capitalize(dateFormat.format(state.list.first.monthClosing!))
                : "-",
            style: LelloTextStyles.body(theme)),
      ],
    );
  }

  Widget _buildList(ThemeData theme, TimesheetListState state) {
    var memory;
    final dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br');

    final itemsCount = state.list.length;
    if (itemsCount == 0) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: Center(
          child: Text(
            getString(context, "gdp_timesheet_empty"),
            style: LelloTextStyles.bodyBold(theme),
          ),
        ),
      );
    }
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          if (_programmaticRefresh) {
            _programmaticRefresh = false;
            // A recarga já estava em curso: só acompanha o fim dela.
            if (bloc.state is! TimesheetListLoadingState) return;
          } else {
            bloc.beginRefresh();
          }
          return _refreshCompleter.future;
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              final entity = state.list[index];
              if (memory == dateFormat.format(bloc.state.list[index].date!)) {
                return _selectListTileType(entity, theme, state);
              } else {
                memory = dateFormat.format(bloc.state.list[index].date!);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimens.spacing,
                            bottom: Dimens.spacingSmall,
                            top: Dimens.spacingSmall),
                        child: Text(today
                                    .compareTo(bloc.state.list[index].date!) ==
                                0
                            ? getString(context, "gdp_timesheet_label_today")
                            : memory),
                      ),
                    ),
                    _selectListTileType(entity, theme, state)
                  ],
                );
              }
            },
            controller: controller2,
            separatorBuilder: (context, index) => Container(
                color: LelloTheme.palleteOf(theme).separator(), height: 1),
            itemCount: itemsCount),
      ),
    );
  }

  ListTile _selectListTileType(
      Timesheet entity, ThemeData theme, TimesheetListState state) {
    switch (state.query!.type!) {
      case TimesheetTypeEnum.employee:
        return _buildListTileEmployee(entity, theme, state);
      case TimesheetTypeEnum.events:
        return _buildListTileEvents(entity, theme, state);
      default:
        return _buildListTileDefault(entity, theme, state);
    }
  }

  ListTile _buildListTileDefault(
      Timesheet entity, ThemeData theme, TimesheetListState state) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimens.spacing),
      title:
          Text(entity.employee!.name!, style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(
          capitalize(entity.employee!.role!.toLowerCase()) +
              "\n" +
              (entity.time != null && entity.time!.length > 0
                  ? entity.time!.join("-")
                  : getString(context, "gdp_timesheet_event_time_unmarked")),
          style: LelloTextStyles.subBody(theme)),
      onTap: () {
        Navigator.of(context).pushNamed(SharedApplicationRoute.gdpTimesheetList,
            arguments: TimesheetFilter(
                name: entity.employee!.name,
                type: TimesheetTypeEnum.employee,
                dobFrom: state.query!.dobFrom,
                dobTo: state.query!.dobTo));
      },
      trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
    );
  }

  ListTile _buildListTileEmployee(
      Timesheet entity, ThemeData theme, TimesheetListState state) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimens.spacing),
      title: Text(
          entity.events != null && entity.events!.length > 0
              ? entity.events!.join(" - ")
              : getString(context, "gdp_timesheet_event_empty"),
          style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(
          entity.time != null && entity.time!.length > 0
              ? entity.time!.join("-")
              : getString(context, "gdp_timesheet_event_time_unmarked"),
          style: LelloTextStyles.subBody(theme)),
      trailing: state is TimesheetInsertingState &&
              entity.date == state.selectedDate
          ? CircularProgressIndicator()
          : InkWell(
              onTap: !_allowEdit(entity)
                  ? () => Flushbar(
                        title: getString(
                            context, "gdp_timesheet_flushbar_unavailable"),
                        message: periodValidAllowEdit
                            ? getString(context,
                                "gdp_timesheet_flushbar_unavailable_reason")
                            : getString(context,
                                "gdp_timesheet_flushbar_invalid_period_reason"),
                        isDismissible: true,
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        duration: Duration(seconds: 3),
                      )..show(context)
                  : null,
              child: DropdownButton(
                onChanged: _allowEdit(entity)
                    ? (value) {
                        if (value == "ABONO") {
                          _showDialog(state, entity, value as String);
                        } else {
                          Flushbar(
                            message: getString(context,
                                "gdp_timesheet_flushbar_already_selected"),
                            isDismissible: true,
                            dismissDirection:
                                FlushbarDismissDirection.HORIZONTAL,
                            duration: Duration(seconds: 5),
                          )..show(context);
                        }
                      }
                    : null,
                disabledHint: Text(entity.eventControl?.typeEvent ==
                        getString(context,
                            "gdp_timesheet_event_option_allowance_value")
                    ? getString(
                        context, "gdp_timesheet_event_option_allowance_text")
                    : getString(
                        context, "gdp_timesheet_event_option_discount_text")),
                hint: Text(getString(context, "gdp_timesheet_select")),
                value: entity.eventControl?.typeEvent ==
                        getString(context,
                            "gdp_timesheet_event_option_allowance_value")
                    ? getString(
                        context, "gdp_timesheet_event_option_allowance_value")
                    : getString(
                        context, "gdp_timesheet_event_option_discount_value"),
                items: [
                  DropdownMenuItem(
                    child: Text(getString(
                        context, "gdp_timesheet_event_option_discount_action")),
                    value: getString(
                        context, "gdp_timesheet_event_option_discount_value"),
                  ),
                  DropdownMenuItem(
                    child: Text(getString(context,
                        "gdp_timesheet_event_option_allowance_action")),
                    value: getString(
                        context, "gdp_timesheet_event_option_allowance_value"),
                  )
                ],
              ),
            ),
    );
  }

  void _showDialog(TimesheetListState state, Timesheet entity, String value) {
    final theme = LelloTheme.light;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              getString(context, "gdp_timesheet_signature_alert_warning"),
              style: LelloTextStyles.titleSmall(theme)),
          actionsOverflowDirection: VerticalDirection.down,
          content: Text(getString(context, "gdp_timesheet_event_alert_warning"),
              style: LelloTextStyles.body(theme)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: LelloTheme.palleteOf(theme).secondary(),
              ),
              child: Text(getString(context, "cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: LelloTheme.light.colorScheme.secondary),
              child: Text(getString(context, "yes")),
              onPressed: () {
                bloc.insertEvent(TimesheetEvent(
                    effectiveDate: entity.date,
                    registrationNumber: entity.employee!.id,
                    minutes: 0,
                    typeEvent: value));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _allowEdit(Timesheet entity) {
    //Strings must be hard coded because can't be in english
    if (!periodValidAllowEdit) return false;
    if (entity.eventControl?.typeEvent == "ABONO") return false;
    if (entity.events != null &&
        entity.events!.any((element) =>
            element.toLowerCase().contains("atraso sem justificativa") ||
            element.toLowerCase().contains("falta sem justificativa") ||
            element
                .toLowerCase()
                .contains("saida antecipada sem justificativa"))) return true;
    return false;
  }

  ListTile _buildListTileEvents(
      Timesheet entity, ThemeData theme, TimesheetListState state) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimens.spacing),
      title:
          Text(entity.employee!.name!, style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(
          (entity.time != null && entity.time!.length > 0
                  ? entity.time!.join("-")
                  : getString(context, "gdp_timesheet_event_time_unmarked")) +
              "\n" +
              (entity.events != null && entity.events!.length > 0
                  ? entity.events!.join(" - ")
                  : '-'),
          style: LelloTextStyles.subBody(theme)),
      onTap: () {
        Navigator.of(context).pushNamed(SharedApplicationRoute.gdpTimesheetList,
            arguments: TimesheetFilter(
                name: entity.employee!.name,
                type: TimesheetTypeEnum.employee,
                dobFrom: state.query!.dobFrom,
                dobTo: state.query!.dobTo));
      },
      trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (!(bloc.state is PayslipEmployeesPagingState) &&
        (controller2.offset + delta) >= controller2.position.maxScrollExtent) {
      // bloc.beginLoadNextPage();
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
