import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lello/feature/resin/domain/entity/resin_params.dart';

class ResinTotalValuesWidget extends StatelessWidget {
  final ResinParams resinParams;

  const ResinTotalValuesWidget({
    Key? key,
    required this.resinParams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final formatCurrency = NumberFormat.currency(symbol: 'R\$ ');

    return Container(
      color: palette.greyCard(),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spacingMedium,
        vertical: Dimens.spacingMedium,
      ),
      child: Row(
        children: [
          _ValueBlock(
            label: getString(context, 'resin_total_limit_value'),
            value: formatCurrency.format(resinParams.requestMaxValue),
            valueColor: palette.success(),
            theme: theme,
          ),
          _ValueBlock(
            label: getString(context, 'resin_total_to_prove'),
            value: '-${formatCurrency.format(resinParams.usedValue.abs())}',
            valueColor: palette.error(),
            theme: theme,
          ),
          _ValueBlock(
            label: getString(context, 'resin_total_remaining'),
            value: formatCurrency.format(resinParams.avaliableValue),
            valueColor: palette.routineBlue(),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _ValueBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final ThemeData theme;

  const _ValueBlock({
    Key? key,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: LelloTextStyles.caption(theme),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          Text(
            value,
            textAlign: TextAlign.center,
            style: LelloTextStyles.bodyBold(theme)!.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
