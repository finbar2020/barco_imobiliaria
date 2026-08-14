import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_datail_title_subtitle_widget.dart';

class GridDetailWidget extends StatelessWidget {
  final NonPaymentsDetail detail;

  const GridDetailWidget({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = LelloTheme.light;
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(getString(context, "non_payments_detail_container_title"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingMedium),
          GridView.count(
            childAspectRatio: 3,
            crossAxisCount: 2,
            shrinkWrap: true,
            children: <Widget>[
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_value"),
                subTitle: formatCurrency.format(detail.valueLiquid),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_correction"),
                subTitle: formatCurrency.format(detail.interest),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_penalty"),
                subTitle: formatCurrency.format(detail.penalty),
                usingSpacingBottom: false,
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_total_value"),
                subTitle: formatCurrency.format(detail.value),
                usingSpacingBottom: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
