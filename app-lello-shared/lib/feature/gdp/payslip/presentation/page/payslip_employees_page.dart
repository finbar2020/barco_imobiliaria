import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/shared_features.dart';

class PayslipEmployeesPageArgs {
  PayslipEmployeesBloc payslipEmployeesBloc;
  PayslipEmployeesPageArgs(this.payslipEmployeesBloc);
}

class PayslipEmployeesPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const PayslipEmployeesPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _PayslipEmployeesPageState createState() => _PayslipEmployeesPageState();
}

class _PayslipEmployeesPageState extends State<PayslipEmployeesPage> {
  // final PayslipEmployeesBloc bloc = ApplicationContainer.instance().resolve();
  late PayslipEmployeesBloc bloc;
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  /// Marca a recarga disparada pelo próprio listener (`refreshKey.show()`),
  /// para que o `onRefresh` do RefreshIndicator não peça outra recarga.
  bool _programmaticRefresh = false;
  late Completer<void> _refreshCompleter;
  late ScrollController controller;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    _refreshCompleter = new Completer();
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    bloc.state.selectedMonth =
        ModalRoute.of(context)!.settings.arguments as DateTime;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, 'gdp_payslip_title')),
        body: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              if (state is PayslipEmployeesLoadingState) {
                // Durante o carregamento o builder mostra só o indicador, ou
                // seja, o RefreshIndicator pode nem estar na árvore.
                if (refreshKey.currentState != null) {
                  _programmaticRefresh = true;
                  refreshKey.currentState!.show();
                }
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              if (state is PayslipEmployeesLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              return (state as PayslipEmployeesState).data.isEmpty
                  ? Center(
                      child: Text(
                          getString(context, "gdp_payslip_error_no_employee")),
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
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.search,
                  color: LelloTheme.palleteOf(theme).grey(),
                  size: 16.0,
                ),
                hintText: getString(context, 'gdp_payslip_search_tooltip')),
          ),
        ),
        Visibility(
          visible: state is PayslipEmployeesSearchingState,
          child: Padding(
              padding: EdgeInsets.only(left: Dimens.spacing),
              child: CircularProgressIndicator()),
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
          if (_programmaticRefresh) {
            _programmaticRefresh = false;
            // A recarga já estava em curso: só acompanha o fim dela.
            if (bloc.state is! PayslipEmployeesLoadingState) return;
          } else {
            bloc.beginRefresh();
          }
          return _refreshCompleter.future;
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == state.data.length) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Center(
                    child: CircularProgressIndicator(),
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
                      SharedApplicationRoute.gdpPayslipSelection,
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
    if (!(bloc.state is PayslipEmployeesPagingState) &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
