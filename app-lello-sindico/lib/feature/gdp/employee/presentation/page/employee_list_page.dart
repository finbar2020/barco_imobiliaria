import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:lello/feature/gdp/employee/presentation/widget/employee_filter_widget.dart';
import 'package:lello/feature/gdp/employee/presentation/widget/employee_list_item.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final dateFormat = DateFormat.yMd();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  EmployeeListBloc bloc = ApplicationContainer.instance().resolve();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) {
          if (state is! EmployeeListLoadingState) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer<void>();
          } else {
            _indicatorKey.currentState!.show();
          }
        },
        bloc: bloc,
        builder: (context, state) => Scaffold(
            backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
            key: scaffoldState,
            endDrawer: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _buildFilterDrawer(state as EmployeeListState)),
            appBar: PrimaryAppBar(
              theme: theme,
              title: getString(context, "gdp_team"),
              actions: [
                IconButton(
                  onPressed: () {
                    scaffoldState.currentState!.openEndDrawer();
                  },
                  icon: SvgPicture.asset(
                    "assets/ic_filter.svg",
                    color: theme.primaryColor,
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
        color: const Color(0xFF2D2D2D),
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
                    icon: SvgPicture.asset("assets/ic_close_white.svg"),
                  )),
              EmployeeFilterWidget(
                  entity: state.filter,
                  onApply: (filter) {
                    bloc.beginFilter(filter);
                    Navigator.of(context).pop();
                  },
                  onClose: () {
                    Navigator.of(context).pop();
                  }),
            ]),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, EmployeeListState state) {
    if (state is EmployeeListLoadFailedState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: ErrorHandlingWidget(
          reTryFunction: () {
            bloc.beginRefresh();
          },
          backFunction: () => Navigator.pop(context, true),
          isProduction: env.isProduction,
          error: state.error.error.toString(),
          errorCode: state.error.code.toString(),
          textReturnButton: "back_to_the_previous_page",
        ),
      );
    }
    return RefreshIndicator(
      key: _indicatorKey,
      onRefresh: () async {
        bloc.beginRefresh();
        return _refreshCompleter.future;
      },
      child: Visibility(
        visible: state is EmployeeListLoadedState && state.data.isEmpty,
        replacement: ListView.separated(
            controller: controller,
            itemBuilder: (context, index) {
              if (index == state.data.length) {
                return _buildPagingIndicator();
              }
              final item = state.data[index];
              return EmployeeListItem(
                employee: item,
                onPressed: (it) => Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpEmployee, arguments: it),
              );
            },
            itemCount: (state.data.length) +
                (state is EmployeeListPagingState ? 1 : 0),
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: theme.dividerColor,)),
        child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Center(
                child: Text(
              "Nenhum registro encontrado",
              style: LelloTextStyles.subtitle(theme),
              textAlign: TextAlign.center,
            ))),
      ),
    );
  }

  Widget _buildPagingIndicator() {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: const Center(
        child: LoadingWidget(),
      ),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (bloc.state is! EmployeeListPagingState &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
