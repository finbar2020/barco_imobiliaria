import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CndErrorDialog extends StatelessWidget {
  const CndErrorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = LelloTextStyles.subtitle(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).textLightest(),
    );

    final richText = _buildRichTextFromMarkedString(
        getString(context, "cnd_information"), textStyle);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
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
              "${getString(context, "chat_error_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            Text(
              getString(context, "cnd_unable_issue"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            richText,
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "later").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _openWhatsapp(context);
                  },
                  child: Row(children: [
                    SvgPicture.asset(
                      "assets/ic_whats_red.svg",
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(
                              context, "registration_lello_warning_no_data_btn")
                          .toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String message = "Oi, pode me ajudar?";
    Launch.whatsApp(context, FlavorConfig.config.supportMoradorWhatsAppNumber,
        message: message);
  }

  RichText _buildRichTextFromMarkedString(
      String markedString, TextStyle baseStyle) {
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final List<TextSpan> spans = [];

    int lastEnd = 0;

    for (final match in boldRegex.allMatches(markedString)) {
      final String beforeBold = markedString.substring(lastEnd, match.start);
      if (beforeBold.isNotEmpty) {
        spans.add(
          TextSpan(text: beforeBold),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastEnd = match.end;
    }

    final String afterLastBold = markedString.substring(lastEnd);
    if (afterLastBold.isNotEmpty) {
      spans.add(
        TextSpan(text: afterLastBold),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
