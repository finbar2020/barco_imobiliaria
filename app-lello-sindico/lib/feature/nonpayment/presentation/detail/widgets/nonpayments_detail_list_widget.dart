import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_datail_title_subtitle_widget.dart';

class DetailListWidget extends StatefulWidget {
  final NonPaymentsDetail detail;

  const DetailListWidget({Key? key, required this.detail}) : super(key: key);

  @override
  State<DetailListWidget> createState() => _DetailListWidgetState();
}

class _DetailListWidgetState extends State<DetailListWidget> {
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  final DateFormat _dateFormat = DateFormat.yMMMd();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.detail.receipts!.isNotEmpty
          ? widget.detail.receipts!.length
          : 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_invoice"),
                subTitle: widget.detail.receipts![index]!.receipt.toString(),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_period"),
                subTitle: _dateFormat.format(
                  widget.detail.receipts![index]!.period!,
                ),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_value"),
                subTitle: formatCurrency.format(
                  widget.detail.receipts![index]!.valueLiquid,
                ),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_penalty"),
                subTitle: formatCurrency.format(
                  widget.detail.receipts![index]!.penalty,
                ),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_correction"),
                subTitle: formatCurrency.format(
                  widget.detail.receipts![index]!.interest,
                ),
              ),
              DetailTitleSubtitleWidget(
                title: getString(context, "non_payments_detail_total_value"),
                subTitle: formatCurrency.format(
                  widget.detail.receipts![index]!.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
