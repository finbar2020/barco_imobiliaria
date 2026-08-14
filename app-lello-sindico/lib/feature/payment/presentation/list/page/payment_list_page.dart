import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_state.dart';

import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/widget/payment_conta_pagar_item.dart';
import 'package:lello/feature/payment/presentation/widget/payment_list_item.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_action_bloc.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_action_event.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_action_state.dart';

import '../../../../../core/navigation/application_route.dart';
import '../../pendency/bloc/list_bloc/payment_pendency_list_bloc.dart';
import '../../pendency/widgets/no_access_to_this_feature_widget.dart';
import '../../pendency/widgets/payment_list_filter_widget.dart';
import '../bloc/payment_list_bloc.dart';

class PaymentListPage extends StatefulWidget {
  const PaymentListPage({Key? key}) : super(key: key);

  @override
  PaymentListPageState createState() => PaymentListPageState();
}

class PaymentListPageState extends State<PaymentListPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  final dateFormat = DateFormat.yMd();

  final _indicatorKey = GlobalKey<RefreshIndicatorState>();
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    controller.getContasPagar();
    super.initState();
  }

  bool redirect = false;

  @override
  void dispose() {
    super.dispose();
    controller.clearFilters(isPendency: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: MultiBlocProvider(
          providers: [
            BlocProvider<PaymentPendencyListBloc>(
              create: (context) => controller.listBloc,
            ),
            BlocProvider<PaymentListBloc>(
              create: (context) => controller.paymentListBloc,
            ),
            BlocProvider<PaymentListActionBloc>(
              create: (context) => PaymentListActionBloc(controller),
            ),
          ],
          child: BlocConsumer(
            bloc: controller.paymentListBloc,
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
                key: scaffoldState,
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
                              icon:
                                  SvgPicture.asset("assets/ic_close_white.svg"),
                            ),
                          ),
                          const PaymentListFilterWidget(
                            isPendency: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                appBar: PrimaryAppBar(
                  iconColor: theme.primaryColor,
                  theme: theme,
                  onBackArrowPressed: () {
                    Navigator.pop(context);
                  },
                  title: getString(context, "payments_view_payment"),
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
                            scaffoldState.currentState!.openEndDrawer(),
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
                  onRefresh: () => controller.getContasPagar(),
                  child: Builder(
                    builder: (context) {
                      if (state is PaymentContaPagarLoadingState) {
                        return const Column(
                          children: [
                            Expanded(
                              child: LoadingWidget(),
                            ),
                          ],
                        );
                      }
                      if (state is PaymentContaPagarEmptyState) {
                        return Center(
                          child: Text(
                              getString(context, "payment_list_page_empty")),
                        );
                      }
                      if (state is PaymentContaPagarFailureState) {
                        return Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: ErrorHandlingWidget(
                            reTryFunction: () {
                              controller.getContasPagar();
                            },
                            backFunction: () => Navigator.pop(context, true),
                            isProduction: env.isProduction,
                            error: state.error?.error.toString() ?? "",
                            errorCode: state.error?.code.toString() ?? "",
                            textReturnButton: "back_to_the_previous_page",
                          ),
                        );
                      }
                      if (state is PaymentContaPagarSuccessState) {
                        return BlocConsumer<PaymentListActionBloc,
                            PaymentListActionState>(
                          listener: (context, actionState) async {
                            if (actionState is PaymentListActionLoadedState) {
                              Navigator.pushNamed(
                                context,
                                ApplicationRoute.paymentDetail,
                                arguments: actionState.installment,
                              );
                              context
                                  .read<PaymentListActionBloc>()
                                  .add(const PaymentListActionResetEvent());
                            }
                          },
                          builder: (context, actionState) {
                            return Stack(
                              children: [
                                ListView.separated(
                                  itemBuilder: (context, index) {
                                    final item = state.data[index];
                                    return PaymentContaPagarItem(
                                      payment: item,
                                      onPressed: (selected) {
                                        context
                                            .read<PaymentListActionBloc>()
                                            .add(PaymentListActionPressedEvent(
                                                selected));
                                      },
                                    );
                                  },
                                  itemCount: state.data.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                    thickness: 15,
                                    color: LelloTheme.palleteOf(theme)
                                        .backgroundDark(),
                                  ),
                                ),
                                if (actionState is PaymentListActionLoadingState)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.3),
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      }
                      return const Column(
                        children: [
                          Expanded(
                            child: LoadingWidget(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          )),
    );
  }

  Future<PaymentInstallmentInApprovalEntity?> _getInstallmentById(
      String id) async {
    await controller.getInstallmentsInApproval(
        onlyInApprovalStatus: false, installmentId: id);
    if (controller.allInstallmentsInApproval!.isNotEmpty) {
      return controller.allInstallmentsInApproval!.first;
    } else {
      return null;
    }
  }
}
