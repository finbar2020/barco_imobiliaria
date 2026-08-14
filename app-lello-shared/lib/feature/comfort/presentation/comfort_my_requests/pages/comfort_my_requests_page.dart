import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_request_item.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/shared_features.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ComfortMyRequestsPageArgs {
  ComfortPartnersController comfortPartnersController;
  ComfortMyRequestsPageArgs(this.comfortPartnersController);
}

class ComfortMyRequestsPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ComfortMyRequestsPage({Key? key, required this.appContainer})
      : super(key: key);

  @override
  _ComfortMyRequestsPageState createState() => _ComfortMyRequestsPageState();
}

class _ComfortMyRequestsPageState extends State<ComfortMyRequestsPage>
    with WidgetsBindingObserver {
  late ComfortMyRequestsController comfortMyRequestsController;
  late ComfortPartnersController comfortPartnersController;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    widget.appContainer.resetLazySingleton<ComfortMyRequestsController>();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    comfortPartnersController = widget.appContainer.resolve();
    comfortMyRequestsController = widget.appContainer.resolve();
    comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStart();
    comfortMyRequestsController.analyticsComodidadesSolicitacoesAcessar();
    comfortMyRequestsController.getSubcategories();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (comfortMyRequestsController.isBottomSheetOpen) {
          comfortMyRequestsController
              .comfortMyRequestsBottomSheetAnalyticsTimerStart();
        } else {
          comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStart();
        }
        break;
      case AppLifecycleState.paused:
        if (comfortMyRequestsController.isBottomSheetOpen) {
          comfortMyRequestsController
              .comfortMyRequestsBottomSheetAnalyticsTimerStop();
        } else {
          comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStop();
        }
        break;
      case AppLifecycleState.detached:
        if (comfortMyRequestsController.isBottomSheetOpen) {
          comfortMyRequestsController
              .comfortMyRequestsBottomSheetAnalyticsTimerStop();
        } else {
          comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStop();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments =
        ModalRoute.of(context)?.settings.arguments as ComfortMyRequestsPageArgs;
    comfortPartnersController = arguments.comfortPartnersController;

    return WillPopScope(
        onWillPop: () async {
          _onPop();
          return true;
        },
        child: Theme(
          data: theme,
          child: Scaffold(
            key: scaffoldState,
            appBar: CustomAppBar(title: "comfort_my_requests", actions: [
              IconButton(
                onPressed: () async {
                  scaffoldState.currentState!.openEndDrawer();
                },
                icon: SvgPicture.asset(
                  "assets/ic_filter.svg",
                  color: LelloTheme.palleteOf(theme).customColor(),
                ),
              ),
            ]),
            endDrawer: GestureDetector(
              onHorizontalDragUpdate: (dragDetails) => null,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Drawer(
                  backgroundColor: theme.primaryColor,
                  child: ComfortRequestsFilterWidget(
                    filter: comfortMyRequestsController.filter ??
                        ComfortRequestsFilter(
                            status: ComfortFilterRequestStatus.all,
                            subcategories: ComfortType.all),
                    subcategories: comfortMyRequestsController.subcategories,
                    onSearch: (filter) {
                      setState(() {
                        comfortMyRequestsController.filter = filter;
                      });
                      comfortMyRequestsController.getMyRequests(page: 1);
                    },
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.spacing, Dimens.spacing, Dimens.spacing, 0),
              child: Column(
                children: [
                  BlocBuilder(
                      bloc: comfortMyRequestsController.comfortMyRequestsBloc,
                      builder: (context, state) => FilterBadge(
                            controller: comfortMyRequestsController,
                          )),
                  Expanded(
                    child: BlocConsumer<ComfortMyRequestsBloc,
                        ComfortMyRequestsState>(
                      bloc: comfortMyRequestsController.comfortMyRequestsBloc,
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        if (comfortMyRequestsController.comfortMyRequestsBloc
                            .state is ErrorComfortMyRequestsState)
                          return Padding(
                            padding: EdgeInsets.all(Dimens.spacingLarge),
                            child: ErrorHandlingWidget(
                              errorCode: (comfortMyRequestsController
                                      .comfortMyRequestsBloc
                                      .state as ErrorComfortMyRequestsState)
                                  .errorCode,
                              error: (comfortMyRequestsController
                                      .comfortMyRequestsBloc
                                      .state as ErrorComfortMyRequestsState)
                                  .errorDescription,
                              reTryFunction: () =>
                                  comfortMyRequestsController.getMyRequests(),
                              backFunction: () {
                                _onPop();
                                Navigator.pop(context, true);
                              },
                              isProduction: true,
                            ),
                          );
                        return PagingListener<int, ComfortCompletedRequest>(
                          controller:
                              comfortMyRequestsController.pagingController,
                          builder: (context, state, fetchNextPage) =>
                              PagedListView<int,
                                  ComfortCompletedRequest>.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: Dimens.spacing,
                            ),
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate<
                                ComfortCompletedRequest>(
                              itemBuilder: (context, item, index) =>
                                  ComfortRequestItem(
                                comfortMyRequestsController:
                                    comfortMyRequestsController,
                                appContainer: widget.appContainer,
                                item: item,
                                index: index,
                              ),
                              firstPageErrorIndicatorBuilder: (_) =>
                                  Container(),
                              newPageErrorIndicatorBuilder: (_) => InkWell(
                                onTap: fetchNextPage,
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(Dimens.spacingMedium),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getString(context,
                                                  "error_handling_widget_subtitle"),
                                              maxLines: 2,
                                              style:
                                                  LelloTextStyles.body(theme),
                                              overflow: TextOverflow.visible,
                                            ),
                                            Text(
                                              getString(context,
                                                  "error_handling_widget_button_reTry"),
                                              style: LelloTextStyles.bodyBold(
                                                  theme),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (_) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      comfortMyRequestsController
                                              .isFilterActive()
                                          ? getString(context,
                                              "comfort_request_filter_result_empty")
                                          : getString(context,
                                              "comfort_my_requests_empty"),
                                      style: LelloTextStyles.subtitle(theme)
                                          ?.copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .text()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onPop() {
    comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStop();
    comfortPartnersController
        .getAllPartners(ComfortPageOriginEnum.myRequestsPage);
  }
}

class FilterBadge extends StatelessWidget {
  const FilterBadge({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ComfortMyRequestsController controller;

  @override
  Widget build(BuildContext context) {
    final filters = controller.generateFilters(context);

    return filters.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.spacing,
              vertical: Dimens.spacingSmall,
            ),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: Dimens.spacingSmall,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return FilterItem(
                    title: filters.keys.elementAt(index),
                    content: filters.entries.elementAt(index).value.keys.first,
                    onTap: () =>
                        filters.entries.elementAt(index).value.values.first(),
                  );
                },
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
