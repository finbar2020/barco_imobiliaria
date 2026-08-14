import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/unit/presentation/bloc/units/units_state.dart';
import 'package:lello/feature/unit/presentation/widget/unit_list_item.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../controllers/unit_controller.dart';
import '../widget/unit_filter_drawer.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({Key? key}) : super(key: key);

  @override
  UnitsPageState createState() => UnitsPageState();
}

class UnitsPageState extends State<UnitsPage> {
  final UnitsController controller =
      ApplicationContainer.instance().resolve<UnitsController>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final scaffoldState = GlobalKey<ScaffoldState>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  late ScrollController scrollController;

  Future<void> _scrollListener() async {
    final delta = Dimens.spacingXLarge;
    if ((scrollController.offset + delta) >=
        scrollController.position.maxScrollExtent) {
      await controller.getUnits();
    }
  }

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_scrollListener);
    controller.pipeline();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldState,
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "units_title"),
          actions: [
            IconButton(
              onPressed: () {
                scaffoldState.currentState?.openEndDrawer();
              },
              icon: SvgPicture.asset(
                "assets/ic_filter.svg",
                color: theme.primaryColor,
              ),
            )
          ],
        ),
        endDrawer: SizedBox(
          width: size.width,
          child: const UnitFilterDrawer(),
        ),
        body: RefreshIndicator(
          onRefresh: controller.pipeline,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
                            await controller.getUnits(clearUnits: true);
                          },
                          controller: controller.queryController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.spacing,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Transform.rotate(
                                      angle: pi / 2,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await controller.getUnits(
                                              clearUnits: true);
                                        },
                                        child: const Icon(
                                          Icons.search,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimens.spacing),
                                    GestureDetector(
                                      onTap: () async {
                                        controller.queryController.clear();
                                        await controller.getUnits(
                                            clearUnits: true);
                                      },
                                      child: const Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              hintText:
                                  getString(context, 'units_search_tooltip')),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder(
                  bloc: controller.unitsBloc,
                  builder: (context, state) => FilterBadge(
                    controller: controller,
                  ),
                ),
                BlocBuilder(
                  bloc: controller.unitsBloc,
                  builder: (context, state) {
                    if (state is UnitsEmptyState) {
                      return SizedBox(
                        height: size.height * 0.6,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(Dimens.spacingLarge),
                            child: Text(
                              getString(context, "units_empty_message"),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is UnitsLoadingState) {
                      return SizedBox(
                        height: size.height * 0.6,
                        child: const Center(
                          child: LoadingWidget(),
                        ),
                      );
                    }
                    if (state is UnitsFailureState) {
                      return SizedBox(
                        height: size.height * 0.6,
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: ErrorHandlingWidget(
                            reTryFunction: () {
                              controller.pipeline();
                            },
                            backFunction: () => Navigator.pop(context, true),
                            isProduction: env.isProduction,
                            error: state.error?.error.toString() ?? "",
                            errorCode: state.error?.code.toString() ?? "",
                          ),
                        ),
                      );
                    }
                    if (state is UnitsSuccessState ||
                        state is UnitsNewLoadingState) {
                      final itemsCount = controller.units.length;
                      return DismissKeyboard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    List<int> indexToShowTitle = [0];
                                    if (index + 1 <=
                                        controller.units.length - 1) {
                                      if (controller.units[index].group !=
                                          controller.units[index + 1].group) {
                                        indexToShowTitle.add(index + 1);
                                      }
                                    }

                                    final entity = controller.units[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, top: 16),
                                          child: Visibility(
                                            visible: indexToShowTitle
                                                .contains(index),
                                            child: Text(
                                              '${getString(context, 'units_group')}: ${controller.units.first.group ?? ''}',
                                              style: LelloTextStyles.bodyBold(
                                                  theme),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: entity.condominiumId != null
                                              ? () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          ApplicationRoute
                                                              .unitDetail,
                                                          arguments: entity);
                                                }
                                              : () {},
                                          contentPadding: EdgeInsets.all(
                                              Dimens.spacingMedium),
                                          title: UnitListItem(unit: entity),
                                          trailing: SvgPicture.asset(
                                              "assets/ic_arrow_right.svg"),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      Container(
                                          color: LelloTheme.palleteOf(theme)
                                              .separator(),
                                          height: 1),
                                  itemCount: itemsCount,
                                ),
                                Visibility(
                                  visible: state is UnitsNewLoadingState,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: Dimens.spacing),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class FilterBadge extends StatelessWidget {
  const FilterBadge({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final UnitsController controller;
  @override
  Widget build(BuildContext context) {
    return controller.filters.isNotEmpty
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
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  return FilterItem(
                    title: controller.filters.keys.elementAt(index),
                    content: controller.filters.entries
                        .elementAt(index)
                        .value
                        .keys
                        .first,
                    onTap: () => controller.filters.entries
                        .elementAt(index)
                        .value
                        .values
                        .first(),
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
