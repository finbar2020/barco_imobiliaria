import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayslipEmployeesPage extends StatefulWidget {
  const PayslipEmployeesPage({Key? key}) : super(key: key);

  @override
  PayslipEmployeesPageState createState() => PayslipEmployeesPageState();
}

class PayslipEmployeesPageState extends State<PayslipEmployeesPage> {
  final PayslipEmployeesBloc bloc = ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;
  bool _monthSet = false;

  @override
  void initState() {
    _refreshCompleter = Completer();
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_monthSet) {
      final month = ModalRoute.of(context)!.settings.arguments as DateTime;
      bloc.setSelectedMonth(month);
      _monthSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, 'gdp_payslip_title')),
        body: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              if (state is PayslipEmployeesLoadingState) {
                refreshKey.currentState?.show();
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              if (state is PayslipEmployeesLoadingState) {
                return const Center(
                  child: LoadingWidget(),
                );
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

              return (state as PayslipEmployeesState).data.isEmpty
                  ? Center(
                      child: Text(
                        getString(context, "gdp_payslip_error_no_employee"),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSearch(theme, state),
                        Container(
                            color: LelloTheme.palleteOf(theme).separator(),
                            height: 1),
                        _buildList(theme, state)
                      ],
                    );
            }),
      ),
    );
  }

  Widget _buildSearch(ThemeData theme, PayslipEmployeesState state) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Row(children: [
        Expanded(
          child: TextField(
            onChanged: (val) => bloc.beginSearch(val),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: SvgPicture.asset('assets/ic_search.svg',
                    height: 16, fit: BoxFit.scaleDown),
                hintText: getString(context, 'gdp_payslip_search_tooltip')),
          ),
        ),
        Visibility(
          visible: state is PayslipEmployeesSearchingState,
          child: Padding(
            padding: EdgeInsets.only(left: Dimens.spacing),
            child: const CircularProgressIndicator(),
          ),
        )
      ]),
    );
  }

  Widget _buildList(ThemeData theme, PayslipEmployeesState state) {
    final itemsCount =
        state.data.length + (state is PayslipEmployeesPagingState ? 1 : 0);
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          bloc.beginRefresh();
          return _refreshCompleter.future;
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == state.data.length) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                );
              }
              final entity = state.data[index];
              return ListTile(
                contentPadding: EdgeInsets.all(Dimens.spacingMedium),
                title: Text(entity.name ?? "",
                    style: LelloTextStyles.bodyBold(theme)),
                subtitle: Text(entity.role ?? '',
                    style: LelloTextStyles.subBody(theme)),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ApplicationRoute.gdpPayslipSelection,
                      arguments: {
                        'entity': entity,
                        'selectedMonth': state.selectedMonth
                      });
                },
                trailing:
                    SvgPicture.asset("assets/ic_arrow_right.svg", width: 6),
              );
            },
            controller: controller,
            separatorBuilder: (context, index) => Container(
                color: LelloTheme.palleteOf(theme).separator(), height: 1),
            itemCount: itemsCount),
      ),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (bloc.state is! PayslipEmployeesPagingState &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
