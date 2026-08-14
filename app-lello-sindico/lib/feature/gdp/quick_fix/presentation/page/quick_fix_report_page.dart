import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class QuickFixReportPage extends StatefulWidget {
  const QuickFixReportPage({Key? key}) : super(key: key);

  @override
  QuickFixReportPageState createState() => QuickFixReportPageState();
}

class QuickFixReportPageState extends State<QuickFixReportPage> {
  final QuickFixReportBloc bloc = ApplicationContainer.instance().resolve();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  final dateFormat = DateFormat.yMd();
  var loaded = false;

  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, 'gdp_quick_fix_report_title')),
        body: BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is QuickFixReportLoadedState) {
                return SingleChildScrollView(
                    child: _buildContent(theme, state.data!, args!.employee!,
                        state.condominium!));
              }
              if (state is QuickFixReportLoadingState) {
                return const Center(child: LoadingWidget());
              }
              if (state is QuickFixReportLoadFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    reTryFunction: () {
                      //bloc.beginLoad(filter);
                    },
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                    error: state.error.error.toString(),
                    errorCode: state.error.code.toString(),
                    textReturnButton: "back_to_the_previous_page",
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return date != null ? dateFormat.format(date) : '-';
  }

  Widget _buildHeader(
      ThemeData theme, Condominium condominium, EmployeeReportType reportType) {
    String? previewText;
    if (reportType == EmployeeReportType.vacation) {
      previewText = getString(context, 'gdp_quick_fix_report_preview_vacation');
    } else if (reportType == EmployeeReportType.termination) {
      previewText =
          getString(context, 'gdp_quick_fix_report_preview_termination');
    }
    String typeText = "";
    var typeTextSubtitle = "";
    if (reportType == EmployeeReportType.vacation) {
      typeText = getString(context, 'gdp_quick_fix_report_vacation_type');
    } else if (reportType == EmployeeReportType.termination) {
      typeText = getString(context, 'gdp_quick_fix_report_termination_type');
      typeTextSubtitle =
          getString(context, 'gdp_quick_fix_report_termination_type_subtitle');
    }

    return AltSection(
        padding: EdgeInsets.all(Dimens.spacingSmall),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
      Employee employee, Condominium condominium) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(theme, condominium, report.type!),
          _buildEmployeeSection(
              theme, report.employee ?? employee, report.type!),
          Visibility(
              visible: report.items?.isNotEmpty == true,
              child: const Divider()),
          _buildReportSection(theme, report),
          const Divider(),
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
      ], shrinkWrap: true, physics: const NeverScrollableScrollPhysics()),
    );
  }

  Widget _buildReportSection(ThemeData theme, EmployeeReport report) {
    if (report.items?.isNotEmpty == true) {
      return Container(
        child: ListBuilder.build([
          ...report.items!.map((reportItem) => FormDisplayItem(
              title: reportItem.description!,
              text: currencyFormat
                  .format(double.parse(reportItem.value.toString())))),
        ], shrinkWrap: true, physics: const NeverScrollableScrollPhysics()),
      );
    }
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Text(
        getString(context, 'gdp_quick_fix_report_error'),
        style: LelloTextStyles.error(theme),
        textAlign: TextAlign.center,
      ),
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
      ], shrinkWrap: true, physics: const NeverScrollableScrollPhysics()),
    );
  }

  Row _buildFooter(ThemeData theme, EmployeeReportType reportType) {
    String disclaimerText = "";
    if (reportType == EmployeeReportType.vacation) {
      disclaimerText =
          getString(context, 'gdp_quick_fix_report_disclaimer_vacation');
    } else if (reportType == EmployeeReportType.termination) {
      disclaimerText =
          getString(context, 'gdp_quick_fix_report_disclaimer_termination');
    }
    return Row(children: [
      Flexible(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            color: LelloTheme.palleteOf(theme).accent(),
            child: Text(disclaimerText,
                softWrap: true,
                style: LelloTextStyles.body(LelloTheme.dark),
                textAlign: TextAlign.center),
          )
        ]),
      )
    ]);
  }
}
