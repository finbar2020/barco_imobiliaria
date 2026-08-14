import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ComfortCupomRequesResultPage extends StatelessWidget {
  final bool isSucces;
  final String title;
  final String subtitle;
  final VoidCallback? okAction;
  final VoidCallback? retryAction;

  const ComfortCupomRequesResultPage({
    Key? key,
    required this.isSucces,
    required this.title,
    required this.subtitle,
    this.okAction,
    this.retryAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: isSucces
            ? LelloTheme.palleteOf(theme).success()
            : LelloTheme.palleteOf(theme).warning(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getAsset(isSucces),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(title,
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.headline(theme)!
                              .copyWith(color: Colors.white)),
                      SizedBox(height: Dimens.spacingSmall),
                      Text(subtitle,
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.subtitle(theme)!
                              .copyWith(color: Colors.white)),
                      SizedBox(height: Dimens.spacingLarge),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Theme(
                      data: theme.copyWith(
                        textTheme: theme.textTheme.copyWith(
                            labelLarge: theme.textTheme.labelLarge
                                ?.copyWith(color: Colors.black)),
                      ),
                      child: PrimaryButton(
                        buttonColor: Colors.white,
                        text: isSucces
                            ? getString(context, "comfort_disfavor_conclude")
                            : getString(context, "try_again"),
                        onPressed: (!isSucces && retryAction != null)
                            ? () {
                                retryAction!();
                                Navigator.pop(context);
                              }
                            : () {
                                Navigator.pop(context);
                              },
                      ),
                    ),
                    if (!isSucces) SizedBox(height: Dimens.spacing),
                    if (!isSucces)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(width: 1, color: Colors.white),
                        ),
                        child: Container(
                          height: 54.0,
                          child: Center(
                            child: Text(getString(context, "cancel"),
                                style: LelloTextStyles.button(theme)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SvgPicture _getAsset(bool approved) {
    if (approved) {
      return SvgPicture.asset("assets/ic_success.svg", width: 92, height: 92);
    } else {
      return SvgPicture.asset("assets/ic_error.svg", width: 92, height: 92);
    }
  }
}
