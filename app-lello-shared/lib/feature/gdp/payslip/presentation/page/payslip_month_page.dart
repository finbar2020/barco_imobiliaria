import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/core/modal/month_picker.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/shared_features.dart';

class PayslipMonthPageArgs {
  PayslipEmployeesBloc payslipEmployeesBloc;
  PayslipMonthPageArgs(this.payslipEmployeesBloc);
}

class PayslipMonthPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const PayslipMonthPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _PayslipMonthPageState createState() => _PayslipMonthPageState();
}

class _PayslipMonthPageState extends State<PayslipMonthPage> {
  final monthFormat = DateFormat.yMMMM();

  DateTime? selectedMonth;
  String? type;
  String? error;
  late PayslipEmployeesBloc bloc;

  // final PayslipEmployeesBloc bloc = ApplicationContainer.instance().resolve();

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
              theme: theme, title: getString(context, "gdp_payslip_title")),
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
                if (state is PayslipEmployeesLoadingState)
                  return Center(child: CircularProgressIndicator());
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: state is PayslipEmployeesLoadFailedState,
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Text("Falha no carregamento",
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.error(theme)),
                        ),
                      ),
                      Text(getString(context, "gdp_payslip_selection_month"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      _buildMonthSelector(theme, state),
                      SizedBox(height: Dimens.spacingLarge),
                      PrimaryButton(
                          text: getString(context, "next"),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                SharedApplicationRoute.gdpPayslipEmployees,
                                arguments: selectedMonth);
                          }),
                      Visibility(
                        visible: error?.isNotEmpty == true,
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Text(error ?? "",
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.error(theme)),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Widget _buildMonthSelector(ThemeData theme, PayslipEmployeesState state) {
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2900);
    if (selectedMonth == null) selectedMonth = DateTime.now();
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(
            top: 20, right: Dimens.spacing, bottom: 20, left: Dimens.spacing),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(width: 1, color: Color(0XFF909090)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(selectedMonth != null
                ? monthFormat.format(selectedMonth!)
                : monthFormat.format(DateTime.now())),
          ),
          Icon(
            Icons.keyboard_arrow_down_sharp,
            color: LelloTheme.palleteOf(theme).grey(),
          ),
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
