import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:shared_features/shared_features.dart';

class VacationEmployeesPageArgs {
  VacationEmployeesBloc vacationEmployeesBloc;
  VacationEmployeesPageArgs(this.vacationEmployeesBloc);
}

class VacationEmployeesPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const VacationEmployeesPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _VacationEmployeesPageState createState() => _VacationEmployeesPageState();
}

class _VacationEmployeesPageState extends State<VacationEmployeesPage> {
  // final VacationEmployeesBloc bloc = ApplicationContainer.instance().resolve();
  late VacationEmployeesBloc bloc;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
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
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, 'gdp_vacation_title')),
        body: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              if (state is VacationEmployeesLoadingState) {
                refreshKey.currentState?.show();
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              if (state is VacationEmployeesLoadingState)
                Center(child: LoadingWidget());
              if ((state as VacationEmployeesState).data.isEmpty &&
                  !(state is VacationEmployeesLoadingState)) {
                return Center(
                  child: Text(
                    getString(
                        context, 'gdp_vacation_employees_no_panding_vacation'),
                    style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                );
              }
              if (state is VacationEmployeesLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearch(theme, state),
                    _chooseEmployeeText(theme),
                    Container(
                        color: LelloTheme.palleteOf(theme).separator(),
                        height: 1),
                    _buildList(theme, state)
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  Widget _buildSearch(ThemeData theme, VacationEmployeesState state) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.0,
        child: Row(children: [
          Expanded(
            child: TextField(
              onChanged: (val) => bloc.beginSearch(val),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  labelStyle: LelloTextStyles.subtitle(theme),
                  fillColor: LelloTheme.palleteOf(theme).customColor(),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.search,
                    color: LelloTheme.palleteOf(theme).grey(),
                    size: 16.0,
                  ),
                  hintText: getString(
                      context, 'gdp_vacation_employees_search_tooltip')),
            ),
          ),
          Visibility(
            visible: state is VacationEmployeesSearchingState,
            child: Center(child: LoadingWidget()),
          )
        ]),
      ),
    );
  }

  Widget _chooseEmployeeText(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Row(children: [
        Text(
          getString(context, 'gdp_vacation_choose_employee'),
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
      ]),
    );
  }

  Widget _buildList(ThemeData theme, VacationEmployeesState state) {
    final itemsCount =
        state.data.length + (state is VacationEmployeesPagingState ? 1 : 0);
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          bloc.beginRefresh();
          return _refreshCompleter.future;
        },
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingXSmall),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 1.0,
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
                    trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          SharedApplicationRoute.gdpVacation,
                          arguments: entity);
                    },
                  );
                },
                controller: controller,
                separatorBuilder: (context, index) => Container(
                    color: LelloTheme.palleteOf(theme).separator(), height: 1),
                itemCount: itemsCount),
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (!(bloc.state is VacationEmployeesPagingState) &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
