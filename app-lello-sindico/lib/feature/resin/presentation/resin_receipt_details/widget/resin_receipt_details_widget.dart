import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_state.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/controller/resin_receipt_details_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_info_widget.dart';

class ResinReceiptDetailsWidget extends StatefulWidget {
  final String refundId;
  final ResinReceiptDetailsController controller;
  const ResinReceiptDetailsWidget({
    Key? key,
    required this.refundId,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinReceiptDetailsWidget> createState() =>
      _ResinReceiptDetailsWidgetState();
}

class _ResinReceiptDetailsWidgetState extends State<ResinReceiptDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();

    return BlocBuilder<ResinReceiptDetailsBloc, ResinReceiptDetailsState>(
      bloc: widget.controller.bloc,
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSnackBar(
              context, widget.controller.bloc.state.flushbarMessageKey);
          widget.controller.bloc.state.flushbarMessageKey = null;
        });
        if (state is ResinReceiptDetailsLoadingState) {
          return const Column(
            children: [
              Expanded(child: LoadingWidget()),
            ],
          );
        }
        if (state is ResinReceiptDetailsErrorState) {
          return Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                widget.controller.getRefundDetails(widget.refundId);
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: "",
              errorCode: "",
              textReturnButton: "back_to_the_previous_page",
            ),
          );
        }
        if (state is ResinReceiptDetailsLoadedState) {
          return ResinReceiptsInfoWidget(
            refund: state.refund,
            controller: widget.controller,
          );
        }
        return Container();
      },
    );
  }

  void _showSnackBar(BuildContext context, String? textKey) {
    if (textKey == null) {
      return;
    }
    String text = getString(context, textKey);
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }
}
