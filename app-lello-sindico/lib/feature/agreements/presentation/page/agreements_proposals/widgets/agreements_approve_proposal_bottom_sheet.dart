import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/dependency/application_container.dart';
import '../../../controllers/agreements_controller.dart';

class AgreementsApproveProposalBottomSheet extends StatelessWidget {
  final String agreementId;

  const AgreementsApproveProposalBottomSheet({
    Key? key,
    required this.agreementId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    ThemeData theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400.0),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "agreements_proposals_confirm_approval"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context,
                    "agreements_proposals_confirm_approve_description"),
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: getString(context, "agreements_proposals_confirm"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.updateStatus(
                      agreementId: agreementId,
                      approved: true,
                      reason: null,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
