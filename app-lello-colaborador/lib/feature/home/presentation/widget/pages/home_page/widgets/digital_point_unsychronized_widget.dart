import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DigitalPointsUnsynchronizedWidget extends StatelessWidget {
  final List<DigitalPointEntity> digitalPoints;

  const DigitalPointsUnsynchronizedWidget({
    Key? key,
    required this.digitalPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "digital_point_sync_points_to_sync"),
            textAlign: TextAlign.left,
            style: LelloTextStyles.subtitle(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Row(
            children: [
              Expanded(
                child: Text(
                  getString(context, "digital_point_date"),
                  textAlign: TextAlign.left,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  getString(context, "digital_point_time"),
                  textAlign: TextAlign.left,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          ...List.generate(
              digitalPoints.length,
              (index) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          digitalPoints[index].dateFormatted,
                          textAlign: TextAlign.left,
                          style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          digitalPoints[index].timeFormatted,
                          textAlign: TextAlign.left,
                          style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                        ),
                      ),
                    ],
                  )),
        ],
      ),
    );
  }
}
