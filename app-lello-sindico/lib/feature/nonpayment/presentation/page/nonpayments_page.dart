import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_state.dart';
import 'package:lello/feature/nonpayment/presentation/controller/nonpayments_controller.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_details_list_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_details_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_hearder_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class NonPaymentsPage extends StatefulWidget {
  const NonPaymentsPage({Key? key}) : super(key: key);

  @override
  NonPaymentsState createState() => NonPaymentsState();
}

class NonPaymentsState extends State<NonPaymentsPage> {
  final NonPaymentController nonPaymentController =
      ApplicationContainer.instance().resolve<NonPaymentController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  var _refreshCompleter = Completer<void>();
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "non_payments_title")),
        body: RefreshIndicator(
          key: _indicatorKey,
          onRefresh: () {
            nonPaymentController.getNonPayments();
            return _refreshCompleter.future;
          },
          child: FutureBuilder(
            future: nonPaymentController.getNonPayments(),
            builder: (context, state) {
              return BlocConsumer(
                bloc: nonPaymentController.nonPaymentsBloc,
                listener: (context, state) {
                  if (state is! NonPaymentsLoadingState) {
                    _refreshCompleter.complete();
                    _refreshCompleter = Completer<void>();
                  } else {
                    _indicatorKey.currentState!.show();
                  }
                },
                builder: (BuildContext context, state) {
                  if (state is NonPaymentsLoadingState) {
                    return const Column(
                      children: [
                        Expanded(
                          child: LoadingWidget(),
                        ),
                      ],
                    );
                  }
                  if (state is NonPaymentsLoadFailedState) {
                    return Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: ErrorHandlingWidget(
                        reTryFunction: () {
                          nonPaymentController.getNonPayments();
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.error?.error.toString() ?? "",
                        errorCode: state.error?.code.toString() ?? "",
                        textReturnButton: "back_to_the_previous_page",
                      ),
                    );
                  }
                  if (state is NonPaymentsLoadedState) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HeaderWidget(condominiumName: state.condominiumName),
                          DetailsWidget(payments: state.payments),
                          const Divider(),
                          DetailsListWidget(payments: state.payments),
                        ],
                      ),
                    );
                  }

                  return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
