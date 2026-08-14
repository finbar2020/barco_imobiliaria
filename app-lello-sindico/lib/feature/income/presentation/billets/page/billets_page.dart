import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/income/domain/entity/billet_status_enum.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_state.dart';
import 'package:lello/feature/income/presentation/billets/controller/billets_controller.dart';
import 'package:lello/feature/income/presentation/billets/detail/controller/billets_details_controller.dart';

class BilletsPage extends StatefulWidget {
  const BilletsPage({Key? key}) : super(key: key);

  @override
  BilletsPageState createState() => BilletsPageState();
}

class BilletsPageState extends State<BilletsPage> {
  final BilletsController _billetsController =
      ApplicationContainer.instance().resolve<BilletsController>();
  final BilletsDetailsController billetsDetailsController =
      ApplicationContainer.instance().resolve<BilletsDetailsController>();
  final TextEditingController _textEditingController = TextEditingController();
  late ScrollController scrollController;
  late DateTime? periodSelected = DateTime.now();
  Timer? _searchTimer;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Environment env = ApplicationContainer.instance().resolve<Environment>();
  Timer? _debounceTimer;

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    final isScrollAtEnd = scrollController.offset + delta >=
        scrollController.position.maxScrollExtent;

    if (isScrollAtEnd) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 200), () {
        _billetsController.getUnitsPaginated(
          ignoreWords: getString(
            context,
            "income_billet_item_title_prefix",
          ),
        );
      });
    }
  }

  @override
  void initState() {
    _billetsController.getBilletsPeriodsAvailability();
    scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchTimer?.cancel();
    _billetsController.dispose();
    super.dispose();
  }

  void _startSearchTimer() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 800), () {
      _billetsController.query = _textEditingController.text;
      _billetsController.getUnits(
        ignoreWords: getString(context, "income_billet_item_title_prefix"),
      );
    });
  }

  void _onClearButtonPressed() {
    if (_textEditingController.text.isNotEmpty) {
      _textEditingController.clear();
      _billetsController.query = "";
      _billetsController.getUnits(
        ignoreWords: getString(context, "income_billet_item_title_prefix"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    periodSelected = _billetsController.selectedPeriod;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "income_monthly_billets")),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: BlocBuilder(
            bloc: _billetsController.billetsBloc,
            builder: ((context, state) {
              return DismissKeyboard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Builder(
                      builder: (context) {
                        if (state is BilletsLoadingState) {
                          return const Expanded(
                            child: Center(
                              child: LoadingWidget(),
                            ),
                          );
                        }
                        if (state is BilletsLoadFailedState) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(Dimens.spacingMedium),
                              child: ErrorHandlingWidget(
                                error: state.error.error.toString(),
                                errorCode: state.error.code.toString(),
                                reTryFunction: () {
                                  _billetsController
                                      .getBilletsPeriodsAvailability();
                                },
                                backFunction: () =>
                                    Navigator.pop(context, true),
                                isProduction: env.isProduction,
                              ),
                            ),
                          );
                        }
                        if (state is BilletsLoadedState ||
                            state is UnitsLoadingState) {
                          return Expanded(
                            child: RefreshIndicator(
                              key: _refreshKey,
                              onRefresh: () async {
                                _billetsController.resetBillets();
                                await _billetsController.getUnits(
                                  ignoreWords: getString(
                                    context,
                                    "income_billet_item_title_prefix",
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.spacingMedium,
                                        Dimens.spacingMedium,
                                        Dimens.spacingMedium,
                                        0),
                                    child: Row(children: [
                                      Expanded(
                                        child: IgnorePointer(
                                          ignoring: _billetsController
                                              .billetsPeriodsAvailability
                                              .isEmpty,
                                          child: TextField(
                                            controller: _textEditingController,
                                            onChanged: (text) {
                                              _startSearchTimer();
                                            },
                                            keyboardType: TextInputType.text,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.search,
                                            onEditingComplete: () {
                                              _startSearchTimer();
                                            },
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              suffixIcon: IconButton(
                                                icon: _textEditingController
                                                        .text.isNotEmpty
                                                    ? const Icon(Icons.clear)
                                                    : const Icon(Icons.search),
                                                onPressed:
                                                    _onClearButtonPressed,
                                              ),
                                              hintText: getString(context,
                                                  'units_search_tooltip'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: state is BilletsSearchingState,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: Dimens.spacing),
                                          child:
                                              const CircularProgressIndicator(),
                                        ),
                                      )
                                    ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.spacingMedium,
                                        0,
                                        Dimens.spacingMedium,
                                        0),
                                    child: IgnorePointer(
                                      ignoring: _billetsController
                                          .billetsPeriodsAvailability.isEmpty,
                                      child: Opacity(
                                        opacity: _billetsController
                                                .billetsPeriodsAvailability
                                                .isEmpty
                                            ? 0.5
                                            : 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                getString(context,
                                                    "income_due_period"),
                                                style: LelloTextStyles.bodyBold(
                                                  theme,
                                                ),
                                              ),
                                            ),
                                            DropdownButton<DateTime>(
                                              hint: Text(
                                                getString(context,
                                                    "billet_select_date"),
                                                style:
                                                    LelloTextStyles.body(theme),
                                                overflow: TextOverflow.fade,
                                              ),
                                              value: _billetsController
                                                  .selectedPeriod,
                                              onChanged: (DateTime? newValue) {
                                                setState(() {
                                                  periodSelected = newValue;
                                                  _billetsController
                                                          .selectedPeriod =
                                                      periodSelected;
                                                  _billetsController.getUnits(
                                                    ignoreWords: getString(
                                                      context,
                                                      "income_billet_item_title_prefix",
                                                    ),
                                                  );
                                                });
                                              },
                                              items: _billetsController
                                                  .billetsPeriodsAvailability
                                                  .map<
                                                          DropdownMenuItem<
                                                              DateTime>>(
                                                      (DateTime value) {
                                                return DropdownMenuItem<
                                                    DateTime>(
                                                  value: value,
                                                  child: Text(
                                                      DateFormat('MM/yyyy')
                                                          .format(value)),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimens.spacingSmall),
                                    child: Opacity(
                                      opacity: _billetsController
                                              .billetsPeriodsAvailability
                                              .isEmpty
                                          ? 0.5
                                          : 1.0,
                                      child: Wrap(
                                        children: [
                                          IgnorePointer(
                                            ignoring: _billetsController
                                                .billetsPeriodsAvailability
                                                .isEmpty,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: _billetsController
                                                          .status ==
                                                      BilletStatus.paid,
                                                  activeColor:
                                                      theme.primaryColor,
                                                  onChanged:
                                                      (bool? value) async {
                                                    _billetsController
                                                        .lastUnitId = null;

                                                    _billetsController
                                                        .setBilletState(
                                                      billetStatus:
                                                          BilletStatus.paid,
                                                    );
                                                    await _billetsController
                                                        .getUnits(
                                                      ignoreWords: getString(
                                                        context,
                                                        "income_billet_item_title_prefix",
                                                      ),
                                                    );

                                                    setState(
                                                      () {},
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  getString(context,
                                                      "billet_only_paid"),
                                                  style: LelloTextStyles.body(
                                                      theme),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IgnorePointer(
                                            ignoring: _billetsController
                                                .billetsPeriodsAvailability
                                                .isEmpty,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: _billetsController
                                                          .status ==
                                                      BilletStatus.open,
                                                  activeColor:
                                                      theme.primaryColor,
                                                  onChanged:
                                                      (bool? value) async {
                                                    _billetsController
                                                        .setBilletState(
                                                      billetStatus:
                                                          BilletStatus.open,
                                                    );
                                                    _billetsController.getUnits(
                                                      ignoreWords: getString(
                                                        context,
                                                        "income_billet_item_title_prefix",
                                                      ),
                                                    );

                                                    setState(() {});
                                                  },
                                                ),
                                                Text(
                                                  getString(context,
                                                      "billet_only_open"),
                                                  style: LelloTextStyles.body(
                                                      theme),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      color: LelloTheme.palleteOf(theme)
                                          .separator(),
                                      height: 1),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.spacingMedium,
                                      Dimens.spacingMedium,
                                      0,
                                      Dimens.spacing,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Opacity(
                                        opacity: _billetsController
                                                .billetsPeriodsAvailability
                                                .isEmpty
                                            ? 0.5
                                            : 1.0,
                                        child: Text(
                                          getString(context,
                                              "income_billet_list_title"),
                                          style: LelloTextStyles.title(theme),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_billetsController.units.isNotEmpty &&
                                      _billetsController
                                          .billetsPeriodsAvailability
                                          .isNotEmpty)
                                    Expanded(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item =
                                              _billetsController.units[index];
                                          return ListTile(
                                            onTap: () {
                                              billetsDetailsController
                                                  .selectedUnit = item;
                                              billetsDetailsController
                                                      .selectedDateTime =
                                                  _billetsController
                                                          .selectedPeriod ??
                                                      DateTime.now();
                                              Navigator.of(context).pushNamed(
                                                ApplicationRoute.billetDetail,
                                              );
                                            },
                                            contentPadding: EdgeInsets.only(
                                                left: Dimens.spacingLarge,
                                                right: Dimens.spacingLarge,
                                                top: Dimens.spacingSmall,
                                                bottom: Dimens.spacingSmall),
                                            leading: SvgPicture.asset(
                                                "assets/ic_unit.svg"),
                                            title: Text(
                                                "${getString(context, "income_billet_item_title_prefix")}: ${item.title}",
                                                style: LelloTextStyles.bodyBold(
                                                    theme)),
                                            subtitle: Text(item.group ?? "",
                                                style: LelloTextStyles.subBody(
                                                    theme)),
                                            trailing: SvgPicture.asset(
                                                "assets/ic_arrow_right.svg",
                                                width: 6),
                                          );
                                        },
                                        controller: scrollController,
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount:
                                            _billetsController.units.length,
                                      ),
                                    ),
                                  if (_billetsController.units.isEmpty &&
                                      state! is BilletsLoadedState)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          if (_billetsController.status ==
                                                  BilletStatus.open &&
                                              _billetsController
                                                  .units.isEmpty &&
                                              _billetsController
                                                  .query.isEmpty &&
                                              _billetsController
                                                  .billetsPeriodsAvailability
                                                  .isNotEmpty)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: Dimens.spacingLarge,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.spacingMedium),
                                                  child: Center(
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            "${getString(context, "billet_no_open_message")}: ",
                                                        style: LelloTextStyles
                                                                .subtitle(theme)
                                                            ?.copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .hubText()),
                                                      ),
                                                      TextSpan(
                                                        text: DateFormat.yMMMM()
                                                            .format(_billetsController
                                                                    .selectedPeriod ??
                                                                DateTime.now()),
                                                        style: LelloTextStyles
                                                                .subtitleBold(
                                                                    theme)
                                                            ?.copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .hubText()),
                                                      ),
                                                    ])),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (_billetsController.status ==
                                                  BilletStatus.paid &&
                                              _billetsController
                                                  .units.isEmpty &&
                                              _billetsController
                                                  .units.isEmpty &&
                                              _billetsController
                                                  .query.isEmpty &&
                                              _billetsController
                                                  .billetsPeriodsAvailability
                                                  .isNotEmpty)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: Dimens.spacingLarge,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.spacingMedium),
                                                  child: Center(
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            "${getString(context, "billet_no_paid_message")}: ",
                                                        style: LelloTextStyles
                                                                .subtitle(theme)
                                                            ?.copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .hubText()),
                                                      ),
                                                      TextSpan(
                                                        text: DateFormat.yMMMM()
                                                            .format(_billetsController
                                                                    .selectedPeriod ??
                                                                DateTime.now()),
                                                        style: LelloTextStyles
                                                                .subtitleBold(
                                                                    theme)
                                                            ?.copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .hubText()),
                                                      ),
                                                    ])),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (_billetsController
                                                  .units.isEmpty &&
                                              _billetsController
                                                  .query.isNotEmpty &&
                                              _billetsController
                                                  .billetsPeriodsAvailability
                                                  .isNotEmpty)
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .spacingMedium),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              Dimens.spacing,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/ic_no_search_result.svg",
                                                          height: 70,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              Dimens.spacing,
                                                        ),
                                                        Text(
                                                          getString(context,
                                                              "billet_search_not_found_message"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: LelloTextStyles
                                                              .subtitle(theme),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (_billetsController.status ==
                                                  null &&
                                              _billetsController
                                                  .units.isEmpty &&
                                              _billetsController
                                                  .billetsPeriodsAvailability
                                                  .isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimens.spacingMedium),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: Dimens.spacingLarge,
                                                  ),
                                                  Text(
                                                    getString(context,
                                                        "billet_units_empty"),
                                                    textAlign: TextAlign.center,
                                                    style: LelloTextStyles
                                                        .subtitle(theme),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (_billetsController
                                              .billetsPeriodsAvailability
                                              .isEmpty)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimens.spacingMedium),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.error_outline,
                                                        color:
                                                            theme.disabledColor,
                                                      ),
                                                      SizedBox(
                                                          width: Dimens
                                                              .spacingSmall),
                                                      Flexible(
                                                        child: Text(
                                                          getString(context,
                                                              'billet_not_avaliable'),
                                                          style: LelloTextStyles
                                                                  .subtitle(
                                                                      theme)!
                                                              .merge(
                                                            TextStyle(
                                                                color: theme
                                                                    .disabledColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        Dimens.spacingMedium),
                                                    child: Text(
                                                      getString(context,
                                                          "billet_caption_empty_subtitle"),
                                                      style:
                                                          LelloTextStyles.body(
                                                              theme),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimens.spacingLarge),
                                                  TertiaryButton(
                                                      text: getString(
                                                          context, "back"),
                                                      style: TextStyle(
                                                          color: theme
                                                              .primaryColor),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  if (state is BilletsPagingState)
                                    Padding(
                                      padding: EdgeInsets.all(Dimens.spacing),
                                      child: const Center(
                                        child: LoadingWidget(),
                                      ),
                                    ),
                                  if (state is UnitsLoadingState)
                                    Padding(
                                      padding: EdgeInsets.all(Dimens.spacing),
                                      child: Center(
                                        child: LoadingWidget(
                                            message: getString(context,
                                                "billet_page_loading_message")),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
