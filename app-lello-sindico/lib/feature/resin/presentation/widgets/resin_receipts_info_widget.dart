import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/controller/resin_receipt_details_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_carousel.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_status_selector_widget.dart';

class ResinReceiptsInfoWidget extends StatefulWidget {
  final ResinRefund refund;
  final ResinReceiptDetailsController controller;
  const ResinReceiptsInfoWidget({
    Key? key,
    required this.refund,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinReceiptsInfoWidget> createState() =>
      _ResinReceiptsInfoWidgetState();
}

class _ResinReceiptsInfoWidgetState extends State<ResinReceiptsInfoWidget> {
  final CarouselSliderController carouselController = CarouselSliderController();
  var dateFormat = DateFormat("dd/MM/yyyy - HH:mm");
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  double refundValue = 0.0;
  double openValue = 0.0;

  @override
  void initState() {
    super.initState();
    for (var element in widget.refund.receipts) {
      refundValue += element.receiptValue;
    }
    openValue = widget.refund.value - refundValue;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildRefundDescription(theme, context),
          SizedBox(height: Dimens.spacingSmall),
          if (widget.refund.receipts.isNotEmpty)
            ResinReceiptsCarousel(
              carouselController: carouselController,
              receipts: widget.refund.receipts,
            ),
          SizedBox(height: Dimens.spacing),
          Divider(
            color: LelloTheme.palleteOf(theme).separator(),
            thickness: 2,
            height: 0,
          ),
          SizedBox(height: Dimens.spacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IsNotCanceled(widget.refund)
                ? PrimaryButton(
                    text: getString(context, "resin_receipts_add_new_receipt"),
                    onPressed: () {
                      ResinReceiptBottomSheet.show(
                        context: context,
                      ).then((value) {
                        if (value != null) {
                          widget.controller
                              .uploadReceipt(widget.refund.id!, value);
                        }
                      });
                    },
                  )
                : Container(),
          ),
          TertiaryButton(
            text: getString(context, "back"),
            style: TextStyle(color: theme.primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Padding _buildRefundDescription(ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(context, "date"),
                style: LelloTextStyles.body(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
              ),
              Text(
                getString(context, "refund_details_status"),
                style: LelloTextStyles.body(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dateFormat.format(widget.refund.requestDate!)}h',
                style: LelloTextStyles.body(theme),
              ),
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus:
                    widget.refund.status ?? ResinRefundStatus.sended,
              )
            ],
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "resin_receipts_request_value"),
            formatCurrency.format(widget.refund.value),
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "resin_receipts_open_value"),
            openValue > 0
                ? formatCurrency.format(openValue)
                : formatCurrency.format(0.0),
            isOpen: true,
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "resin_value_description_description_label"),
            widget.refund.description ?? '-',
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "refund_details_requested_by"),
            widget.refund.requester,
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "refund_details_to_account"),
            widget.refund.destinationAccount!.supplierName,
          ),
          SizedBox(height: Dimens.spacing),
          _buildDetailsInfo(
            theme,
            getString(context, "refund_details_account_number"),
            '${widget.refund.destinationAccount!.bank!.bankName} - ${widget.refund.destinationAccount!.accountNumber}',
          ),
        ],
      ),
    );
  }

  Column _buildDetailsInfo(ThemeData theme, String title, String subtitle,
      {bool isOpen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: LelloTextStyles.body(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          subtitle,
          style: isOpen
              ? LelloTextStyles.bodyBold(theme)!
                  .copyWith(color: theme.primaryColor)
              : LelloTextStyles.body(theme),
        ),
      ],
    );
  }

  bool IsNotCanceled(ResinRefund resinRefund) {
    return resinRefund.status != ResinRefundStatus.canceled;
  }
}
