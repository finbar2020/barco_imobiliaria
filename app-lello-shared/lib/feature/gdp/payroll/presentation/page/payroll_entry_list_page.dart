import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/widget/payroll_entry_list_item.dart';
import 'package:shared_features/shared_features.dart';

class PayrollEntryListPageArgs {
  PayrollEntryBloc payrollEntryBloc;
  PayrollEntryListPageArgs(this.payrollEntryBloc);
}

class PayrollEntryListPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const PayrollEntryListPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _PayrollEntryListPageState createState() => _PayrollEntryListPageState();
}

class _PayrollEntryListPageState extends State<PayrollEntryListPage> {
  // final PayrollEntryBloc bloc = ApplicationContainer.instance().resolve();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  var loaded = false;
  late PayrollEntryBloc bloc;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    if (!loaded) {
      Payroll payroll = ModalRoute.of(context)!.settings.arguments as Payroll;
      bloc.beginLoad(payroll);
      loaded = true;
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar:
            PrimaryAppBar(theme: theme, title: getString(context, "details")),
        body: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return BlocBuilder<PayrollEntryBloc, PayrollEntryState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is PayrollEntryLoadingState)
          return Center(child: CircularProgressIndicator());
        if (state is PayrollEntryLoadFailedState)
          return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(getString(context, "payroll_error"),
                  style: LelloTextStyles.error(theme),
                  textAlign: TextAlign.center));
        return ListView.separated(
            itemBuilder: (context, index) {
              if (index == 0)
                return _buildHeader(theme, state);
              else
                return PayrollEntryListItem(entry: state.data[index - 1]);
            },
            separatorBuilder: (context, index) =>
                index > 0 ? Divider() : Container(),
            itemCount: (state.data.length) + 1);
      },
    );
  }

  Widget _buildHeader(ThemeData theme, PayrollEntryState state) {
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Column(
        children: [
          Container(
            decoration: ShapeDecoration(
                color: LelloTheme.palleteOf(theme).separator(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(getString(context, "payroll_total_value"),
                      style: LelloTextStyles.bodyBold(theme)),
                  subtitle: Text(
                      currencyFormat.format(state.payroll?.value ?? 0),
                      style: LelloTextStyles.subBody(theme)),
                ),
                ListTile(
                  title: Text(getString(context, "payroll_total_discounts"),
                      style: LelloTextStyles.bodyBold(theme)),
                  subtitle: Text(
                      currencyFormat.format(state.payroll?.discounts ?? 0),
                      style: LelloTextStyles.subBody(theme)),
                ),
                ListTile(
                  title: Text(getString(context, "payroll_total_balance"),
                      style: LelloTextStyles.bodyBold(theme)),
                  subtitle: Text(
                      currencyFormat.format(state.payroll?.balance ?? 0),
                      style: LelloTextStyles.subBody(theme)),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.spacing)
        ],
      ),
    );
  }
}
