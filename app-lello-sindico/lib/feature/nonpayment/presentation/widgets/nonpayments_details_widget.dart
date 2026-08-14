import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_build_title_subtitle_widget.dart';

class DetailsWidget extends StatelessWidget {
  final NonPayment payments;

  const DetailsWidget({Key? key, required this.payments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        children: <Widget>[
          TitleSubtitleWidget(
            subTitle: payments.quotes != null ? payments.quotes.toString() : "",
            title: getString(context, "non_payments_details_container_quotas"),
          ),
          TitleSubtitleWidget(
            subTitle: payments.value != null
                ? formatCurrency.format(payments.value)
                : "",
            title: getString(context, "non_payments_details_container_value"),
          ),
          TitleSubtitleWidget(
              subTitle: payments.valueWithPenalty != null
                  ? formatCurrency.format(payments.valueWithPenalty)
                  : "",
              title: getString(
                  context, "non_payments_details_container_value_penalty"),
              usingSpacingBottom: false),
        ],
      ),
    );
  }
}
