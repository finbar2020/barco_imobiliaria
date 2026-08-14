import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';

class QuickFixPage extends StatefulWidget {
  const QuickFixPage({super.key});

  @override
  _QuickFixPageState createState() => _QuickFixPageState();
}

class _QuickFixPageState extends State<QuickFixPage> {
  final EmployeeReportFilter entity = EmployeeReportFilter();
  final QuickFixBloc bloc = ApplicationContainer.instance().resolve();

  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
          appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              theme: theme,
              title: getString(context, 'gdp_quick_fix_title')),
          body: BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                if (state is QuickFixLoadedState ||
                    state is QuickFixLoadingState) {
                  return _buildBody(theme, state as QuickFixState);
                }
                if (state is QuickFixLoadFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                      reTryFunction: () {
                        bloc.beginLoad();
                      },
                      backFunction: () => Navigator.pop(context, true),
                      isProduction: env.isProduction,
                      error: state.error?.error.toString() ?? "",
                      errorCode: state.error?.code.toString() ?? "",
                      textReturnButton: "back_to_the_previous_page",
                    ),
                  );
                }
                return Container();
              })),
    );
  }

  String? _reportTypeToText(EmployeeReportType reportType) {
    switch (reportType) {
      case EmployeeReportType.vacation:
        return getString(context, 'gdp_quick_fix_report_type_vacation');
      case EmployeeReportType.termination:
        return getString(context, 'gdp_quick_fix_report_type_termination');
      default:
        return null;
    }
  }

  Widget _buildBody(ThemeData theme, QuickFixState state) {
    final disabled = state is QuickFixLoadingState;

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.spacingLarge, horizontal: Dimens.spacing),
          child: Text(getString(context, 'gdp_quick_fix_description'),
              style: LelloTextStyles.body(theme)),
        ),
        ListTile(
          title: Padding(
              padding: EdgeInsets.only(bottom: Dimens.spacing),
              child: Text(getString(context, 'gdp_quick_fix_employee'),
                  style: LelloTextStyles.bodyBold(theme))),
          subtitle: SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField(
              hint: Text(getString(context, 'gdp_quick_fix_select'),
                  style: LelloTextStyles.body(theme)),
              items: disabled
                  ? null
                  : state.data
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(
                              e.name!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),
              onChanged: (value) {
                entity.employee = value as Employee;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        ListTile(
          title: Padding(
              padding:
                  EdgeInsets.only(top: Dimens.spacing, bottom: Dimens.spacing),
              child: Text(getString(context, 'gdp_quick_fix_preview'),
                  style: LelloTextStyles.bodyBold(theme))),
          subtitle: DropdownButtonFormField(
            hint: Text(getString(context, 'gdp_quick_fix_select'),
                style: LelloTextStyles.body(theme)),
            items: disabled
                ? null
                : EmployeeReportType.values
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(_reportTypeToText(e) ?? "")))
                    .toList(),
            onChanged: (value) {
              entity.reportType = value as EmployeeReportType;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Dimens.spacing),
          child: PrimaryButton(
            text: getString(context, 'gdp_quick_fix_generate_report'),
            onPressed: () {
              Navigator.of(context).pushNamed(
                  ApplicationRoute.gdpQuickFixReport,
                  arguments: entity);
            }, // TODO TRIGGER SAVE
          ),
        ),
      ],
    );
  }
}
