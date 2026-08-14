import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:shared_features/shared_features.dart';

class AgreementsStatusChangedSuccessPage extends StatelessWidget {
  const AgreementsStatusChangedSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool approved = false;
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    if (arguments.isNotEmpty) {
      approved = arguments.first;
    }
    if (arguments.isEmpty) {
      Navigator.pop(context);
    }

    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: _getColor(approved, theme),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getAsset(approved),
                SizedBox(height: Dimens.spacingLarge),
                Text(_getText(context, approved),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingSmall),
                Text(getString(context, "agreements_proposals_success_message"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                    buttonColor: Colors.white,
                    text: getString(context, "back"),
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(SharedApplicationRoute.home),
                      );
                      Navigator.pushNamed(
                        context,
                        ApplicationRoute.agreements,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(bool approved, ThemeData theme) {
    return approved
        ? LelloTheme.palleteOf(theme).success()
        : LelloTheme.palleteOf(theme).accent();
  }

  String _getText(BuildContext context, bool approved) {
    String text = "";
    if (approved) {
      text = getString(context, "agreements_proposals_agreement_approved");
    }
    if (!approved) {
      text = getString(context, "agreements_proposals_agreement_disapproved");
    }
    return text;
  }

  SvgPicture _getAsset(bool approved) {
    if (approved) {
      return SvgPicture.asset("assets/ic_success.svg", width: 92, height: 92);
    } else {
      return SvgPicture.asset("assets/ic_error.svg", width: 92, height: 92);
    }
  }
}
