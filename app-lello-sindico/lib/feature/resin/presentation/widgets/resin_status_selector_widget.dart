import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';

class ResinStatusSelectorWidget extends StatelessWidget {
  final BuildContext context;
  final ResinRefundStatus refundRelatoryStatus;

  const ResinStatusSelectorWidget({
    super.key,
    required this.context,
    required this.refundRelatoryStatus,
  });

  @override
  Widget build(BuildContext context) {
    return _statusSelector(context, refundRelatoryStatus);
  }

  Widget _statusSelector(context, ResinRefundStatus? status) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(refundRelatoryStatusToColor(context, status)))),
        const Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        Text(
          refundRelatoryStatusToString(
            context,
            status,
          ),
        ),
      ],
    );
  }

  String refundRelatoryStatusToString(
      BuildContext context, ResinRefundStatus? status) {
    switch (status) {
      case ResinRefundStatus.sended:
        return getString(context, "sended");
      case ResinRefundStatus.processed:
        return getString(context, "processed");
      case ResinRefundStatus.paid:
        return getString(context, "paid");
      case ResinRefundStatus.inconsistency:
        return getString(context, "inconsistency");
      case ResinRefundStatus.canceled:
        return getString(context, "canceled");
      case ResinRefundStatus.closing:
        return getString(context, "closing");
      default:
        return getString(context, "sended");
    }
  }

  String refundRelatoryStatusToColor(
      BuildContext context, ResinRefundStatus? status) {
    switch (status) {
      case ResinRefundStatus.sended:
        return "#ed6c02";
      case ResinRefundStatus.processed:
        return "#2e7d32";
      case ResinRefundStatus.paid:
        return "#2e7d32";
      case ResinRefundStatus.inconsistency:
        return "#9c27b0";
      case ResinRefundStatus.canceled:
        return "#bdbdbd";
      case ResinRefundStatus.closing:
        return "#000000";
      default:
        return "#ed6c02";
    }
  }
}
