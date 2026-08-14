import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../domain/entity/legal_obligation_activity_history_entity.dart';
import '../../../domain/entity/legal_obligation_entity.dart';
import '../../../domain/entity/legal_obligation_status.dart';
import '../../../domain/repository/maintenance_management_repository.dart';
import '../widgets/legal_obligation_status_tag.dart';

class LegalObligationActivityHistoryPage extends StatefulWidget {
  final LegalObligationItemEntity item;
  final String obligationTypeValue;
  final String? listCategoryLabel;

  const LegalObligationActivityHistoryPage({
    super.key,
    required this.item,
    required this.obligationTypeValue,
    this.listCategoryLabel,
  });

  @override
  State<LegalObligationActivityHistoryPage> createState() =>
      _LegalObligationActivityHistoryPageState();
}

class _LegalObligationActivityHistoryPageState
    extends State<LegalObligationActivityHistoryPage> {
  late final Future<Try<LegalObligationActivityHistoryEntity>> _historyFuture;
  final _repository = ApplicationContainer.instance()
      .resolve<MaintenanceManagementRepository>();

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<Try<LegalObligationActivityHistoryEntity>> _loadHistory() {
    final id = widget.item.id?.trim();
    if (id == null || id.isEmpty) {
      return Future.value(
        Rejection(UnknownFailure('id inválido para histórico')),
      );
    }

    return _repository.getLegalObligationActivityHistory(
      id: id,
      type: widget.obligationTypeValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final status = _resolveStatus(widget.item.status);
    final categoryLabel = (widget.listCategoryLabel ??
            widget.item.documentType ??
            getString(context, 'legal_obligation_tab_condominium'))
        .toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.primary()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          getString(context, 'legal_obligation_activity_history_title'),
          style: LelloTextStyles.body(theme)?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 12.5),
                  child: Text(
                    categoryLabel,
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
              color: palette.separator(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildExpiration(context, theme),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description ?? widget.item.document ?? '-',
                    style: LelloTextStyles.titleSmallBold(theme),
                  ),
                  const SizedBox(height: 8),
                  _buildMetadataText(
                    context,
                    theme,
                    label: getString(context, 'legal_obligation_observations'),
                    value: _orDash(widget.item.observations),
                  ),
                  const SizedBox(height: 16),
                  _buildHistorySection(context, theme, palette),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiration(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${getString(context, 'legal_obligation_activity_history_expiration_label')}: ${_formatDate(widget.item.expirationDate)}',
            style: LelloTextStyles.subtitleBold(theme)?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataText(
    BuildContext context,
    ThemeData theme, {
    required String label,
    required String value,
  }) {
    final baseStyle = LelloTextStyles.subtitleBold(theme)!.copyWith(
      color: Colors.grey.shade700,
    );
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: '$label ',
            style: baseStyle,
          ),
          TextSpan(
            text: value,
            style: baseStyle.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
    List<LegalObligationActivityHistoryItemEntity> historyItems,
  ) {
    final responsibleLabel = _getResponsibleLabel(context);

    return Column(
      children: List.generate(historyItems.length, (index) {
        final historyItem = historyItems[index];
        final isLast = index == historyItems.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 18,
                child: Column(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: palette.routineBlue(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 1.5,
                        height: 50,
                        margin: const EdgeInsets.only(top: 3),
                        color: palette.routineBlue().withAlpha(100),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                          children: [
                            TextSpan(
                              text: '${_formatDateTime(historyItem.date)} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: _orDash(historyItem.description),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                          children: [
                            TextSpan(
                              text: '$responsibleLabel: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: _orDash(historyItem.responsible),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHistorySection(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return FutureBuilder<Try<LegalObligationActivityHistoryEntity>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        if (result == null) {
          return _buildHistoryFeedbackText(
            context,
            theme,
            'legal_obligation_activity_history_error',
          );
        }

        return result.fold(
          (_) => _buildHistoryFeedbackText(
            context,
            theme,
            'legal_obligation_activity_history_error',
          ),
          (history) {
            if (history.items.isEmpty) {
              return _buildHistoryFeedbackText(
                context,
                theme,
                'legal_obligation_activity_history_empty',
              );
            }
            return _buildTimeline(context, theme, palette, history.items);
          },
        );
      },
    );
  }

  Widget _buildHistoryFeedbackText(
    BuildContext context,
    ThemeData theme,
    String key,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        getString(context, key),
        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  LegalObligationStatus _resolveStatus(String? status) {
    final normalized =
        status?.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');

    return LegalObligationStatusExtension.fromApiValue(normalized) ??
        LegalObligationStatus.pendente;
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'dd/mm/aaaa';
    }

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _orDash(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return '-';
    return trimmed;
  }

  String _getResponsibleLabel(BuildContext context) {
    const key = 'legal_obligation_activity_history_responsible';
    final value = getString(context, key).trim();

    if (value.isEmpty || value == key) {
      return 'Responsável';
    }

    return value;
  }

  String _formatDateTime(String? value) {
    if (value == null || value.trim().isEmpty) return '-';

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
