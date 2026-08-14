import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/core/modal/month_picker.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:shared_features/shared_features.dart';

class PayrollPageArgs {
  PayrollBloc payrollBloc;
  PayrollPageArgs(this.payrollBloc);
}

class PayrollPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const PayrollPage({Key? key, required this.appContainer}) : super(key: key);
  @override
  _PayrollPageState createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  final monthFormat = DateFormat.yMMMM();

  DateTime? selectedMonth;
  String? type;
  String? error;
  late PayrollBloc bloc;
  // final PayrollBloc bloc = ApplicationContainer.instance().resolve();
  List<String>? types;

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
              theme: theme, title: getString(context, "gdp_payroll")),
          body: BlocConsumer<PayrollBloc, PayrollState>(
              listener: (context, state) {
                if (state is PayrollLoadedState) _showDetails(state);
                if (state is PayrollListLoadedState) {
                  setState(() {
                    if (state.data.isNotEmpty)
                      selectedMonth = state.data.last.period;
                  });
                }
              },
              bloc: bloc,
              builder: (context, state) {
                if (state is PayrollLoadingState)
                  return Center(child: CircularProgressIndicator());
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: state is PayrollLoadFailedState,
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Text(getString(context, "payroll_load_failed"),
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.error(theme)),
                        ),
                      ),
                      Text(getString(context, "payroll_month"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      _buildMonthSelector(theme, state),
                      SizedBox(height: Dimens.spacingLarge),
                      PrimaryButton(
                          text: getString(context, "search"),
                          onPressed: () {
                            bloc.beginLoad(selectedMonth!);
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

  Widget _buildMonthSelector(ThemeData theme, PayrollState state) {
    DateTime lastDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    if (state.data.isNotEmpty) {
      lastDate = state.data.last.period ?? DateTime.now();
      firstDate = state.data.first.period ?? DateTime.now();
    }
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
                : ""),
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
            initialDate: selectedMonth!,
            lastDate: lastDate,
            firstDate: firstDate);
        setState(() {
          if (month != null) selectedMonth = month;
        });
      },
    );
  }

  void _showDetails(PayrollState state) {
    final payroll = state.detail;
    if (payroll == null) {
      setState(() {
        error = getString(context, "payroll_unavailable");
      });
    } else {
      Navigator.of(context).pushNamed(SharedApplicationRoute.gdppayrollDetail,
          arguments: payroll);
    }
  }
}
