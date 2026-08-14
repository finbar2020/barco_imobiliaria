import 'package:flutter/material.dart';

import 'package:essentials/essentials.dart';

class DeviceTypeDialog extends StatelessWidget {
  final bool onlyTablet;
  final bool onlyPhone;

  const DeviceTypeDialog({
    Key? key,
    required this.onlyTablet,
    required this.onlyPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      child: SizedBox(
        width: size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset("assets/ic_billet_alert.svg"),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "digital_point_sync_dialog_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              if (onlyPhone)
                Text(
                  "${getString(context, "digital_point_device_type_failure_tablet")} ",
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                  textAlign: TextAlign.center,
                ),
              if (onlyTablet)
                Text(
                  "${getString(context, "digital_point_device_type_failure_phone")} ",
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: Dimens.spacing),
              if (onlyTablet)
                Text(
                  "${getString(context, "digital_point_device_type_failure_tablet_subtitle")} ",
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                  textAlign: TextAlign.center,
                ),
              if (onlyPhone)
                Text(
                  "${getString(context, "digital_point_device_type_failure_phone_subtitle")} ",
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: Dimens.spacing),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Text(
                    getString(context, "ok"),
                    style: LelloTextStyles.subBody(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).primary(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
