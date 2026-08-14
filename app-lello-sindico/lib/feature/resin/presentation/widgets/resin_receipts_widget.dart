import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_confirmation_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_receipt_widget.dart';

class ResinReceiptsWidget extends StatefulWidget {
  final ResinRefund refund;
  final ResinParams resinParams;
  const ResinReceiptsWidget({
    Key? key,
    required this.refund,
    required this.resinParams,
  }) : super(key: key);

  @override
  State<ResinReceiptsWidget> createState() => _ResinReceiptsWidgetState();
}

class _ResinReceiptsWidgetState extends State<ResinReceiptsWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResinRefund refund = widget.refund;
    final NumberFormat formatCurrency = NumberFormat.currency(symbol: "R\$");

    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "resin_receipts_title"),
            textAlign: TextAlign.start,
            style: LelloTextStyles.titleSmall(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacing),
          _buildRichText(
            context,
            "${getString(context, 'resin_receipts_total_refund_value')} ",
            formatCurrency.format(refund.value),
          ),
          SizedBox(height: Dimens.spacingSmall),
          _buildRichText(
            context,
            "${getString(context, 'resin_receipts_total_receipts_value')} ",
            formatCurrency.format(refund.getTotalReceiptsValue),
          ),
          SizedBox(height: Dimens.spacingMedium),
          if (refund.receipts.isEmpty)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: Dimens.spacingXLarge),
              child: Text(
                getString(context, "resin_receipts_empty"),
                textAlign: TextAlign.center,
              ),
            ),
          if (refund.receipts.isNotEmpty)
            ...List.generate(
              refund.receipts.length,
              ((index) => ResinReceiptsReceiptWidget(
                    receipt: refund.receipts[index],
                    excludeReceipt: () {
                      showDialog(
                        context: context,
                        builder: (context) => ResinConfirmationDialog(
                          subtitle: getString(
                              context, "resin_receipts_exclude_confirmation"),
                          confirmationFunction: () {
                            setState(() {
                              refund.receipts.remove(refund.receipts[index]);
                            });
                          },
                        ),
                      );
                    },
                  )),
            ),
        ],
      ),
    );
  }

  RichText _buildRichText(
      BuildContext context, String title, String description) {
    ThemeData theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: LelloTextStyles.bodyBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          TextSpan(
            text: description,
            style: LelloTextStyles.body(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
        ],
      ),
    );
  }
}
