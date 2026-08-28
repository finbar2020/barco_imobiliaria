import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_filter_widget.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_list_item.dart';
import 'package:shared_features/shared_features.dart';

class EmployeeListPageArgs {
  EmployeeListBloc employeeListBloc;
  EmployeeListPageArgs(this.employeeListBloc);
}

class EmployeeListPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const EmployeeListPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final dateFormat = DateFormat.yMd();
  late EmployeeListBloc bloc;

  // EmployeeListBloc bloc = ApplicationContainer.instance().resolve();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  /// Marca a recarga disparada pelo próprio listener (`_indicatorKey.show()`),
  /// para que o `onRefresh` do RefreshIndicator não peça outra recarga.
  bool _programmaticRefresh = false;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    _refreshCompleter = Completer<void>();
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) {
          if (!(state is EmployeeListLoadingState)) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer<void>();
          } else if (_indicatorKey.currentState != null) {
            _programmaticRefresh = true;
            _indicatorKey.currentState!.show();
          }
        },
        bloc: bloc,
        builder: (context, state) => Scaffold(
            backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
            key: scaffoldState,
            endDrawer: Container(
                width: MediaQuery.of(context).size.width,
                child: _buildFilterDrawer(state as EmployeeListState)),
            appBar: PrimaryAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: LelloTheme.palleteOf(LelloTheme.light).background(),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              theme: theme,
              title: getString(context, "gdp_team"),
              actions: [
                IconButton(
                  onPressed: () {
                    scaffoldState.currentState!.openEndDrawer();
                  },
                  icon: Icon(
                    Icons.search,
                    color: LelloTheme.palleteOf(LelloTheme.light).background(),
                  ),
                ),
              ],
            ),
            body: _buildBody(theme, state)),
      ),
    );
  }

  Widget _buildFilterDrawer(EmployeeListState state) {
    return Drawer(
      child: Container(
        color: LelloTheme.palleteOf(LelloTheme.dark).background(),
        child: ListView(
            padding: EdgeInsets.only(top: Dimens.spacingMedium)
                .copyWith(top: Dimens.spacingXLarge),
            children: [
              ListTile(
                  title: Text(getString(context, "payment_filter_title"),
                      style: LelloTextStyles.title(LelloTheme.dark)),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.search,
                      color:
                          LelloTheme.palleteOf(LelloTheme.light).background(),
                    ),
                  )),
              EmployeeFilterWidget(
                entity: state.filter,
                onApply: (filter) {
                  bloc.beginFilter(filter);
                  Navigator.of(context).pop();
                },
                onClose: () {
                  Navigator.of(context).pop();
                },
                appContainer: widget.appContainer,
              ),
            ]),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, EmployeeListState state) {
    if (state is EmployeeListLoadFailedState)
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ocorreu um erro, tente novamente mais tarde',
                style: LelloTextStyles.body(theme),
              ),
              Text(
                'Se o problema persistir entre em contato com o suporte',
                style: LelloTextStyles.body(theme),
              )
            ],
          ),
        ),
      );
    return RefreshIndicator(
      key: _indicatorKey,
      onRefresh: () async {
        if (_programmaticRefresh) {
          _programmaticRefresh = false;
          // A recarga já estava em curso: só acompanha o fim dela.
          if (bloc.state is! EmployeeListLoadingState) return;
        } else {
          bloc.beginRefresh();
        }
        return _refreshCompleter.future;
      },
      child: Visibility(
        visible: state is EmployeeListLoadedState && state.data.length == 0,
        child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Center(
                child: Text(
              "Nenhum registro encontrado",
              style: LelloTextStyles.subtitle(theme),
              textAlign: TextAlign.center,
            ))),
        replacement: ListView.separated(
            controller: controller,
            itemBuilder: (context, index) {
              if (index == state.data.length) {
                return _buildPagingIndicator();
              }
              final item = state.data[index];
              return EmployeeListItem(
                employee: item,
                onPressed: (it) => Navigator.of(context).pushNamed(
                    SharedApplicationRoute.gdpEmployee,
                    arguments: it),
              );
            },
            itemCount: (state.data.length) +
                (state is EmployeeListPagingState ? 1 : 0),
            separatorBuilder: (BuildContext context, int index) => Divider()),
      ),
    );
  }

  Widget _buildPagingIndicator() {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (!(bloc.state is EmployeeListPagingState) &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
