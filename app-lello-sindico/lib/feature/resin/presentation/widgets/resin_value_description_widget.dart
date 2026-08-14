import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

class ResinValueDescriptionWidget extends StatefulWidget {
  final ResinRefund refund;
  final ResinParams resinParams;
  const ResinValueDescriptionWidget({
    Key? key,
    required this.refund,
    required this.resinParams,
  }) : super(key: key);

  @override
  State<ResinValueDescriptionWidget> createState() =>
      _ResinValueDescriptionWidgetState();
}

final Validator validator = ApplicationContainer.instance().resolve();

class _ResinValueDescriptionWidgetState
    extends State<ResinValueDescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    TextEditingController valueController =
        TextEditingController(text: formatCurrency.format(widget.refund.value));
    TextEditingController descriptionController =
        TextEditingController(text: widget.refund.description);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: [
            Text(
              '${getString(context, "resin_value_description_how_much")} ',
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
            ),
            Text(
              "${widget.refund.destinationAccount?.supplierName}",
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
            ),
          ]),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
            child: PrimaryAmountFormField(
              fontSize: LelloTextStyles.headline(theme)?.fontSize ?? 36.0,
              textInputType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                widget.refund.value = formatCurrency.parse(value) as double;
              },
              controller: valueController,
              validator: (value) =>
                  validator.validatePositiveValue(value ?? ""),
              action: TextInputAction.done,
              formatter: currencyFormatter(),
            ),
          ),
          Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                widget.refund.type == ResinRefundType.refund
                    ? "${getString(context, 'resin_value_description_already_refund')}"
                    : "${getString(context, 'resin_value_description_value_available')}",
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
              ),
              Text(
                widget.refund.type == ResinRefundType.refund
                    ? "${formatCurrency.format(widget.resinParams.refundTotalValue)}"
                    : "${formatCurrency.format(widget.resinParams.avaliableValue)}",
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "resin_value_description_description_label"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          SizedBox(height: Dimens.spacingSmall),
          TextField(
            maxLength: 256,
            maxLines: 6,
            controller: descriptionController,
            onChanged: (value) {
              widget.refund.description = value;
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
        ],
      ),
    );
  }
}
