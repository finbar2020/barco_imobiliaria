import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet_body_widget.dart';

class ResinReceiptBottomSheet {
  static Future<ResinRefundReceipt?> show({
    required BuildContext context,
    ResinRefundReceipt? receipt,
    int? maxFileSizePermitted,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      builder: (context) {
        return ResinReceiptBottomSheetBodyWidget(
          receipt: receipt,
          maxFileSizePermitted: maxFileSizePermitted,
        );
      },
    ).then((value) {
      if (value is ResinRefundReceipt) {
        return value;
      }
      return null;
    });
  }
}
