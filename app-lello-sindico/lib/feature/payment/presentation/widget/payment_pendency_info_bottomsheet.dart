import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PaymentPendencyInfoBottomsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    TextStyle listTextStyle = LelloTextStyles.body(theme)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spacingLarge,
        vertical: Dimens.spacingLarge,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('O que são as aprovações pendentes?',
                textAlign: TextAlign.left,
                style: LelloTextStyles.subtitleBold(theme)),
            SizedBox(height: Dimens.spacingMedium),
            Text(
                'Pagamentos que precisam de aprovação para dar continuidade ao fluxo financeiro do condomínio. Os responsáveis por aprová-los são definidos pelo síndico.',
                textAlign: TextAlign.left,
                style: LelloTextStyles.body(theme)),
            SizedBox(height: Dimens.spacingMedium),
            Column(
              children: [
                Center(
                  child: PrimaryButton(
                    onPressed: () {},
                    width: 150,
                    text: "Aprovar",
                    buttonColor: LelloTheme.palleteOf(theme).success(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.circle,
                        color: LelloTheme.palleteOf(theme).success(),
                        size: 12,
                      ),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Expanded(
                      child: _buildRichText(
                        theme,
                        "Aprovar pagamentos:",
                        " ao aprovar, o pagamento segue para o próximo passo do fluxo financeiro",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingSmall),
                Center(
                  child: PrimaryButton(
                    onPressed: () {},
                    width: 150,
                    text: "Suspender",
                    buttonColor: LelloTheme.palleteOf(theme).warning(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.circle,
                        color: LelloTheme.palleteOf(theme).warning(),
                        size: 12,
                      ),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Expanded(
                      child: _buildRichText(
                        theme,
                        "Suspender pagamentos:",
                        " ao suspender, é necessário justificar o motivo da suspensão. O pagamento ficará com status de suspenso e poderá ser reintegrado ao fluxo de aprovação. Ao reintegrar, podem ser cobrados encargos adicionais.",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingSmall),
                Center(
                  child: PrimaryButton(
                    onPressed: () {},
                    width: 150,
                    text: "Recusar",
                    buttonColor: LelloTheme.palleteOf(theme).error(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.circle,
                        color: LelloTheme.palleteOf(theme).error(),
                        size: 12,
                      ),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Expanded(
                      child: _buildRichText(
                        theme,
                        "Recusar pagamentos:",
                        " ao recusar,  é necessário justificar o motivo do cancelamento. O pagamento ficará com status de cancelado e não poderá ser reintegrado.",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Entendi",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(ThemeData theme, String label, String value,
      {Color? color}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(color: color),
          ),
          TextSpan(
            text: value,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
        ],
      ),
    );
  }
}
