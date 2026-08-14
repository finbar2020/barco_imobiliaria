import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

/// Empty state exibido quando a API de obrigações legais não retorna dados.
/// Permite ao síndico notificar o parceiro responsável (envio de e-mail por filial).
class LegalObligationNotifyPartnerEmptyState extends StatelessWidget {
  /// Indica se a notificação já foi enviada nesta sessão.
  /// Quando `true`, o botão fica desabilitado e o tooltip "já enviado" aparece fixo abaixo.
  final bool alreadyNotified;

  /// Indica se há uma requisição em andamento. Bloqueia novos toques e mostra loader no botão.
  final bool isSending;

  /// Callback acionado ao tocar em "Notificar parceiro" enquanto habilitado.
  final VoidCallback onNotifyPressed;

  const LegalObligationNotifyPartnerEmptyState({
    super.key,
    required this.alreadyNotified,
    required this.onNotifyPressed,
    this.isSending = false,
  });

  static const _disabledBackgroundColor = Color(0xFFBEBEBE);
  static const _disabledForegroundColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final isDisabled = alreadyNotified || isSending;
    final buttonLabel = getString(
      context,
      'legal_obligation_notify_partner_button',
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spacing,
        vertical: Dimens.spacingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            getString(
              context,
              'legal_obligation_notify_partner_empty_title',
            ),
            textAlign: TextAlign.center,
            style: LelloTextStyles.titleSmallBold(theme)?.copyWith(
              color: palette.text(),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Text(
            getString(
              context,
              'legal_obligation_notify_partner_empty_description',
            ),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: isDisabled
                ? _buildDisabledButton(theme, buttonLabel)
                : PrimaryButton(
                    theme: theme,
                    buttonColor: palette.primary(),
                    onPressed: onNotifyPressed,
                    text: buttonLabel,
                  ),
          ),
          if (alreadyNotified) ...[
            SizedBox(height: Dimens.spacingSmall),
            _AlreadyNotifiedTooltip(theme: theme, palette: palette),
          ],
        ],
      ),
    );
  }

  Widget _buildDisabledButton(ThemeData theme, String label) {
    return Container(
      decoration: BoxDecoration(
        color: _disabledBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: isSending
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _disabledForegroundColor,
              ),
            )
          : Text(
              label,
              style: LelloTextStyles.button(theme)?.copyWith(
                color: _disabledForegroundColor,
              ),
            ),
    );
  }
}

class _AlreadyNotifiedTooltip extends StatelessWidget {
  final ThemeData theme;
  final ColorPallete palette;

  const _AlreadyNotifiedTooltip({
    required this.theme,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final background = palette.routineBlue().withAlpha(25);
    final borderColor = palette.routineBlue().withAlpha(80);
    final iconColor = palette.routineBlue();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              getString(
                context,
                'legal_obligation_notify_partner_already_sent_tooltip',
              ),
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.text(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
