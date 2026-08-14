import 'dart:developer';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_state.dart';
import 'package:lello/feature/payment/presentation/pendency/page/details/pendency_details_page.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/condominium_balance_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/info_banner_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/no_access_to_this_feature_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/payment_list_filter_widget.dart';
import 'package:lello/feature/payment/presentation/widget/payment_list_item.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class PaymentPendencyListPage extends StatefulWidget {
  const PaymentPendencyListPage({super.key});

  @override
  State<PaymentPendencyListPage> createState() =>
      _PaymentPendencyListPageState();
}

class _PaymentPendencyListPageState extends State<PaymentPendencyListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();
  bool infoBannerVisible = true;
  bool selectAll = false;
  bool checkboxesVisible = false;
  Set<int> selectedItems = Set<int>();
  CondominiumBalance? balance;

  @override
  void dispose() {
    controller.clearFilters(isPendency: true);
    super.dispose();
  }

  @override
  void initState() {
    controller.getInstallmentsInApproval();
    loadCondominiumBalance();
    super.initState();
  }

  loadCondominiumBalance() async {
    final balance = await controller.loadCondominiumBalance();
    setState(() {
      this.balance = balance;
    });
  }

  /// Function to toggle the select all checkbox and update selected items
  /// [totalItems] is the total number of items in the list.
  void toggleSelectAll(int totalItems) {
    setState(() {
      selectAll = !selectAll;
      if (selectAll) {
        selectedItems = Set.from(List.generate(totalItems, (index) => index));
      } else {
        selectedItems.clear();
      }
    });
  }

  /// Function to toggle the selection of an individual item
  /// [index] is the index of the item in the list.
  /// [totalItems] is the total number of items in the list.
  void toggleItemSelection(int index, int totalItems) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
        selectAll = false;
      } else {
        selectedItems.add(index);
        if (selectedItems.length == totalItems) {
          selectAll = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: controller.listBloc,
            listener: (context, state) {
              if (state is PaymentPendencyLoadingState) {
                _indicatorKey.currentState?.show();
              }
            },
          ),
          BlocListener(
            bloc: controller.detailsBloc,
            listener: (context, state) {
              if (state is PendencyBalanceLoadingState) {
                _indicatorKey.currentState?.show();
              }
            },
          ),
        ],
        child: BlocBuilder(
          bloc: controller.listBloc,
          builder: (context, state) {
            return Scaffold(
              backgroundColor: LelloTheme.palleteOf(theme).background(),
              key: scaffoldKey,
              endDrawer: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Drawer(
                  child: Container(
                    color: const Color(0xFF2D2D2D),
                    child: ListView(
                      padding: EdgeInsets.only(top: Dimens.spacingMedium)
                          .copyWith(top: Dimens.spacingXLarge),
                      children: [
                        ListTile(
                          title: Text(
                            getString(context, "payment_filter_title"),
                            style: LelloTextStyles.title(LelloTheme.dark),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: SvgPicture.asset("assets/ic_close_white.svg"),
                          ),
                        ),
                        const PaymentListFilterWidget(
                          isPendency: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              appBar: PrimaryAppBar(
                iconColor: theme.primaryColor,
                theme: theme,
                title: getString(context, "payment_pendency_title"),
                onBackArrowPressed: () {
                  Navigator.pop(context);
                },
                actions: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () =>
                          scaffoldKey.currentState!.openEndDrawer(),
                      icon: SvgPicture.asset(
                        "assets/ic_filter.svg",
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                key: _indicatorKey,
                onRefresh: () async {
                  await controller.getInstallmentsInApproval();
                  await loadCondominiumBalance();
                },
                child: Builder(builder: (context) {
                  if (state is PaymentPendencyLoadingState ||
                      state is PaymentCheckProfileLoadingState) {
                    return const Column(
                      children: [
                        Expanded(
                          child: LoadingWidget(),
                        ),
                      ],
                    );
                  }
                  if (state is PaymentPendencyEmptyState) {
                    return Center(
                      child: Text(getString(
                          context, "payment_pendency_list_page_empty")),
                    );
                  }
                  if (state is PaymentCheckProfileFailureState ||
                      (state is PaymentCheckProfileSuccessState &&
                          state.success == false) ||
                      controller.canUserApprove == false) {
                    return const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: NoAccessToThisFeatureWidget(),
                    );
                  }
                  if (state is PaymentPendencyFailureState) {
                    return Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: ErrorHandlingWidget(
                        reTryFunction: () {
                          controller.getInstallmentsInApproval();
                          loadCondominiumBalance();
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.error?.error.toString() ?? "",
                        errorCode: state.error?.code.toString() ?? "",
                        textReturnButton: "back_to_the_previous_page",
                      ),
                    );
                  }
                  if (state is PaymentPendencySuccessState) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Visibility(
                                visible: infoBannerVisible,
                                child: InfoBannerWidget(
                                    onClose: () {
                                      setState(() {
                                        infoBannerVisible = false;
                                      });
                                    },
                                    theme: theme)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: checkboxesVisible,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: selectAll,
                                          onChanged: (value) {
                                            toggleSelectAll(state.data.length);
                                          },
                                        ),
                                        Text(
                                          getString(context,
                                              "payment_pendency_select_all_btn"),
                                          style:
                                              LelloTextStyles.bodyBold(theme)!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: !checkboxesVisible
                                        ? ElevatedButton(
                                            onPressed: () {
                                              checkboxesVisible =
                                                  !checkboxesVisible;
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                  color: theme.primaryColor,
                                                  width: 2),
                                              backgroundColor: Colors.white,
                                              foregroundColor:
                                                  theme.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                            ),
                                            child: Text(
                                              getString(
                                                  context, "select_action"),
                                              style: LelloTextStyles.bodyBold(
                                                      theme)!
                                                  .copyWith(
                                                      color:
                                                          theme.primaryColor),
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              checkboxesVisible =
                                                  !checkboxesVisible;
                                              selectedItems.clear();
                                              selectAll = false;
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  theme.primaryColor,
                                              foregroundColor:
                                                  theme.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                            ),
                                            child: Text(
                                              getString(context, "cancel"),
                                              style: LelloTextStyles.bodyBold(
                                                      theme)!
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final item = state.data[index];
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Visibility(
                                        visible: checkboxesVisible,
                                        child: Checkbox(
                                          value: selectedItems.contains(index),
                                          onChanged: (value) {
                                            toggleItemSelection(
                                                index, state.data.length);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: PaymentListItem(
                                          payment: item,
                                          onPressed: (id) {
                                            if (checkboxesVisible) {
                                              toggleItemSelection(
                                                  index, state.data.length);
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                ApplicationRoute
                                                    .approvePaymentDetail,
                                                arguments:
                                                    PendencyDetailsPageArgs(
                                                  payment: item,
                                                  index: index,
                                                  infoBannerVisible:
                                                      infoBannerVisible,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                itemCount: state.data.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                  thickness: 3,
                                  color: LelloTheme.palleteOf(theme)
                                      .backgroundDark(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (selectedItems.isNotEmpty) ...[
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButtonWithState(
                                    'assets/ic_refuse.svg',
                                    state,
                                    balance?.balance),
                                SizedBox(width: Dimens.spacingSmall),
                                _buildActionButtonWithState(
                                    'assets/ic_suspend.svg',
                                    state,
                                    balance?.balance),
                                SizedBox(width: Dimens.spacingSmall),
                                _buildActionButtonWithState(
                                    'assets/ic_approve.svg',
                                    state,
                                    balance?.balance),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<AccessToken?> _getAccessToken(GetToken getToken) async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> _getUserType(GetToken getToken) async {
    final token = await _getAccessToken(getToken);
    return token?.selectedRole ?? "";
  }

  PendencyApprovalAction? _getPendencyAction(String assetPath) {
    switch (assetPath) {
      case 'assets/ic_refuse.svg':
        return PendencyApprovalAction.reject;
      case 'assets/ic_suspend.svg':
        return PendencyApprovalAction.suspend;
      case 'assets/ic_approve.svg':
        return PendencyApprovalAction.approve;
      default:
        return null;
    }
  }

  _analyticsActionButtonLogEvent(
    PendencyApprovalAction action,
  ) async {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final GetToken getToken = ApplicationContainer.instance().resolve();
    String reference =
        sessionBloc.state.session!.selectedCondominium?.reference.toString() ??
            "";
    final token = await _getAccessToken(getToken);
    AnalyticsEvent event = action == PendencyApprovalAction.approve
        ? AnalyticsEventsManager.aprovacaoPendenteAprovar()
        : action == PendencyApprovalAction.reject
            ? AnalyticsEventsManager.aprovacaoPendenteRecusar()
            : AnalyticsEventsManager.aprovacaoPendenteSuspender();

    AnalyticsLogEvents.logEvent(
      event: event,
      userType: await _getUserType(getToken),
      referenceValue: reference,
      userId: sessionBloc.state.session?.me?.id ?? "",
      appOrigin: AppOriginEnum.manager,
    );
  }

  List<PaymentInstallmentInApprovalEntity> _getSelectedPayments(
      PaymentPendencyState state) {
    List<PaymentInstallmentInApprovalEntity> selectedPayments = [];

    if (state is PaymentPendencySuccessState) {
      List<PaymentInstallmentInApprovalEntity> paymentsList = state.data;

      if (paymentsList.isEmpty) {
        return selectedPayments;
      }

      for (var index in selectedItems) {
        if (index >= 0 && index < paymentsList.length) {
          selectedPayments.add(paymentsList[index]);
        }
      }
    }

    return selectedPayments;
  }

  Widget _buildActionButtonWithState(
    String assetPath,
    PaymentPendencyState state,
    double? balance,
  ) {
    PendencyApprovalAction? action = _getPendencyAction(assetPath);
    return IconButton(
      icon: SvgPicture.asset(assetPath, height: 75, width: 75),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BalanceApprovalModal(
              balance: balance,
              action: action!,
              onConfirm: () async {
                await _analyticsActionButtonLogEvent(action);
                controller.navigateOnActionButtonPressed(
                    context, action, _getSelectedPayments(state));
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}
