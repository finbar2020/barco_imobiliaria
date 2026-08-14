import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementsApprovedProposalBottom extends StatelessWidget {
  const AgreementsApprovedProposalBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 280.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              color: LelloTheme.palleteOf(theme).grey(),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
            Text(
              getString(context, 'approved_proposal_title'),
              style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, 'approved_proposal_message'),
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Container(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(
                        width: 1, color: LelloTheme.palleteOf(theme).text()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 23.0),
                    child: Text(
                      getString(context, "agreements_ok_understood_button"),
                      style: LelloTextStyles.button(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(height: Dimens.spacing),
          ],
        ),
      ),
    );
  }
}
