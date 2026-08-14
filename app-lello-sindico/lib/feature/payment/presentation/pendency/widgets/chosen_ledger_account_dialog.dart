import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/accounting_account_type.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';

class ChosenLedgerAccountDialog extends StatefulWidget {
  final LedgerAccountEntity ledgerAccount;
  final LedgerAccountType ledgerAccountType;
  final Function() onConfirm;
  final Function() onCancel;
  const ChosenLedgerAccountDialog(
      {super.key,
      required this.ledgerAccountType,
      required this.ledgerAccount,
      required this.onConfirm,
      required this.onCancel});

  @override
  State<ChosenLedgerAccountDialog> createState() =>
      _ChosenLedgerAccountDialogState();
}

class _ChosenLedgerAccountDialogState extends State<ChosenLedgerAccountDialog> {
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Você escolheu a conta ",
                style: LelloTextStyles.subtitleBold(theme),
                children: [
                  TextSpan(
                    text:
                        '${widget.ledgerAccount.shortCode} - ${widget.ledgerAccount.name}',
                    style: LelloTextStyles.subtitleBold(theme)!
                        .copyWith(color: theme.primaryColor),
                  ),
                  TextSpan(
                      text: ' do tipo ',
                      style: LelloTextStyles.subtitleBold(theme)),
                  TextSpan(
                    text: ledgerAccountTypeToString(widget.ledgerAccountType)
                        .toUpperCase(),
                    style: LelloTextStyles.subtitleBold(theme)!
                        .copyWith(color: theme.primaryColor),
                  ),
                  TextSpan(
                      text: '.', style: LelloTextStyles.subtitleBold(theme)),
                ],
              ),
            ),
            Text(
              'Você tem certeza que deseja salvar?',
              style: LelloTextStyles.subtitleBold(theme),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: widget.onConfirm,
              text: 'Sim, salvar',
              buttonColor: theme.primaryColor,
            ),
            SizedBox(height: Dimens.spacingSmall),
            InvertedPrimaryButton(
              onPressed: widget.onCancel,
              text: 'Não, voltar',
              buttonColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
