import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String condominiumName;

  const HeaderWidget({Key? key, required this.condominiumName})
      : super(key: key);

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
            getString(context, "non_payments_header_title"),
            style: LelloTextStyles.body(theme),
          ),
          Text(
              dateFormat.format(
                DateTime.now(),
              ),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "non_payments_header_condominium"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          Text(
            condominiumName,
            style: LelloTextStyles.body(theme),
          ),
        ],
      ),
    );
  }
}
