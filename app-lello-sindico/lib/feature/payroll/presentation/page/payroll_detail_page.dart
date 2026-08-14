import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/controller/payroll_controller.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayrollDetailPageArgs {
  DateTime? selectedMonth;
  PayrollController payrollController;
  PayrollDetailPageArgs(
      {required this.selectedMonth, required this.payrollController});
}

class PayrollDetailPage extends StatefulWidget {
  const PayrollDetailPage({Key? key}) : super(key: key);

  @override
  PayrollDetailPageState createState() => PayrollDetailPageState();
}

class PayrollDetailPageState extends State<PayrollDetailPage> {
  final monthFormat = DateFormat.yMMMM();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  late DateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    PayrollDetailPageArgs args =
        ModalRoute.of(context)?.settings.arguments as PayrollDetailPageArgs;
    _selectedMonth = args.selectedMonth;

    return WillPopScope(
      onWillPop: () async {
        args.payrollController.getPayrollsList();
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
            theme: theme,
            title: getString(context, "gdp_payroll"),
          ),
          body: FutureBuilder(
              future: args.payrollController.getPayrollDetail(
                period: _selectedMonth ?? DateTime.now(),
              ),
              builder: (context, snapshot) {
                return BlocBuilder<PayrollBloc, PayrollState>(
                    bloc: args.payrollController.payrollBloc,
                    builder: (context, state) {
                      if (state is PayrollDetailLoadingState) {
                        return Column(
                          children: const [
                            Expanded(
                              child: LoadingWidget(),
                            ),
                          ],
                        );
                      }

                      if (state is PayrollDetailLoadedState) {
                        if (state.payroll != null) {
                          return SingleChildScrollView(
                            child: Column(children: [
                              _buildHeader(theme, payroll: state.payroll),
                              _buildContent(theme, payroll: state.payroll),
                            ]),
                          );
                        } else {
                          return Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    getString(context, "payroll_unavailable"),
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      if (state is PayrollsListLoadFailedState) {
                        return Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: ErrorHandlingWidget(
                            reTryFunction: () {
                              args.payrollController.getPayrollDetail(
                                  period: _selectedMonth ?? DateTime.now());
                            },
                            backFunction: () => Navigator.pop(context, true),
                            isProduction: env.isProduction,
                            error: state.error?.error.toString() ?? "",
                            errorCode: state.error?.code.toString() ?? "",
                          ),
                        );
                      }
                      return Container();
                    });
              }),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, {required Payroll? payroll}) {
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Container(
        decoration: ShapeDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                getString(context, "payroll_information"),
                style: LelloTextStyles.subBody(theme),
              ),
              subtitle: Text(
                payroll?.period != null
                    ? monthFormat.format(payroll!.period!)
                    : "-",
                style: LelloTextStyles.bodyBold(theme),
              ),
            ),
            ListTile(
              title: Text(
                getString(context, "payroll_type"),
                style: LelloTextStyles.subBody(theme),
              ),
              subtitle: Text(
                payroll?.type ?? "-",
                style: LelloTextStyles.bodyBold(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, {required Payroll? payroll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimens.spacing),
        ListTile(
          title: Text(
            getString(context, "payroll_summary"),
            style: LelloTextStyles.subtitleBold(theme),
          ),
        ),
        ListTile(
          title: Text(
            getString(context, "payroll_total_value"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          subtitle: Text(
            currencyFormat.format(payroll?.value ?? 0),
            style: LelloTextStyles.subBody(theme),
          ),
        ),
        ListTile(
          title: Text(
            getString(context, "payroll_total_discounts"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          subtitle: Text(
            currencyFormat.format(payroll?.discounts ?? 0),
            style: LelloTextStyles.subBody(theme),
          ),
        ),
        ListTile(
          title: Text(getString(context, "payroll_total_balance"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(
            currencyFormat.format(payroll?.balance ?? 0),
            style: LelloTextStyles.subBody(theme),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Dimens.spacing),
          child: PrimaryButton(
            text: getString(context, "payroll_details"),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ApplicationRoute.payrollEntry, arguments: payroll);
            },
          ),
        )
      ],
    );
  }
}
