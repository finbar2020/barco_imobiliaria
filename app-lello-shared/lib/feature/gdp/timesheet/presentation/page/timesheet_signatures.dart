import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/core/modal/month_picker.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_state.dart';
import 'package:shared_features/shared_features.dart';

class EimesheetSignaturesPageArgs {
  TimesheetSignaturesBloc timesheetSignaturesBloc;
  EimesheetSignaturesPageArgs(this.timesheetSignaturesBloc);
}

class TimesheetSignaturesPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const TimesheetSignaturesPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _TimesheetSignaturesPageState createState() =>
      _TimesheetSignaturesPageState();
}

class _TimesheetSignaturesPageState extends State<TimesheetSignaturesPage> {
  // final TimesheetSignaturesBloc bloc =
  //     ApplicationContainer.instance().resolve();
  late TimesheetSignaturesBloc bloc;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;
  late ScrollController controller2;

  DateTime firstDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDayMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  final dateFormat = DateFormat(DateFormat.MONTH, 'pt_Br');

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
    TimesheetSignaturesState state = bloc.state;
    state.query = ModalRoute.of(context)!.settings.arguments as TimesheetFilter;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "gdp_timesheet_appBar")),
        body: BlocProvider.value(
          value: bloc,
          child:
              BlocConsumer<TimesheetSignaturesBloc, TimesheetSignaturesState>(
            listener: (context, state) {
              if (state is TimesheetSignedState) {
                Navigator.popAndPushNamed(
                    context, SharedApplicationRoute.gdpTimesheetSignSuccess);
                // pushNamedAndPopUntil(
                //     context,
                //     SharedApplicationRoute.gdpTimesheetSignSuccess,
                //     ModalRoute.withName(
                //         SharedApplicationRoute.gdpTimesheetMenu));
              }
              if (state is TimesheetSignaturesLoadingState) {
                refreshKey.currentState?.show();
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              return state is TimesheetSignaturesLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, state),
                        _buildList(theme, state),
                        _buildButton(theme, state),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, TimesheetSignaturesState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(Dimens.spacingSmall),
        bottomRight: Radius.circular(Dimens.spacingSmall),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: Dimens.spacing),
          Text(getString(context, "gdp_timesheet_signature_title"),
              style: LelloTextStyles.subtitleBold(theme)),
          SizedBox(height: Dimens.spacing),
          _buildMonthSelector(theme, state),
          SizedBox(height: Dimens.spacing),
          Visibility(
              visible: state.listSign.length > 0,
              child: _buildNumSelected(theme, state.listSign.length)),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme, TimesheetSignaturesState state) {
    return Row(
      children: [
        Text(
          getString(context, "gdp_timesheet_month_selected"),
          style: LelloTextStyles.body(theme),
        ),
        InkWell(
            onTap: () async {
              final period = await showMonthPicker(
                  context: context,
                  initialDate: state.query?.dobTo != null
                      ? state.query!.dobTo!
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
                    state.query!.dobTo != null
                        ? capitalize(dateFormat.format(state.query!.dobTo!))
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

  Widget _buildNumSelected(ThemeData theme, int number) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              getString(context, "gdp_timesheet_signature_number_selected"),
              style: LelloTextStyles.body(theme),
            ),
            Text(
              number.toString(),
              style: LelloTextStyles.bodyBold(theme),
            ),
          ],
        ),
        SizedBox(height: Dimens.spacing),
      ],
    );
  }

  Widget _buildList(ThemeData theme, TimesheetSignaturesState state) {
    final itemsCount = state.signatures.length;
    if (state is TimesheetSignaturesLoadFailedState) {
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
        key: refreshKey,
        onRefresh: () async {
          bloc.beginRefresh();
          return _refreshCompleter.future;
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              final entity = state.signatures[index];
              return _buildListTile(entity, theme, state);
            },
            controller: controller2,
            separatorBuilder: (context, index) => Container(
                color: LelloTheme.palleteOf(theme).separator(), height: 1),
            itemCount: itemsCount),
      ),
    );
  }

  CheckboxListTile _buildListTile(TimesheetSignature entity, ThemeData theme,
      TimesheetSignaturesState state) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) {
        setState(() {
          if (value!) {
            state.listSign.add(entity);
          } else {
            state.listSign.remove(entity);
          }
        });
      },
      value: state.listSign.any((x) => x.id == entity.id),
      contentPadding: EdgeInsets.all(Dimens.spacing),
      title: Text(entity.employee?.name ?? "-",
          style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(capitalize(entity.employee?.role?.toLowerCase() ?? "-"),
          style: LelloTextStyles.subBody(theme)),
    );
  }

  Widget _buildButton(ThemeData theme, TimesheetSignaturesState state) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          state is TimesheetSignFailedState
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimens.spacing,
                      horizontal: Dimens.spacingLarge),
                  child: Text(getString(context, "gdp_timesheet_error"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.error(theme)),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimens.spacingXLarge,
              0,
              Dimens.spacingXLarge,
              Dimens.spacingLarge,
            ),
            child: state is TimesheetSigningState
                ? Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    onPressed: state.listSign.length > 0
                        ? () {
                            _showDialog(state);
                          }
                        : () {},
                    text: getString(context, "gdp_timesheet_signature_button"),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDialog(TimesheetSignaturesState state) {
    final theme = LelloTheme.light;
    final pallete = LelloTheme.palleteOf(theme);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              getString(context, "gdp_timesheet_signature_alert_warning"),
              style: LelloTextStyles.titleSmall(theme)),
          actionsOverflowDirection: VerticalDirection.down,
          content: Container(
            child: SingleChildScrollView(
              child: RichText(
                text: new TextSpan(
                  style: LelloTextStyles.subtitleBold(theme),
                  children: <TextSpan>[
                    TextSpan(
                        text: getString(
                            context, "gdp_timesheet_signature_alert_confirm"),
                        style: LelloTextStyles.body(theme)!
                            .copyWith(color: pallete.hubText())),
                    TextSpan(
                        text: state.listSign.length.toString() +
                            getString(context,
                                "gdp_timesheet_signature_alert_mirror"),
                        style: LelloTextStyles.bodyBold(theme)!
                            .copyWith(color: pallete.hubText())),
                    TextSpan(
                        text: getString(
                            context, "gdp_timesheet_signature_alert_period"),
                        style: LelloTextStyles.body(theme)!
                            .copyWith(color: pallete.hubText())),
                    TextSpan(
                        text: dateFormat.format(state.query!.dobTo!) +
                            "/" +
                            state.query!.dobTo!.year.toString() +
                            "?",
                        style: LelloTextStyles.bodyBold(theme)!
                            .copyWith(color: pallete.hubText())),
                  ],
                ),
              ),
            ),
          ),
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
                foregroundColor: LelloTheme.light.colorScheme.secondary,
              ),
              child: Text(getString(context, "confirm")),
              onPressed: () {
                bloc.sign();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
