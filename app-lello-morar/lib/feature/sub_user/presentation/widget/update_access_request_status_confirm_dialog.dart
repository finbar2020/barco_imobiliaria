import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../pages/pending_requests/pending_requests_enum.dart';

class UpdateAccessRequestStatusConfirmDialog extends StatelessWidget {
  const UpdateAccessRequestStatusConfirmDialog({
    required this.name,
    required this.type,
    required this.onConfirm,
    required this.origin,
    required this.status,
    Key? key,
  }) : super(key: key);

  final String name;
  final String type;
  final RegistrationOrigin origin;
  final VoidCallback onConfirm;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status == 'REPROVADA_PROPRIETARIO'
                    ? 'Você tem certeza que deseja bloquear'
                    : 'Você tem certeza que deseja aprovar',
                textAlign: TextAlign.center,
                style: LelloTextStyles.bodyBold(theme),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                textAlign: TextAlign.center,
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Text(
                    'Como ',
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  Text(
                    type,
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.bodyBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).primary(),
                    ),
                  ),
                  Text(
                    ' da sua unidade?',
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                status == 'REPROVADA_PROPRIETARIO'
                    ? origin == RegistrationOrigin.changeOfOwnership
                        ? S
                            .of(context)
                            .changeAccessRequestStatusToBlockedMessage
                        : 'Ele não terá acesso até que seja desbloqueado manualmente.'
                    : origin == RegistrationOrigin.changeOfOwnership
                        ? S.of(context).changeOfOwnershipMessage
                        : S.of(context).accessRequestApproveConfirmationMessage,
                textAlign: TextAlign.center,
                maxLines: 6,
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                buttonColor: status == 'REPROVADA_PROPRIETARIO'
                    ? LelloTheme.palleteOf(theme).primary()
                    : LelloTheme.palleteOf(theme).success(),
                text: status == 'REPROVADA_PROPRIETARIO'
                    ? 'Sim, bloquear'
                    : 'Sim, aprovar',
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Não, quero voltar',
                buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
              ),
            ],
          )),
    );
  }
}
