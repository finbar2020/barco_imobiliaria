import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/dimens.dart';
import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BellaDocumentMessage extends StatelessWidget {
  final String documentName;
  final bool? isDownloading;
  final bool? isRendering;
  final Function()? onDownloadPressed;
  final Function()? onVisualizePressed;

  BellaDocumentMessage({
    required this.documentName,
    this.onDownloadPressed,
    this.onVisualizePressed,
    this.isDownloading = false,
    this.isRendering = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/ic_bella_profile.svg',
              width: 40,
              height: 40,
              theme: SvgTheme(
                currentColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LelloTheme.palleteOf(theme).greyCard(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(12),
              ),
            ),
            child: ListTile(
              leading: SvgPicture.asset("assets/ic_pdf_document.svg",
                  width: 40, height: 40),
              title: Text(
                documentName,
                style: LelloTextStyles.body(theme)!,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "10MB",
                    style: LelloTextStyles.caption(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: isDownloading == true ? "" : "Baixar",
                          onPressed:
                              isDownloading == true ? null : onDownloadPressed,
                          height: 30,
                          child: isDownloading == true
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: Dimens.spacingSmall),
                      Expanded(
                        child: InvertedPrimaryButton(
                          text: isRendering == true ? "" : "Visualizar",
                          onPressed:
                              isRendering == true ? null : onVisualizePressed,
                          height: 30,
                          child: isRendering == true
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
