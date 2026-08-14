import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ComfortToYourCondoResultPage extends StatelessWidget {
  final bool isSucces;
  final VoidCallback? tryAgain;
  const ComfortToYourCondoResultPage({
    Key? key,
    required this.isSucces,
    this.tryAgain,
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
                      Text(_getText(context, isSucces),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.headline(theme)!
                              .copyWith(color: Colors.white)),
                      SizedBox(height: Dimens.spacingSmall),
                      Text(_getSubtitle(context, isSucces),
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
                        onPressed: (!isSucces && tryAgain != null)
                            ? () {
                                tryAgain!();
                                Navigator.pop(context);
                              }
                            : () {
                                Navigator.pop(context);
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

  String _getText(BuildContext context, bool approved) {
    String text = "";
    if (approved) {
      text = "Solicitação enviada com sucesso!";
    }
    if (!approved) {
      text = "Falha no envio da solicitação";
    }
    return text;
  }

  String _getSubtitle(BuildContext context, bool approved) {
    String text = "";
    if (approved) {
      text = "Em até dois dias úteis nosso concierge entrará em contato.";
    }
    if (!approved) {
      text = "Tente novamente mais tarde.";
    }
    return text;
  }
}
