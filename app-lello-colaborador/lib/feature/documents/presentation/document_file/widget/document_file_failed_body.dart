import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DocumentFileFailedBody extends StatelessWidget {
  const DocumentFileFailedBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimens.spacingMedium),
      color: LelloTheme.palleteOf(theme).warning(),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/ic_attention.svg", width: 92, height: 92),
            SizedBox(height: Dimens.spacingLarge),
            Text(
              getString(context, "document_file_page_error_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.headline(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).background(),
              ),
            ),
            SizedBox(height: Dimens.spacingXSmall),
            Text(
              getString(context, "document_file_page_error_description"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).background(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
                buttonColor: LelloTheme.palleteOf(theme).background(),
                child: Text(
                  getString(context, "back"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.button(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
