import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class HortaDialog extends StatelessWidget {
  final HortaRemoteConfigEntity horta;
  const HortaDialog({Key? key, required this.horta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/ic_horta_dialog.svg"),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "horta_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "horta_subtitle"),
              textAlign: TextAlign.center,
              style:
                  LelloTextStyles.subBody(theme)!.copyWith(color: Colors.black),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "horta_description"),
              textAlign: TextAlign.center,
              style:
                  LelloTextStyles.subBody(theme)!.copyWith(color: Colors.black),
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: horta.cupom ?? ""))
                    .then((value) {
                  return Flushbar(
                    duration: Duration(seconds: 3),
                    message: getString(context, "horta_cupom_copied"),
                  )..show(context);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    horta.cupom ?? "",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: Dimens.spacing),
                  Icon(Icons.copy),
                ],
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
                text: getString(context, "horta_button"),
                onPressed: () {
                  if (horta.link != null) {
                    launchUrl(Uri.parse(horta.link!));
                  }
                }),
            SizedBox(height: Dimens.spacingSmall),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  getString(context, "later").toUpperCase(),
                  style: LelloTextStyles.subBody(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
