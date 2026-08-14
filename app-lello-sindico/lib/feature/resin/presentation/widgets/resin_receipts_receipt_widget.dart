import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';

class ResinReceiptsReceiptWidget extends StatelessWidget {
  final ResinRefundReceipt receipt;
  final Function() excludeReceipt;
  const ResinReceiptsReceiptWidget({
    Key? key,
    required this.receipt,
    required this.excludeReceipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(
            context,
            "${getString(context, 'resin_receipts_send_date')} ",
            receipt.sendDateFormatted(),
          ),
          SizedBox(height: Dimens.spacingSmall),
          _buildRichText(
            context,
            "${getString(context, 'resin_receipts_value')} ",
            receipt.valueFormatted(),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (receipt.digitalDocument?.file != null)
                Flexible(
                  child: PrimaryButton(
                    height: 32.0,
                    text: getString(context, "resin_receipts_view"),
                    onPressed: () {
                      FileMethods.viewFile(
                          context, receipt.digitalDocument!.file!);
                    },
                  ),
                ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                child: SecondaryButton(
                  height: 32.0,
                  onPressed: () {
                    excludeReceipt();
                  },
                  text: getString(context, "resin_receipts_exclude"),
                ),
              ),
            ],
          ),
          Divider(height: 24.0),
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
            style: LelloTextStyles.body(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
          ),
          TextSpan(
            text: description,
            style: LelloTextStyles.bodyBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
        ],
      ),
    );
  }
}
