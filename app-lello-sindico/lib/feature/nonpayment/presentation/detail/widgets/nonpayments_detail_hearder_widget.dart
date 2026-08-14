import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';

class DetailHeaderWidget extends StatelessWidget {
  final NonPaymentsDetail detail;

  const DetailHeaderWidget({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMEd();
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: BoxDecoration(
        color: LelloTheme.palleteOf(theme).separator(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
              "${detail.resident?.unit?.title ?? ""} - ${detail.resident?.name!.toUpperCase()}",
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "non_payments_item_container_billing_status"),
            style: LelloTextStyles.body(theme),
          ),
          Text(
            detail.resident!.unit!.billingStatus!,
            style: LelloTextStyles.bodyBold(theme),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "non_payments_detail_header_title"),
            style: LelloTextStyles.body(theme),
          ),
          Text(
            dateFormat.format(detail.period!),
            style: LelloTextStyles.bodyBold(theme),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "non_payments_detail_header_title2"),
            style: LelloTextStyles.body(theme),
          ),
          Text(
            dateFormat.format(detail.period!),
            style: LelloTextStyles.bodyBold(theme),
          ),
        ],
      ),
    );
  }
}
