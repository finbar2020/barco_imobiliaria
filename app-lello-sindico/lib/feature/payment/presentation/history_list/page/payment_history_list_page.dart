import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_state.dart';
import 'package:lello/feature/payment/presentation/history_list/controller/payment_history_list_controller.dart';
import 'package:lello/feature/payment/presentation/history_list/widgets/payment_history_list_filter_widget.dart';
import 'package:lello/feature/payment/presentation/history_list/widgets/payment_history_list_item.dart';

import '../../../../../core/widget/loading_widget.dart';

class PaymentHistoryListPageArgs {
  String? paymentNotificationContext;
  PaymentHistoryListPageArgs({
    this.paymentNotificationContext,
  });
}

class PaymentHistoryListPage extends StatefulWidget {
  const PaymentHistoryListPage({super.key});

  @override
  PaymentHistoryListPageState createState() => PaymentHistoryListPageState();
}

class PaymentHistoryListPageState extends State<PaymentHistoryListPage>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final filter = PaymentListFilter();
  final dateFormat = DateFormat.yMd();

  final controller =
      ApplicationContainer.instance().resolve<PaymentHistoryController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  PaymentHistoryListPageArgs? arguments;
  bool redirect = false;

  @override
  void initState() {
    controller.fetchPaymentFilter();
    super.initState();
  }

  @override
  void dispose() {
    controller.clearFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments
        as PaymentHistoryListPageArgs?;
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) {
          if (state is PaymentHistorySuccessState) {}
        },
        bloc: controller.bloc,
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
                          icon: SvgPicture.asset("assets/ic_close_white.svg"),
                        ),
                      ),
                      const PaymentHistoryListFilterWidget(),
                    ],
                  ),
                ),
              ),
            ),
            appBar: PrimaryAppBar(
                theme: theme,
                title: getString(context, "payments_history"),
                actions: [
                  Container(
                    width: 42,
                    height: 42,
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
                        colorFilter: ColorFilter.mode(
                            theme.primaryColor, BlendMode.srcIn),
                      ),
                    ),
                  )
                ]),
            body: RefreshIndicator(
              key: _indicatorKey,
              onRefresh: () async {
                controller.fetchPaymentFilter();
              },
              child: Builder(
                builder: (context) {
                  if (state is PaymentHistoryLoadingState) {
                    return const Column(
                      children: [
                        Expanded(
                          child: LoadingWidget(),
                        ),
                      ],
                    );
                  }
                  if (state is PaymentHistoryEmptyState) {
                    return Center(
                      child: Text(getString(
                          context, "payment_History_list_page_empty")),
                    );
                  }
                  if (state is PaymentHistoryFailureState) {
                    return Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: ErrorHandlingWidget(
                        reTryFunction: () {
                          controller.fetchPaymentFilter();
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.error?.error.toString() ?? "",
                        errorCode: state.error?.code.toString() ?? "",
                        textReturnButton: "back_to_the_previous_page",
                      ),
                    );
                  }
                  if (state is PaymentHistorySuccessState) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var item = state.data[index];
                        return InkWell(
                          child: PaymentHistoryListItem(item),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ApplicationRoute.paymentHistoryDetails,
                                arguments: item);
                          },
                        );
                      },
                      itemCount: state.data.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  }
                  return SizedBox.fromSize();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
