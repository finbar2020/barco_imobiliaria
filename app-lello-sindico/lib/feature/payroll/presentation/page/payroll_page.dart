import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/payroll/presentation/bloc/payroll/controller/payroll_controller.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:lello/feature/payroll/presentation/page/payroll_detail_page.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({Key? key}) : super(key: key);

  @override
  PayrollPageState createState() => PayrollPageState();
}

class PayrollPageState extends State<PayrollPage> {
  late final PayrollController _payrollController;
  late final Environment _environment;
  final monthFormat = DateFormat.yMMMM();

  DateTime? selectedMonth;
  DateTime? initialMounth;
  DateTime lastDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  String? type;
  String? error;
  List<String>? types;
  var loaded = false;

  @override
  void initState() {
    super.initState();
    _payrollController =
        ApplicationContainer.instance().resolve<PayrollController>();
    _environment = ApplicationContainer.instance().resolve<Environment>();
  }

  @override
  void dispose() {
    _payrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Builder(builder: (context) {
      return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme, title: getString(context, "gdp_payroll")),
          body: FutureBuilder(
              future:
                  loaded == false ? _payrollController.getPayrollsList() : null,
              builder: (context, snapshot) {
                return BlocBuilder<PayrollBloc, PayrollState>(
                    bloc: _payrollController.payrollBloc,
                    builder: (context, state) {
                      if (state is PayrollsListLoadingState) {
                        return const Column(
                          children: [
                            Expanded(
                              child: LoadingWidget(),
                            ),
                          ],
                        );
                      }
                      if (state is PayrollsListLoadFailedState) {
                        return Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: ErrorHandlingWidget(
                            reTryFunction: () {
                              _payrollController.getPayrollsList();
                            },
                            backFunction: () => Navigator.pop(context, true),
                            isProduction: _environment.isProduction,
                            error: state.error?.error.toString() ?? "",
                            errorCode: state.error?.code.toString() ?? "",
                          ),
                        );
                      }
                      if (state is PayrollsListLoadedState) {
                        if (state.payrolls.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(Dimens.spacingMedium),
                            child: Center(
                              child: Text(
                                getString(context, "payroll_empty"),
                                style: LelloTextStyles.body(theme),
                              ),
                            ),
                          );
                        }
                        initialMounth = state.payrolls.last.period;
                        if (!loaded) {
                          selectedMonth = initialMounth;
                          loaded = true;
                        }
                        lastDate = state.payrolls.last.period ?? DateTime.now();
                        firstDate =
                            state.payrolls.first.period ?? DateTime.now();
                        return Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(getString(context, "payroll_month"),
                                  style: LelloTextStyles.bodyBold(theme)),
                              SizedBox(height: Dimens.spacing),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.only(
                                      top: 20,
                                      right: Dimens.spacing,
                                      bottom: 20,
                                      left: Dimens.spacing),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  side: const BorderSide(
                                      width: 1, color: Color(0XFF909090)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(selectedMonth != null
                                          ? monthFormat.format(selectedMonth!)
                                          : ""),
                                    ),
                                    SvgPicture.asset(
                                        "assets/ic_arrow_drop_down.svg")
                                  ],
                                ),
                                onPressed: () async {
                                  final month = await showMonthPicker(
                                      context: context,
                                      initialDate: selectedMonth!,
                                      lastDate: lastDate,
                                      firstDate: firstDate);
                                  setState(() {
                                    if (month != null) selectedMonth = month;
                                  });
                                },
                              ),
                              SizedBox(height: Dimens.spacingLarge),
                              PrimaryButton(
                                  text: getString(context, "find"),
                                  onPressed: () {
                                    if (selectedMonth != null) {
                                      Navigator.of(context).pushNamed(
                                        ApplicationRoute.payrollDetail,
                                        arguments: PayrollDetailPageArgs(
                                            selectedMonth: selectedMonth,
                                            payrollController:
                                                _payrollController),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        );
                      }
                      return Container();
                    });
              }),
        ),
      );
    });
  }
}
