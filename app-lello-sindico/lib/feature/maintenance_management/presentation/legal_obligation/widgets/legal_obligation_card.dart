import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entity/legal_obligation_entity.dart';
import '../../../domain/entity/legal_obligation_status.dart';
import 'legal_obligation_status_tag.dart';

class LegalObligationCard extends StatelessWidget {
  final LegalObligationItemEntity item;

  /// Só preenchido na aba Condomínio (`CONDOMÍNIO`); caso contrário usa `documentType`.
  final String? listCategoryLabel;
  final VoidCallback? onSeeDetails;

  const LegalObligationCard({
    super.key,
    required this.item,
    this.listCategoryLabel,
    this.onSeeDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final status = _resolveStatus(item.status);
    final showInfo = status == LegalObligationStatus.emAnalise ||
        status == LegalObligationStatus.recusado;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        side: BorderSide(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 12.5),
                child: Text(
                  (listCategoryLabel ?? item.documentType ?? '-').toUpperCase(),
                  style: LelloTextStyles.caption(theme)?.copyWith(
                    color: Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              LegalObligationStatusTag(
                status: status,
                theme: theme,
                label: getString(context, status.statusLabelKey),
              ),
            ],
          ),
          Divider(
              height: Dimens.spacing,
              thickness: 1,
              color: Colors.grey.shade300),
          SizedBox(height: Dimens.spacingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.description ?? item.document ?? '-',
              style: LelloTextStyles.titleSmallBold(theme),
            ),
          ),
          if (showInfo) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildInfoBanner(context, theme, item),
            ),
          ],
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: Dimens.spacing, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${getString(context, 'legal_obligation_expiration')} ${_formatExpirationDate(item.expirationDate)}',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: 40,
                    child: PrimaryButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      theme: theme,
                      buttonColor: palette.secondary(),
                      onPressed: onSeeDetails ?? () {},
                      text: getString(context, 'legal_obligation_see_details'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LegalObligationStatus _resolveStatus(String? status) {
    final normalized =
        status?.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');

    return LegalObligationStatusExtension.fromApiValue(normalized) ??
        LegalObligationStatus.pendente;
  }

  Widget _buildInfoBanner(
    BuildContext context,
    ThemeData theme,
    LegalObligationItemEntity item,
  ) {
    final palette = LelloTheme.palleteOf(theme);
    final background = palette.routineBlue().withAlpha(25);
    final statusTooltip = item.statusTooltip?.trim();
    final submittedByName = item.submittedByName?.trim();
    final infoText = (statusTooltip != null && statusTooltip.isNotEmpty)
        ? statusTooltip
        : (submittedByName != null && submittedByName.isNotEmpty)
            ? getStringWithParams(
                context,
                'legal_obligation_document_sent_by_name',
                [submittedByName],
              )
            : getString(
                context,
                'legal_obligation_document_sent_by_user',
                defaultText: 'Este documento foi enviado pelo usuário.',
              );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.routineBlue().withAlpha(70)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/ic_info_blue.svg',
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              infoText,
              style: LelloTextStyles.caption(theme)?.copyWith(
                color: palette.routineBlue(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatExpirationDate(String? value) {
    if (value == null || value.isEmpty) return '-';

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
