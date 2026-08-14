import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/presentation/detail/page/nonpayments_detail_page.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_build_title_subtitle_widget.dart';

class ItemContainerWidget extends StatelessWidget {
  final NonPaymentsDetail detail;
  const ItemContainerWidget({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TitleSubtitleWidget(
            subTitle: detail.resident!.name!,
            title: getString(context, "non_payments_item_container_user_name"),
          ),
          TitleSubtitleWidget(
            subTitle: detail.resident!.unit!.billingStatus!,
            title: getString(
                context, "non_payments_item_container_billing_status"),
          ),
          TitleSubtitleWidget(
            subTitle: detail.receipts!.length.toString(),
            title: getString(context, "non_payments_item_subtitle"),
          ),
          TitleSubtitleWidget(
            subTitle: formatCurrency.format(detail.valueLiquid),
            title: getString(context, "non_payments_item_container_value"),
          ),
          TitleSubtitleWidget(
            subTitle: formatCurrency.format(detail.value),
            title:
                getString(context, "non_payments_item_container_value_penalty"),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                ApplicationRoute.nonPaymentsDetail,
                arguments: NonPaymentsDetailPageArgs(detail: detail),
              );
            },
            text:
                getString(context, "non_payments_item_container_action_button"),
          )
        ],
      ),
    );
  }
}
