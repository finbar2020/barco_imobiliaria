import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AgreementsRecommendationCard extends StatelessWidget {
  final VoidCallback onPressed;
  final double totalValue;
  final String paymentTitle;
  final String formPaymentTitle;
  final String dueDateTitle;

  const AgreementsRecommendationCard(
      {Key? key,
      required this.paymentTitle,
      required this.formPaymentTitle,
      required this.dueDateTitle,
      required this.onPressed,
      required this.totalValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: LelloTheme.palleteOf(theme).customColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.primaryColor),
        ),
      ),
      onPressed: onPressed,
      child: cardBody(context),
    );
  }

  Widget cardBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimens.spacingMedium, horizontal: Dimens.spacingSmall),
        child: Row(
          children: [
            Expanded(
              flex: 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paymentTitle,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: theme.primaryColor,
                      )),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildColumn(
                                theme,
                                1,
                                getString(context, "form_of_payment"),
                                formPaymentTitle),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.spacingSmall,
                        ),
                        Row(
                          children: [
                            _buildColumn(
                                theme,
                                4,
                                getString(context, "expiration_date"),
                                dueDateTitle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: SvgPicture.asset(
                "assets/ic_arrow_right.svg",
                height: 20.0,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildColumn(
      ThemeData theme, int flex, String topText, String bottomText) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topText,
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textLight(),
            ),
          ),
          Text(
            bottomText,
            style: LelloTextStyles.subBody(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ],
      ),
    );
  }
}
