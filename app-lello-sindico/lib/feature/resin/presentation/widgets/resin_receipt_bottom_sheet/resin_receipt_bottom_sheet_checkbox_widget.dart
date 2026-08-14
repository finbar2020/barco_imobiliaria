import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';

class ResinReceiptBottomSheetCheckboxWidget extends StatefulWidget {
  final ResinRefundReceipt receipt;
  const ResinReceiptBottomSheetCheckboxWidget({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  @override
  State<ResinReceiptBottomSheetCheckboxWidget> createState() =>
      _ResinReceiptBottomSheetCheckboxWidgetState();
}

class _ResinReceiptBottomSheetCheckboxWidgetState
    extends State<ResinReceiptBottomSheetCheckboxWidget> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: _receiptCheckbox(ResinRefundReceiptType.tax_note,
              getString(context, "resin_refund_receipt_type_tax_note")),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Flexible(
          child: _receiptCheckbox(ResinRefundReceiptType.receipt,
              getString(context, "resin_refund_receipt_type_receipt")),
        ),
      ],
    );
  }

  Row _receiptCheckbox(ResinRefundReceiptType type, String text) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            activeColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            side: BorderSide(
              width: 1.0,
              color: LelloTheme.palleteOf(theme).grey(),
            ),
            value: widget.receipt.receiptType == type,
            onChanged: (val) {
              _updateType(type);
            },
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              _updateType(type);
            },
            child: Text(
              text,
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
            ),
          ),
        )
      ],
    );
  }

  void _updateType(ResinRefundReceiptType type) {
    setState(() {
      if (widget.receipt.receiptType != type) {
        widget.receipt.receiptType = type;
      } else {
        widget.receipt.receiptType = null;
      }
    });
  }
}
