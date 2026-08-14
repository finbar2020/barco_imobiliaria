import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/controller/payroll_entry_controller.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';
import 'package:lello/feature/payroll/presentation/widget/payroll_entry_list_item.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayrollEntryListPage extends StatefulWidget {
  const PayrollEntryListPage({Key? key}) : super(key: key);

  @override
  PayrollEntryListPageState createState() => PayrollEntryListPageState();
}

class PayrollEntryListPageState extends State<PayrollEntryListPage> {
  final PayrollEntryController payrollEntryController =
      ApplicationContainer.instance().resolve<PayrollEntryController>();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  var loaded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!loaded) {
      Payroll payroll = ModalRoute.of(context)!.settings.arguments as Payroll;
      payrollEntryController.mapLoadEntry(payroll: payroll);
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
      bloc: payrollEntryController.payrollEntryBloc,
      builder: (context, state) {
        if (state is PayrollEntryLoadingState) {
          return const Center(child: LoadingWidget());
        }
        if (state is PayrollEntryLoadFailedState) {
          return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(getString(context, "payroll_error"),
                  style: LelloTextStyles.error(theme),
                  textAlign: TextAlign.center));
        }

        if (state is PayrollEntryLoadedState) {
          return ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    color: LelloTheme.palleteOf(theme).background(),
                    child: Column(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                            color: LelloTheme.palleteOf(theme).separator(),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Text(
                                    getString(context, "payroll_total_value"),
                                    style: LelloTextStyles.bodyBold(theme)),
                                subtitle: Text(
                                    currencyFormat.format(
                                        state.payrollEntry.first.value ?? 0),
                                    style: LelloTextStyles.subBody(theme)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.spacing)
                      ],
                    ),
                  );
                } else {
                  return PayrollEntryListItem(
                      entry: state.payrollEntry[index - 1]);
                }
              },
              separatorBuilder: (context, index) =>
                  index > 0 ? const Divider() : Container(),
              itemCount: (state.payrollEntry.length) + 1);
        }

        return Container();
      },
    );
  }
}
