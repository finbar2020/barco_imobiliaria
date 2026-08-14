import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';

class PartnerGeneralRatingWidget extends StatelessWidget {
  const PartnerGeneralRatingWidget({
    Key? key,
    required this.partner,
  }) : super(key: key);

  final ComfortPartner partner;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "comfort_ratings"),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Row(
            children: [
              RatingBarWidget(
                allowHalfRating: true,
                initValue: partner.rating,
              ),
              SizedBox(width: Dimens.spacingMedium),
              Flexible(
                child: Text(
                  getString(context, "comfort_ratings_total")
                      .replaceFirst("###", partner.ratingsNumber.toString()),
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: LelloTheme.palleteOf(theme).grey(),
                      color: LelloTheme.palleteOf(theme).grey()),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
        ],
      ),
    );
  }
}
