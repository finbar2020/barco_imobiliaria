import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';

class MailingCardWidget extends StatelessWidget {
  final Mailing model;
  const MailingCardWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      color: model.highlight ? theme.highlightColor : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, "mailing_received"),
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                  Text(
                    "${model.arrivalFullDate} ${getString(context, "mailing_received_at")} ${model.arrivalHourMinute}h",
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                ],
              )),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      color: color(model.status ?? "", theme),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Flexible(
                    child: Text(
                      "${getString(context, model.statusMailing)}",
                      overflow: TextOverflow.ellipsis,
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: color(model.status ?? "", theme),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            "${getString(context, "mailing_receiver")}: ${model.addressee ?? getString(context, "not_informed")}",
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.subBody(theme),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          Text(
            "${model.category} - ${model.size}",
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.subBody(theme),
          ),
          SizedBox(height: Dimens.spacingSmall),
          model.photo != null
              ? Icon(
                  Icons.photo_outlined,
                  color: LightPallete().grey(),
                )
              : Text(
                  getString(context, "mailing_without_attachment"),
                  style: LelloTextStyles.caption(theme)?.copyWith(
                    color: theme.disabledColor,
                  ),
                )
        ],
      ),
    );
  }

  Color color(String status, ThemeData theme) {
    switch (status) {
      case "PENDENTE":
        return LelloTheme.palleteOf(theme).warning();
      case "RETIRADA":
        return LelloTheme.palleteOf(theme).success();
      default:
        return LelloTheme.palleteOf(theme).customColor();
    }
  }
}
