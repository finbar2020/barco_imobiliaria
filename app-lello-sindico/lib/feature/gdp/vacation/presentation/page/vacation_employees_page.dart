import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';

class VacationEmployeesPage extends StatefulWidget {
  const VacationEmployeesPage({Key? key}) : super(key: key);

  @override
  VacationEmployeesPageState createState() => VacationEmployeesPageState();
}

class VacationEmployeesPageState extends State<VacationEmployeesPage> {
  final VacationEmployeesBloc bloc = ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;
  Timer? _debounce;

  @override
  void initState() {
    _refreshCompleter = Completer();
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, 'gdp_vacation_title')),
        body: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              if (state is VacationEmployeesLoadingState && state.data.isEmpty) {
                refreshKey.currentState?.show();
              } else {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            builder: (context, state) {
              if (state is VacationEmployeesLoadingState && state.data.isEmpty) {
                return const Center(child: LoadingWidget());
              } else if (state is VacationEmployeesLoadFailedState) {
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
              } else if (state is VacationEmployeesState) {
                final isEmpty = state is VacationEmployeesLoadedState && state.data.isEmpty;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearch(theme, state),
                    if (isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            getString(
                              context,
                              'gdp_vacation_employees_no_panding_vacation',
                            ),
                            style: LelloTextStyles.subtitle(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text(),
                            ),
                          ),
                        ),
                      )
                    else ...[
                      _chooseEmployeeText(theme),
                      Container(
                        color: LelloTheme.palleteOf(theme).separator(),
                        height: 1,
                      ),
                      _buildList(theme, state),
                    ],
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
        child: TextField(
          onChanged: (val) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              bloc.beginSearch(val);
            });
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              labelStyle: LelloTextStyles.subtitle(theme),
              fillColor: LelloTheme.palleteOf(theme).customColor(),
              border: const OutlineInputBorder(),
              suffixIcon: SvgPicture.asset('assets/ic_search.svg',
                  height: 16, fit: BoxFit.scaleDown),
              hintText: getString(
                  context, 'gdp_vacation_employees_search_tooltip')),
        ),
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
    final isSearching = state is VacationEmployeesSearchingState;
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
            child: isSearching && state.data.isEmpty
                ? const Center(child: LoadingWidget())
                : ListView.separated(
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
                        trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ApplicationRoute.gdpVacation,
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
    if (bloc.state is! VacationEmployeesPagingState &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
