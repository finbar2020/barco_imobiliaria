import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResinAttentionPageArgs {
  final String subtitle;

  ResinAttentionPageArgs({required this.subtitle});
}

class ResinAttentionPage extends StatelessWidget {
  const ResinAttentionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtitle;
    ThemeData theme = Theme.of(context);
    ResinAttentionPageArgs args =
        ModalRoute.of(context)?.settings.arguments as ResinAttentionPageArgs;
    subtitle = args.subtitle;
    return Scaffold(
      backgroundColor: LelloTheme.palleteOf(theme).warning(),
      body: Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/ic_warning.svg", width: 92, height: 92),
              SizedBox(height: Dimens.spacingLarge),
              Text(getString(context, "advance_request_warning_title"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.title(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).background())),
              SizedBox(height: Dimens.spacingLarge),
              _showSubtitle(context, subtitle, theme),
              SizedBox(height: Dimens.spacingLarge),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LelloTheme.palleteOf(theme).background(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Container(
                  height: 54.0,
                  child: Center(
                    child: Text(getString(context, "ok"),
                        style: LelloTextStyles.button(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).overlay(),
                        )),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showSubtitle(BuildContext context, String subtitle, ThemeData theme) {
    String text = getString(context, subtitle);
    if (text.isNotEmpty) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: LelloTextStyles.body(theme)
            ?.copyWith(color: LelloTheme.palleteOf(theme).background()),
      );
    } else {
      return Text(
        subtitle,
        textAlign: TextAlign.center,
        style: LelloTextStyles.body(theme)
            ?.copyWith(color: LelloTheme.palleteOf(theme).background()),
      );
    }
  }
}
