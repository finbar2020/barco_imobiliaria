import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:shared_features/shared_features.dart';

class QuickFixPageArgs {
  QuickFixBloc quickFixBloc;
  QuickFixPageArgs(this.quickFixBloc);
}

class QuickFixPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const QuickFixPage({Key? key, required this.appContainer}) : super(key: key);
  @override
  _QuickFixPageState createState() => _QuickFixPageState();
}

class _QuickFixPageState extends State<QuickFixPage> {
  final EmployeeReportFilter entity = EmployeeReportFilter();
  late QuickFixBloc bloc;
  // final QuickFixBloc bloc = ApplicationContainer.instance().resolve();

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Theme(
      data: theme,
      child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme, title: getString(context, 'gdp_quick_fix_title')),
          body: BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                if (state is QuickFixLoadedState ||
                    state is QuickFixLoadingState)
                  return _buildBody(theme, state as QuickFixState);
                if (state is QuickFixLoadFailedState)
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Text(FailureMessage.get(context, state.error) ?? "",
                        style: LelloTextStyles.error(theme),
                        textAlign: TextAlign.center),
                  );
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
          subtitle: Container(
            width: double.infinity,
            child: DropdownButtonFormField(
              // `isExpanded` faz o item ocupar a largura do campo; antes cada
              // item tinha largura fixa maior que o campo e estourava.
              isExpanded: true,
              hint: Text(getString(context, 'gdp_quick_fix_select'),
                  style: LelloTextStyles.body(theme)),
              items: disabled
                  ? null
                  : state.data
                      .map((e) => DropdownMenuItem(
                          child: Text(
                            e.name!,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: e))
                      .toList(),
              onChanged: (value) {
                entity.employee = value as Employee;
              },
              decoration: InputDecoration(
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
                        child: Text(_reportTypeToText(e) ?? ""), value: e))
                    .toList(),
            onChanged: (value) {
              entity.reportType = value as EmployeeReportType;
            },
            decoration: InputDecoration(
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
                  SharedApplicationRoute.gdpQuickFixReport,
                  arguments: entity);
            }, // TODO TRIGGER SAVE
          ),
        ),
      ],
    );
  }
}
