import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:flutter/material.dart';

import 'package:essentials/essentials.dart';

class SyncFailedWidget extends StatelessWidget {
  final List<DigitalPointEntity> digitalPoints;
  final Function(List<DigitalPointEntity> digitalPoints) syncFunction;
  final String? message;
  const SyncFailedWidget({
    Key? key,
    required this.digitalPoints,
    required this.syncFunction,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/ic_attention.svg",
          color: LelloTheme.palleteOf(theme).grey(),
          height: 32.0,
          width: 32.0,
        ),
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, "digital_point_sync_dialog_failed_title"),
          textAlign: TextAlign.center,
          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          message != null
              ? "${getString(context, "digital_point_sync_dialog_failed_away_subtitle")} $message"
              : getString(context, "digital_point_sync_dialog_failed_subtitle"),
          textAlign: TextAlign.center,
          style: LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        if (digitalPoints.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  getString(context, "digital_point_date"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  getString(context, "digital_point_time"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: Dimens.spacing),
        if (digitalPoints.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                      digitalPoints.length,
                      (index) => Row(
                            children: [
                              Expanded(
                                child: Text(
                                  digitalPoints[index].dateFormatted,
                                  textAlign: TextAlign.center,
                                  style:
                                      LelloTextStyles.subtitle(theme)?.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).primary(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  digitalPoints[index].timeFormatted,
                                  textAlign: TextAlign.center,
                                  style:
                                      LelloTextStyles.subtitle(theme)?.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).primary(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            ),
          ),
        SizedBox(height: Dimens.spacing),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.spacingSmall),
            child: Text(
              getString(context, "ok").toUpperCase(),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).primary()),
            ),
          ),
        ),
      ],
    );
  }
}
