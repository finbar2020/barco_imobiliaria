import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';

class BilletInfoIntroWidget extends StatelessWidget {
  final Billet billet;
  final String condominiumName;

  BilletInfoIntroWidget({
    Key? key,
    required this.billet,
    required this.condominiumName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStatusInfo(context, billet),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          _buildTitleSubtitle(
            context,
            "name",
            billet.name ?? "",
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: Dimens.spacingSmall),
          _buildTitleSubtitle(
            context,
            "value",
            formatCurrency.format(billet.value),
          ),
          SizedBox(height: Dimens.spacingSmall),
          _buildTitleSubtitle(
            context,
            "register_payment_document_number",
            billet.nrBillet ?? "",
          ),
          SizedBox(height: Dimens.spacing),
          _buildTitleSubtitle(
            context,
            "register_payment_document_expiration_date",
            billet.vencimentoFullDate,
          ),
          SizedBox(height: Dimens.spacing),
          _buildTitleSubtitle(
            context,
            "condominium",
            condominiumName,
          ),
        ],
      ),
    );
  }

  Column _buildTitleSubtitle(
      BuildContext context, String titleKey, String subtitle,
      {TextOverflow? overflow}) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, titleKey),
          overflow: TextOverflow.ellipsis,
          style: LelloTextStyles.bodyBold(theme),
        ),
        Text(
          subtitle,
          overflow: overflow ?? TextOverflow.ellipsis,
          style: LelloTextStyles.body(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
        ),
      ],
    );
  }

  Row _buildStatusInfo(BuildContext context, Billet billet) {
    ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: billet.color(theme),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Text(
          "${getString(context, billet.statusText)}",
          overflow: TextOverflow.ellipsis,
          style: LelloTextStyles.subBody(theme)?.copyWith(
            color: billet.color(theme),
          ),
        ),
      ],
    );
  }
}
