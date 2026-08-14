import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/dependency/application_container.dart';
import '../../../controllers/agreements_controller.dart';

class AgreementsDisapproveProposalBottomSheet extends StatefulWidget {
  final String agreementId;

  const AgreementsDisapproveProposalBottomSheet({
    Key? key,
    required this.agreementId,
  }) : super(key: key);

  @override
  AgreementsDisapproveProposalBottomSheetState createState() =>
      AgreementsDisapproveProposalBottomSheetState();
}

class AgreementsDisapproveProposalBottomSheetState
    extends State<AgreementsDisapproveProposalBottomSheet> {
  late TextEditingController textController;
  late String disapprovalText;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    disapprovalText = "";
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    ThemeData theme = Theme.of(context);
    textController.text = disapprovalText;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 800.0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimens.spacingLarge,
            Dimens.spacingLarge,
            Dimens.spacingLarge,
            MediaQuery.of(context).viewInsets.bottom + Dimens.spacingLarge),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "agreements_proposals_confirm_disapproval"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context,
                    "agreements_proposals_confirm_disapprove_description"),
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              SizedBox(
                height: 200.0,
                child: TextField(
                  controller: textController,
                  maxLength: 255,
                  maxLines: 10,
                  onChanged: (value) {
                    disapprovalText = value;
                  },
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelStyle: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight()),
                    border: const OutlineInputBorder(),
                    filled: true,
                    labelText:
                        getString(context, 'agreements_proposals_message'),
                    fillColor: Colors.white,
                    hintText:
                        getString(context, 'agreements_proposals_message'),
                    alignLabelWithHint: true,
                    hintStyle: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight()),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                    text: getString(context, "agreements_proposals_confirm"),
                    onPressed: () async {
                      Navigator.pop(context);
                      await controller.updateStatus(
                        agreementId: widget.agreementId,
                        approved: false,
                        reason: textController.text,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
