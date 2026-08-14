import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayslipMonthPage extends StatefulWidget {
  const PayslipMonthPage({Key? key}) : super(key: key);

  @override
  PayslipMonthPageState createState() => PayslipMonthPageState();
}

class PayslipMonthPageState extends State<PayslipMonthPage> {
  final monthFormat = DateFormat.yMMMM();

  DateTime? selectedMonth;
  String? type;
  String? error;

  final PayslipEmployeesBloc bloc = ApplicationContainer.instance().resolve();
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
              title: getString(context, "gdp_payslip_title")),
          body: BlocConsumer<PayslipEmployeesBloc, PayslipEmployeesState>(
              listener: (context, state) {
                if (state is PayslipEmployeesLoadedState) {
                  // setState(() {
                  // 	if (state.data.isNotEmpty) selectedMonth = state.data.last?.;
                  // });
                }
              },
              bloc: bloc,
              builder: (context, state) {
                if (state is PayslipEmployeesLoadingState) {
                  return const Center(child: LoadingWidget());
                }
                if (state is PayslipEmployeesLoadFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                      reTryFunction: () {
                        bloc.beginRefresh();
                      },
                      backFunction: () => Navigator.pop(context, true),
                      isProduction: env.isProduction,
                      error: "",
                      errorCode: "",
                      textReturnButton: "back_to_the_previous_page",
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        getString(context, "gdp_payslip_selection_month"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildMonthSelector(theme, state),
                      SizedBox(height: Dimens.spacingLarge),
                      PrimaryButton(
                          text: getString(context, "next"),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                ApplicationRoute.gdpPayslipEmployees,
                                arguments: selectedMonth);
                          }),
                    ],
                  ),
                );
              })),
    );
  }

  Widget _buildMonthSelector(ThemeData theme, PayslipEmployeesState state) {
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2900);
    selectedMonth ??= DateTime.now();
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(
            top: 20, right: Dimens.spacing, bottom: 20, left: Dimens.spacing),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(width: 1, color: Color(0XFF909090)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(selectedMonth != null
                ? monthFormat.format(selectedMonth!)
                : monthFormat.format(DateTime.now())),
          ),
          SvgPicture.asset("assets/ic_arrow_drop_down.svg")
        ],
      ),
      onPressed: () async {
        final month = await showMonthPicker(
            context: context,
            initialDate: DateTime.now(),
            lastDate: lastDate,
            firstDate: firstDate);
        setState(() {
          if (month != null) selectedMonth = month;
        });
      },
    );
  }
}
