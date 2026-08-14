import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refunds_steps_enum.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/controller/resin_new_refund_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_widget.dart';

class ResinNewRefundReceipts extends StatefulWidget {
  final Function(ResinRefundsStepsEnum step) updateStep;
  final ResinParams resinParams;
  final ResinNewRefundController controller;
  const ResinNewRefundReceipts({
    Key? key,
    required this.updateStep,
    required this.resinParams,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewRefundReceipts> createState() => _ResinNewRefundReceiptsState();
}

class _ResinNewRefundReceiptsState extends State<ResinNewRefundReceipts> {
  late ThemeData theme;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocBuilder<ResinNewRefundBloc, ResinNewRefundState>(
      bloc: widget.controller.bloc,
      builder: (context, state) {
        if (state is ResinNewRefundLoadingState)
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(
                  message:
                      getString(context, "resin_review_data_refund_loading"),
                ),
              ),
            ],
          );

        if (state is ResinNewRefundErrorState)
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: StepIndicator(numberOfSteps: 4, currentStep: 2),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResinReceiptsWidget(
                      refund: widget.controller.resinRefund,
                      resinParams: widget.resinParams,
                    ),
                  ],
                ),
              ),
            ),
            _buildButtons(context),
          ],
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      child: Column(
        children: [
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            height: 40.0,
            onPressed: () {
              ResinReceiptBottomSheet.show(
                context: context,
                maxFileSizePermitted:
                    widget.resinParams.maxFileSizeAllowed?.toInt(),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    widget.controller.resinRefund.receipts.add(value);
                  });
                }
              });
            },
            child: Text(
              getString(context, "resin_receipts_add_new_receipt"),
              textScaleFactor: 1.0,
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).buttonText()),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          PrimaryButton(
            height: 40.0,
            onPressed: widget.controller.resinRefund.receipts.isEmpty
                ? null
                : () {
                    if (widget.controller.resinRefund.receipts.isNotEmpty) {
                      widget.updateStep(ResinRefundsStepsEnum.reviewData);
                    } else {
                      Flushbar(
                        message:
                            getString(context, "resin_receipts_insert_receipt"),
                        duration: Duration(seconds: 4),
                      )..show(context);
                    }
                  },
            text: getString(context, "next"),
          ),
          SizedBox(height: Dimens.spacingSmall),
          SecondaryButton(
            height: 40.0,
            onPressed: () {
              widget.updateStep(ResinRefundsStepsEnum.valueDescription);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
          SizedBox(height: Dimens.spacing),
        ],
      ),
    );
  }

  void _setUpPage() {
    firstBuild = false;
    theme = Theme.of(context);
  }
}
