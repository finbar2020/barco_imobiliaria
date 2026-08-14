import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class TdbRedirectDialog extends StatefulWidget {
  const TdbRedirectDialog({
    Key? key,
    required this.confirmationButtonFunction,
  }) : super(key: key);

  final VoidCallback confirmationButtonFunction;

  @override
  _TdbRedirectDialogState createState() => _TdbRedirectDialogState();
}

class _TdbRedirectDialogState extends State<TdbRedirectDialog> {
  bool isChecked = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/tdb_ok.svg",
                  height: 40.0,
                  width: 40.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                "${getString(context, "tdb_dialog_almost_there")}",
                textAlign: TextAlign.left,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                "${getString(context, "tdb_dialog_description")}",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                        value: isChecked,
                        activeColor: LelloTheme.palleteOf(theme).accent(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        side: BorderSide(
                          width: 1.0,
                          color: LelloTheme.palleteOf(theme).separator(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        }),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        UrlLauncherNative.openUrl(UrlsUri.lgpd().toString());
                      },
                      child: RichText(
                        text: TextSpan(
                          style: LelloTextStyles.body(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest(),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  getString(context, "tdb_dialog_checkbox_one"),
                            ),
                            TextSpan(
                              text:
                                  getString(context, "tdb_dialog_checkbox_two"),
                              style: LelloTextStyles.body(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).textAccent(),
                              ),
                            ),
                            TextSpan(
                              text: getString(
                                  context, "tdb_dialog_checkbox_three"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingLarge),
              InkWell(
                onTap: () {
                  if (isChecked) {
                    widget.confirmationButtonFunction();
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(Dimens.spacingSmall),
                  child: Text(
                    getString(context, "tdb_dialog_go_to_page"),
                    style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                      color: isChecked
                          ? theme.primaryColor
                          : LelloTheme.palleteOf(theme).separator(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }
}
