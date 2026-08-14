import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';

class AgreementsRejectedProposalBottom extends StatelessWidget {
  final Agreement agreement;
  const AgreementsRejectedProposalBottom({Key? key, required this.agreement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
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
              getString(
                  context,
                  agreement.status == "canceled_automatically"
                      ? 'rejected_proposal_title_automatically'
                      : 'rejected_proposal_title'),
              style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
            if (agreement.status == "canceled_automatically")
              _rejectedAutomatcalyMensage(theme, context),
            if (agreement.status != "canceled_automatically" &&
                agreement.reason != null &&
                agreement.reason != "")
              _rejectedMensage(theme, context),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, 'rejected_proposal_try_again_message'),
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
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

  _rejectedMensage(theme, context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, 'rejected_proposal_returned_following_message'),
          style: LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        Text(
          agreement.reason!,
          style: LelloTextStyles.subtitle(theme)?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  _rejectedAutomatcalyMensage(theme, context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, 'rejected_proposal_automatically_message'),
          style: LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
        ),
      ],
    );
  }
}
