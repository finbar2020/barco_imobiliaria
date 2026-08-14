import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:shared_features/shared_features.dart';

class QuickFixReportPageArgs {
  QuickFixReportBloc employeeListBloc;
  QuickFixReportPageArgs(this.employeeListBloc);
}

class QuickFixReportPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const QuickFixReportPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _QuickFixReportPageState createState() => _QuickFixReportPageState();
}

class _QuickFixReportPageState extends State<QuickFixReportPage> {
  late QuickFixReportBloc bloc;
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");
  final dateFormat = DateFormat.yMd();
  var loaded = false;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    final EmployeeReportFilter? args =
        ModalRoute.of(context)!.settings.arguments as EmployeeReportFilter?;
    if (!loaded && args != null) {
      bloc.beginLoad(args);
      loaded = true; 
    }

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
                theme: theme,
                title: getString(context, 'gdp_quick_fix_report_title')),
            body: BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is QuickFixReportLoadedState)
                    return SingleChildScrollView(
                        child: _buildContent(theme, state.data!,
                            args!.employee!, state.condominium!));
                  if (state is QuickFixReportLoadingState)
                    return Center(child: CircularProgressIndicator());
                  if (state is QuickFixReportLoadFailedState)
                    return Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: Text(
                          FailureMessage.get(context, state.error) ?? "",
                          style: LelloTextStyles.error(theme),
                          textAlign: TextAlign.center),
                    );
                  return Container();
                })));
  }

  String _formatDate(DateTime? date) {
    return date != null ? dateFormat.format(date) : '-';
  }

  Widget _buildHeader(ThemeData theme, CondominiumGDP condominium,
      EmployeeReportType reportType) {
    var previewText;
    if (reportType == EmployeeReportType.vacation)
      previewText = getString(context, 'gdp_quick_fix_report_preview_vacation');
    else if (reportType == EmployeeReportType.termination)
      previewText =
          getString(context, 'gdp_quick_fix_report_preview_termination');
    var typeText;
    var typeTextSubtitle = "";
    if (reportType == EmployeeReportType.vacation)
      typeText = getString(context, 'gdp_quick_fix_report_vacation_type');
    else if (reportType == EmployeeReportType.termination) {
      typeText = getString(context, 'gdp_quick_fix_report_termination_type');
      typeTextSubtitle =
          getString(context, 'gdp_quick_fix_report_termination_type_subtitle');
    }

    return AltSection(
        padding: EdgeInsets.all(Dimens.spacingSmall),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            previewText == null
                ? Container()
                : ListTile(
                    title:
                        Text(previewText, style: LelloTextStyles.body(theme)),
                  ),
            ListTile(
                title: Text(
                    getString(
                        context, 'gdp_quick_fix_report_condominium_reference'),
                    style: LelloTextStyles.bodyBold(theme)),
                subtitle: Text(condominium.name!,
                    style: LelloTextStyles.body(theme))),
            ListTile(
                title: Text(typeText, style: LelloTextStyles.bodyBold(theme)),
                subtitle:
                    Text(typeTextSubtitle, style: LelloTextStyles.body(theme))),
          ],
        ));
  }

  Widget _buildContent(ThemeData theme, EmployeeReport report,
      Employee employee, CondominiumGDP condominium) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      _buildHeader(theme, condominium, report.type!),
      _buildEmployeeSection(theme, report.employee ?? employee, report.type!),
      Visibility(visible: report.items?.isNotEmpty == true, child: Divider()),
      _buildReportSection(theme, report),
      Divider(),
      _buildStabilitySection(theme, report),
      _buildFooter(theme, report.type!)
    ]);
  }

  Widget _buildEmployeeSection(
      ThemeData theme, Employee employee, EmployeeReportType reportType) {
    return Container(
      child: ListBuilder.build([
        FormDisplayItem(
            title: getString(context, 'gdp_quick_fix_report_employee'),
            text: employee.name!),
        FormDisplayItem(
            title: getString(context, 'gdp_quick_fix_report_employee_role'),
            text: employee.role!),
        RowItem(children: [
          Flexible(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingMedium, vertical: 0),
                  title: Text(
                      getString(
                          context, 'gdp_quick_fix_report_employee_admission'),
                      style: LelloTextStyles.bodyBold(Theme.of(context))),
                  subtitle: Text(_formatDate(employee.hiringDate),
                      style: LelloTextStyles.body(Theme.of(context))),
                )
              ],
            ),
          ),
          (() {
            if (reportType == EmployeeReportType.termination) {
              return Flexible(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimens.spacingMedium, vertical: 0),
                      title: Text(
                          getString(context,
                              'gdp_quick_fix_report_employee_termination'),
                          style: LelloTextStyles.bodyBold(Theme.of(context))),
                      subtitle: Text(_formatDate(DateTime.now()),
                          style: LelloTextStyles.body(Theme.of(context))),
                    )
                  ],
                ),
              );
            }
            return Container();
          }()),
          Flexible(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingMedium, vertical: 0),
                  title: Text(
                      getString(
                          context, 'gdp_quick_fix_report_employee_salary'),
                      style: LelloTextStyles.bodyBold(Theme.of(context))),
                  subtitle: Text(currencyFormat.format(employee.salary ?? 0),
                      style: LelloTextStyles.body(Theme.of(context))),
                )
              ],
            ),
          )
        ]),
      ], shrinkWrap: true, physics: NeverScrollableScrollPhysics()),
    );
  }

  Widget _buildReportSection(ThemeData theme, EmployeeReport report) {
    if (report.items?.length == 0) {
      return Container(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Text(
            getString(context, 'gdp_quick_fix_report_error'),
            style: LelloTextStyles.error(theme),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Container(
      child: ListBuilder.build([
        ...report.items!.map((reportItem) => FormDisplayItem(
            title: reportItem.description!,
            text: currencyFormat
                .format(double.parse(reportItem.value.toString())))),
      ], shrinkWrap: true, physics: NeverScrollableScrollPhysics()),
    );
  }

  Widget _buildStabilitySection(ThemeData theme, EmployeeReport report) {
    if (report.type == EmployeeReportType.vacation) return Container();
    return Container(
      child: ListBuilder.build([
        SubtitleItem(
            text: getString(
                context, 'gdp_quick_fix_report_stability_section_title')),
        FormDisplayItem(
            title: getString(context, 'gdp_quick_fix_report_stability_name'),
            text: report.stabilityDescription ?? '-'),
        FormDisplayItem(
            title:
                getString(context, 'gdp_quick_fix_report_stability_start_date'),
            text: _formatDate(report.stabilityStart)),
        FormDisplayItem(
            title:
                getString(context, 'gdp_quick_fix_report_stability_end_date'),
            text: _formatDate(report.stabilityEnd)),
      ], shrinkWrap: true, physics: NeverScrollableScrollPhysics()),
    );
  }

  Row _buildFooter(ThemeData theme, EmployeeReportType reportType) {
    var disclaimerText;
    if (reportType == EmployeeReportType.vacation)
      disclaimerText =
          getString(context, 'gdp_quick_fix_report_disclaimer_vacation');
    else if (reportType == EmployeeReportType.termination)
      disclaimerText =
          getString(context, 'gdp_quick_fix_report_disclaimer_termination');
    return Row(children: [
      Flexible(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Text(disclaimerText,
                softWrap: true,
                style: LelloTextStyles.body(LelloTheme.dark),
                textAlign: TextAlign.center),
            color: LelloTheme.palleteOf(theme).accent(),
          )
        ]),
      )
    ]);
  }
}
