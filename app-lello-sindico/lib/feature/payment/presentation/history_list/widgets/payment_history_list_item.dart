import 'package:essentials/essentials.dart';
import 'package:essentials/ui/dimens.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';

class PaymentHistoryListItem extends StatelessWidget {
  final PaymentHistoryItem item;
  const PaymentHistoryListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    TextStyle? label = LelloTextStyles.body(theme)?.copyWith(
      color: LelloTheme.palleteOf(theme).textLight(),
    );
    TextStyle? valueBold = LelloTextStyles.bodyBold(theme);
    TextStyle? valueColor = LelloTextStyles.bodyBold(theme)?.copyWith(
      color: LelloTheme.palleteOf(theme).primary(),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing, vertical: Dimens.spacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${getString(context, "payments_history_label_lancamento")}:",
                    style: label,
                  ),
                  SizedBox(width: Dimens.spacingXSmall),
                  Text(item.releaseId?.toString() ?? "-", style: valueBold),
                ],
              ),
              Text(
                  paymentHistoryItemStatusToString(
                      context, item.processingStatus),
                  style: valueBold),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(
                      item.supplierName ?? "-",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                      style: valueBold?.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Row(
                      children: [
                        Text(
                          "${getString(context, "payments_history_label_valor")}:",
                          style: label,
                        ),
                        SizedBox(width: Dimens.spacingXSmall),
                        if (item.totalValue != null)
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(item.totalValue),
                            style: valueColor,
                          )
                        else
                          Text("-", style: valueBold),
                        SizedBox(width: Dimens.spacingSmall),
                        Text(
                          "${getString(context, "payments_history_label_parcelas")}:",
                          style: label,
                        ),
                        SizedBox(width: Dimens.spacingXSmall),
                        Text(item.installments?.toString() ?? "-",
                            style: valueBold)
                      ],
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Row(
                      children: [
                        Text(
                          "${getString(context, "payments_history_label_data")}:",
                          style: label,
                        ),
                        SizedBox(width: Dimens.spacingXSmall),
                        Text(
                            item.inclusionDate != null
                                ? DateFormat("dd/MM/yyyy")
                                    .format(item.inclusionDate!)
                                : "-",
                            style: valueBold),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimens.spacing), // Add spacing
              SvgPicture.asset("assets/ic_arrow_right.svg", width: 6),
            ],
          ),
        ],
      ),
    );
  }
}
