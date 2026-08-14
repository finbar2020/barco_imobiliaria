import 'dart:ui' as ui;

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../../../../core/navigation/application_route.dart';
import '../../../domain/entity/legal_obligation_entity.dart';
import '../../../domain/entity/legal_obligation_status.dart';
import '../bloc/legal_obligation_bloc.dart';
import '../bloc/legal_obligation_event.dart';
import '../bloc/legal_obligation_state.dart';
import '../enums/legal_obligation_tab.dart';
import '../../shared/widgets/simple_tooltip_widget.dart';
import '../enums/legal_obligation_detail_action.dart';
import '../widgets/legal_obligation_help_bottom_sheet.dart';
import '../widgets/legal_obligation_send_new_document_bottom_sheet.dart';
import '../widgets/legal_obligation_partner_renewal_confirmation_modal.dart';
import '../widgets/legal_obligation_partner_renewal_failure_modal.dart';
import '../widgets/legal_obligation_partner_renewal_success_modal.dart';
import '../widgets/legal_obligation_status_tag.dart';

enum _PartnerRenewalTooltipType {
  none,
  requested,
  recentlyRequested,
}

class _PartnerRenewalCachedState {
  final _PartnerRenewalTooltipType tooltipType;
  final DateTime savedAt;

  const _PartnerRenewalCachedState({
    required this.tooltipType,
    required this.savedAt,
  });
}

class LegalObligationDetailPage extends StatefulWidget {
  final LegalObligationItemEntity item;

  /// Só na aba Condomínio: mesmo título da lista (`CONDOMÍNIO`); senão usa `documentType`.
  final String? listCategoryLabel;

  /// Valor a ser enviado como `type` no endpoint de download.
  /// Deve ser um dos: CONDOMINIUM, EMPLOYEE, TECHNICAL_INSPECTION.
  final String obligationTypeValue;

  const LegalObligationDetailPage({
    super.key,
    required this.item,
    required this.obligationTypeValue,
    this.listCategoryLabel,
  });

  @override
  State<LegalObligationDetailPage> createState() =>
      _LegalObligationDetailPageState();
}

class _LegalObligationDetailPageState extends State<LegalObligationDetailPage> {
  final bloc = ApplicationContainer.instance().resolve<LegalObligationBloc>();
  static const String _partnerRenewalCachePrefix =
      'legal_obligation_partner_renewal_state_v1';
  static const Duration _partnerRenewalCacheTtl = Duration(days: 3);

  late LegalObligationItemEntity _currentItem;
  bool _isRefreshingAfterUpload = false;

  _PartnerRenewalTooltipType _partnerRenewalTooltipType =
      _PartnerRenewalTooltipType.none;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _restorePartnerRenewalTooltipState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final item = _currentItem;
    final status = _resolveStatus(item.status);
    final statusTooltip = item.statusTooltip?.trim();
    final hasStatusTooltip = statusTooltip != null && statusTooltip.isNotEmpty;
    final actions = LegalObligationDetailActionExtension.fromApiValues(
      item.availableActions,
    );

    final hasDownload =
        actions.contains(LegalObligationDetailAction.downloadFile);
    final obligationId = item.id;
    final canDownload =
        hasDownload && obligationId != null && obligationId.trim().isNotEmpty;

    return BlocListener<LegalObligationBloc, LegalObligationState>(
      bloc: bloc,
      listener: (context, state) async {
        if (state is LegalObligationLoadedState) {
          _updateItemAfterRefresh(state);
        } else if (state is LegalObligationDownloadSuccessState) {
          await OpenFile.open(state.file.path);
        } else if (state is LegalObligationDownloadErrorState) {
          if (!context.mounted) return;
          await _showDocumentWarning(
            context,
            _resolveDocumentWarningMessage(context, state.message),
          );
        } else if (state is LegalObligationUploadSuccessState) {
          if (!context.mounted) return;
          await GenericSuccessBottomSheet.show<void>(
            context,
            isDismissible: false,
            enableDrag: false,
            message: getString(context, 'legal_obligation_upload_success'),
          );
          if (!context.mounted) return;
          _refreshObligationData();
        } else if (state is LegalObligationUploadErrorState) {
          if (!context.mounted) return;
          await _showDocumentError(
            context,
            _resolveDocumentWarningMessage(context, state.message),
          );
        } else if (state is LegalObligationPartnerRenewalSuccessState) {
          if (!context.mounted) return;
          await LegalObligationPartnerRenewalSuccessModal.show(context);
          await _setPartnerRenewalTooltipType(
            _PartnerRenewalTooltipType.requested,
          );
        } else if (state is LegalObligationPartnerRenewalErrorState) {
          if (_isAlreadyRequestedPartnerRenewal(state.message)) {
            await _setPartnerRenewalTooltipType(
              _PartnerRenewalTooltipType.recentlyRequested,
            );
            return;
          }

          if (!context.mounted) return;
          await LegalObligationPartnerRenewalFailureModal.show(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, 'legal_obligation_detail_title'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                splashRadius: 20,
                onPressed: () => LegalObligationHelpBottomSheet.show(context),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (hasStatusTooltip)
              Container(
                width: double.infinity,
                color: palette.raffle(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/ic_info_white.svg',
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        statusTooltip,
                        style: LelloTextStyles.caption(theme)?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 12.5),
                          child: Text(
                            (widget.listCategoryLabel ??
                                    item.documentType ??
                                    getString(context,
                                        'legal_obligation_tab_condominium'))
                                .toUpperCase(),
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
                          _buildMetadataText(
                            theme,
                            label: getString(
                                context, 'legal_obligation_expiration'),
                            value: _formatDate(item.expirationDate),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description ?? item.document ?? '-',
                            style: LelloTextStyles.titleSmallBold(theme),
                          ),
                          const SizedBox(height: 8),
                          _buildMetadataText(
                            theme,
                            label: getString(
                                context, 'legal_obligation_last_alert'),
                            value: _formatDate(item.lastNotificationDate),
                          ),
                          const SizedBox(height: 6),
                          _buildMetadataText(
                            theme,
                            label: getString(
                                context, 'legal_obligation_observations'),
                            value: _orDash(item.observations),
                          ),
                          if (canDownload) ...[
                            const SizedBox(height: 16),
                            _buildDownloadLink(context, theme, palette,
                                obligationId, widget.obligationTypeValue),
                          ],
                          if (hasStatusTooltip) ...[
                            const SizedBox(height: 10),
                            _buildInlineTooltip(theme, statusTooltip),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: actions.isEmpty
            ? null
            : _buildBottomActions(context, theme, actions),
      ),
    );
  }

  Widget _buildDownloadLink(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
    String id,
    String type,
  ) {
    return BlocBuilder<LegalObligationBloc, LegalObligationState>(
      bloc: bloc,
      buildWhen: (prev, curr) =>
          curr is LegalObligationDownloadingFileState ||
          curr is LegalObligationDownloadSuccessState ||
          curr is LegalObligationDownloadErrorState,
      builder: (context, state) {
        final isLoading = state is LegalObligationDownloadingFileState;

        return InkWell(
          onTap: isLoading
              ? null
              : () => bloc.add(
                    LegalObligationDownloadFileEvent(id: id, type: type),
                  ),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.routineBlue(),
                    ),
                  )
                else
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 18,
                    color: palette.routineBlue(),
                  ),
                const SizedBox(width: 8),
                Text(
                  getString(context, 'legal_obligation_action_download_file'),
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: palette.routineBlue(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetadataText(
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

  Widget _buildInlineTooltip(ThemeData theme, String tooltip) {
    final palette = LelloTheme.palleteOf(theme);

    return SimpleTooltipWidget(
      message: tooltip,
      icon: Icons.info_outline,
      borderRadius: BorderRadius.circular(4),
      backgroundColor: palette.routineBlue().withAlpha(20),
      borderColor: palette.routineBlue().withAlpha(70),
      iconBackgroundColor: palette.routineBlue(),
      textColor: palette.routineBlue(),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    ThemeData theme,
    List<LegalObligationDetailAction> actions,
  ) {
    final palette = LelloTheme.palleteOf(theme);

    // downloadFile é mostrado inline — não exibir no rodapé
    final bottomActions = actions
        .where((a) => a != LegalObligationDetailAction.downloadFile)
        .toList();

    if (bottomActions.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in bottomActions) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildActionButton(context, theme, palette, action),
              ),
              if (action == LegalObligationDetailAction.requestPartnerRenewal &&
                  _partnerRenewalTooltipType != _PartnerRenewalTooltipType.none)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildPartnerRenewalRequestedTooltip(palette),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _actionLabel(
      BuildContext context, LegalObligationDetailAction action) {
    switch (action) {
      case LegalObligationDetailAction.sendNewDocument:
        return getString(context, action.labelKey);
      case LegalObligationDetailAction.requestPartnerRenewal:
        return getString(context, action.labelKey);
      case LegalObligationDetailAction.viewHistory:
        return getString(context, action.labelKey);
      case LegalObligationDetailAction.downloadFile:
        return getString(context, action.labelKey);
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
    LegalObligationDetailAction action,
  ) {
    final label = _actionLabel(context, action);
    final blackColor = Colors.black;

    switch (action) {
      case LegalObligationDetailAction.sendNewDocument:
        return SizedBox(
          width: double.infinity,
          child: BlocBuilder<LegalObligationBloc, LegalObligationState>(
            bloc: bloc,
            buildWhen: (prev, curr) =>
                curr is LegalObligationUploadingFileState ||
                curr is LegalObligationUploadSuccessState ||
                curr is LegalObligationUploadErrorState,
            builder: (context, state) {
              final isUploading = state is LegalObligationUploadingFileState;
              return PrimaryButton(
                theme: theme,
                height: 44,
                onPressed: isUploading
                    ? null
                    : () async {
                        final result =
                            await LegalObligationSendNewDocumentBottomSheet
                                .show(
                          context,
                          initialExpirationDate:
                              _parseDate(_currentItem.expirationDate),
                        );
                        if (result == null) return;
                        final obligationId = _currentItem.id;
                        if (obligationId == null ||
                            obligationId.trim().isEmpty) {
                          await _showDocumentError(
                            context,
                            getString(context,
                                'legal_obligation_document_warning_not_found'),
                          );
                          return;
                        }
                        final condoId = ApplicationContainer.instance()
                                .resolve<SessionBloc>()
                                .state
                                .session
                                ?.selectedCondominium
                                ?.id ??
                            '';
                        if (condoId.isEmpty) {
                          await _showDocumentError(
                            context,
                            getString(
                              context,
                              'legal_obligation_document_warning_partner_integration',
                            ),
                          );
                          return;
                        }
                        bloc.add(LegalObligationUploadFileEvent(
                          file: result.file,
                          expirationDate: result.expirationDate,
                          obligationId: obligationId,
                          obligationType: widget.obligationTypeValue,
                          condoId: condoId,
                        ));
                      },
                buttonColor: palette.primary(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUploading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      SvgPicture.asset(
                        'assets/ic_upload_arrow.svg',
                        width: 16,
                        height: 16,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: LelloTextStyles.button(theme)?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      case LegalObligationDetailAction.requestPartnerRenewal:
        return SizedBox(
          width: double.infinity,
          child: BlocBuilder<LegalObligationBloc, LegalObligationState>(
            bloc: bloc,
            buildWhen: (prev, curr) =>
                curr is LegalObligationRequestingPartnerRenewalState ||
                curr is LegalObligationPartnerRenewalSuccessState ||
                curr is LegalObligationPartnerRenewalErrorState,
            builder: (context, state) {
              final isRequesting =
                  state is LegalObligationRequestingPartnerRenewalState;
              final isDisabled =
                  _partnerRenewalTooltipType != _PartnerRenewalTooltipType.none;
              const disabledBackgroundColor = Color(0xFFBEBEBE);
              final actionColor =
                  isDisabled ? const Color(0xFFF5F5F5) : blackColor;

              if (isDisabled) {
                return Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: disabledBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: disabledBackgroundColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/ic_refresh.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(actionColor, ui.BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: LelloTextStyles.button(theme)?.copyWith(
                          color: actionColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SecondaryButton(
                height: 44,
                onPressed: isRequesting
                    ? null
                    : () async {
                        final confirmed =
                            await LegalObligationPartnerRenewalConfirmationModal
                                .show(context);

                        if (confirmed != true || !mounted) return;

                        final obligationId = _currentItem.id;
                        if (obligationId == null ||
                            obligationId.trim().isEmpty) {
                          await LegalObligationPartnerRenewalFailureModal.show(
                            context,
                          );
                          return;
                        }

                        bloc.add(
                          LegalObligationRequestPartnerRenewalEvent(
                            type: widget.obligationTypeValue,
                            id: obligationId,
                          ),
                        );
                      },
                buttonBorderColor: actionColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isRequesting)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: actionColor,
                        ),
                      )
                    else
                      SvgPicture.asset(
                        'assets/ic_refresh.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(actionColor, ui.BlendMode.srcIn),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: LelloTextStyles.button(theme)?.copyWith(
                        color: actionColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      case LegalObligationDetailAction.viewHistory:
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ApplicationRoute
                  .maintenanceManagementLegalObligationActivityHistory,
              arguments: {
                'item': _currentItem,
                'listCategoryLabel': widget.listCategoryLabel,
                'obligationTypeValue': widget.obligationTypeValue,
              },
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO: Solicitar ícone SVG vetorizado sem ser uma imagem chumbada para o ui/ux e trocar
                Image.asset(
                  'assets/ic_history_arrow.png',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: LelloTextStyles.button(theme)?.copyWith(
                    color: blackColor,
                  ),
                ),
              ],
            ),
          ),
        );
      case LegalObligationDetailAction.downloadFile:
        // Renderizado inline no body, não no rodapé
        return const SizedBox.shrink();
    }
  }

  Widget _buildPartnerRenewalRequestedTooltip(ColorPallete palette) {
    final isRecentlyRequested = _partnerRenewalTooltipType ==
        _PartnerRenewalTooltipType.recentlyRequested;
    final titleKey = isRecentlyRequested
        ? 'legal_obligation_partner_renewal_recently_requested_tooltip_title'
        : 'legal_obligation_partner_renewal_requested_tooltip_title';
    final messageKey = isRecentlyRequested
        ? 'legal_obligation_partner_renewal_recently_requested_tooltip_description'
        : 'legal_obligation_partner_renewal_requested_tooltip_description';

    const tooltipBlue = Color(0xFF2F80ED);
    return SimpleTooltipWidget(
      icon: Icons.priority_high,
      title: getString(context, titleKey),
      message: getString(context, messageKey),
      backgroundColor: tooltipBlue.withAlpha(20),
      borderColor: tooltipBlue,
      iconBackgroundColor: tooltipBlue,
      textColor: palette.routineBlue(),
      titleStyle: const TextStyle(
        fontFamily: 'Anek Latin',
        fontWeight: FontWeight.w600,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0,
      ),
      messageStyle: const TextStyle(
        fontFamily: 'Anek Latin',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0,
      ),
      iconTopOffset: 8,
    );
  }

  LegalObligationStatus _resolveStatus(String? status) {
    final normalized =
        status?.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');

    return LegalObligationStatusExtension.fromApiValue(normalized) ??
        LegalObligationStatus.pendente;
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) return '-';

    final date = _parseDate(value);
    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }

  Future<void> _showDocumentWarning(BuildContext context, String message) {
    return GenericWarningBottomSheet.show<void>(
      context,
      isDismissible: false,
      enableDrag: false,
      message: message,
    );
  }

  Future<void> _showDocumentError(BuildContext context, String message) {
    return GenericErrorBottomSheet.show<void>(
      context,
      isDismissible: false,
      enableDrag: false,
      message: message,
    );
  }

  String _resolveDocumentWarningMessage(
    BuildContext context,
    String? rawMessage,
  ) {
    final normalized = (rawMessage ?? '').trim().toLowerCase();

    if (normalized.isEmpty) {
      return getString(context, 'legal_obligation_document_warning_generic');
    }

    if (_containsAny(
      normalized,
      const [
        'not found',
        'nao encontrado',
        'não encontrado',
        '404',
      ],
    )) {
      return getString(context, 'legal_obligation_document_warning_not_found');
    }

    if (_containsAny(
      normalized,
      const [
        'unavailable',
        'indisponivel',
        'indisponível',
      ],
    )) {
      return getString(
        context,
        'legal_obligation_document_warning_unavailable',
      );
    }

    if (_containsAny(
      normalized,
      const [
        'failed to download',
        'failed to load',
        'unable to load',
        'erro ao processar arquivo',
        'carregar',
      ],
    )) {
      return getString(context, 'legal_obligation_document_warning_load_error');
    }

    if (_containsAny(
      normalized,
      const [
        'partner',
        'parceiro',
        'integration',
        'integração',
        'integracao',
      ],
    )) {
      return getString(
        context,
        'legal_obligation_document_warning_partner_integration',
      );
    }

    return getString(context, 'legal_obligation_document_warning_generic');
  }

  bool _containsAny(String source, List<String> terms) {
    for (final term in terms) {
      if (source.contains(term)) return true;
    }
    return false;
  }

  bool _isAlreadyRequestedPartnerRenewal(String? rawMessage) {
    final normalized = (rawMessage ?? '').trim().toLowerCase();
    if (normalized.isEmpty) return false;

    return _containsAny(
      normalized,
      const [
        'solicitação já enviada recentemente',
        'solicitacao ja enviada recentemente',
        'aguarde 3 dias para uma nova tentativa',
        'request already sent recently',
        'wait 3 days',
      ],
    );
  }

  Future<void> _setPartnerRenewalTooltipType(
    _PartnerRenewalTooltipType tooltipType,
  ) async {
    if (mounted) {
      setState(() {
        _partnerRenewalTooltipType = tooltipType;
      });
    }

    await _persistPartnerRenewalTooltipState(tooltipType);
  }

  Future<void> _restorePartnerRenewalTooltipState() async {
    final cacheKey = _buildPartnerRenewalCacheKey();
    if (cacheKey == null) return;

    final preferences = await SharedPreferences.getInstance();
    final persisted = preferences.getString(cacheKey);
    if (persisted == null || persisted.isEmpty) return;

    final parsed = _parsePartnerRenewalCachedState(persisted);
    if (parsed == null) {
      await preferences.remove(cacheKey);
      return;
    }

    final isExpired =
        DateTime.now().difference(parsed.savedAt) >= _partnerRenewalCacheTtl;
    if (isExpired) {
      await preferences.remove(cacheKey);
      return;
    }

    if (!mounted) return;
    setState(() {
      _partnerRenewalTooltipType = parsed.tooltipType;
    });
  }

  Future<void> _persistPartnerRenewalTooltipState(
    _PartnerRenewalTooltipType tooltipType,
  ) async {
    final cacheKey = _buildPartnerRenewalCacheKey();
    if (cacheKey == null) return;

    final preferences = await SharedPreferences.getInstance();
    if (tooltipType == _PartnerRenewalTooltipType.none) {
      await preferences.remove(cacheKey);
      return;
    }

    final typeValue = _tooltipTypeToCacheValue(tooltipType);
    if (typeValue == null) {
      await preferences.remove(cacheKey);
      return;
    }

    final payload = '$typeValue|${DateTime.now().millisecondsSinceEpoch}';
    await preferences.setString(cacheKey, payload);
  }

  _PartnerRenewalCachedState? _parsePartnerRenewalCachedState(
    String persisted,
  ) {
    final parts = persisted.split('|');
    if (parts.length != 2) return null;

    final tooltipType = _tooltipTypeFromCacheValue(parts.first);
    if (tooltipType == null) return null;

    final timestamp = int.tryParse(parts.last);
    if (timestamp == null) return null;

    return _PartnerRenewalCachedState(
      tooltipType: tooltipType,
      savedAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  _PartnerRenewalTooltipType? _tooltipTypeFromCacheValue(String value) {
    switch (value) {
      case 'requested':
        return _PartnerRenewalTooltipType.requested;
      case 'recently_requested':
        return _PartnerRenewalTooltipType.recentlyRequested;
      default:
        return null;
    }
  }

  String? _tooltipTypeToCacheValue(_PartnerRenewalTooltipType type) {
    switch (type) {
      case _PartnerRenewalTooltipType.none:
        return null;
      case _PartnerRenewalTooltipType.requested:
        return 'requested';
      case _PartnerRenewalTooltipType.recentlyRequested:
        return 'recently_requested';
    }
  }

  String? _buildPartnerRenewalCacheKey() {
    final obligationId = _currentItem.id?.trim();
    if (obligationId == null || obligationId.isEmpty) {
      return null;
    }

    final session =
        ApplicationContainer.instance().resolve<SessionBloc>().state.session;
    final userId = _cacheSegmentOrFallback(session?.me?.id, 'unknown_user');
    final condominiumId = _cacheSegmentOrFallback(
      session?.selectedCondominium?.id,
      'unknown_condo',
    );
    final obligationType =
        _cacheSegmentOrFallback(widget.obligationTypeValue, 'unknown_type');
    final obligationIdSegment =
        _cacheSegmentOrFallback(obligationId, 'unknown_id');

    return '$_partnerRenewalCachePrefix:$userId:$condominiumId:$obligationType:$obligationIdSegment';
  }

  String _cacheSegmentOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;

    return trimmed
        .replaceAll(':', '_')
        .replaceAll('|', '_')
        .replaceAll(' ', '_');
  }

  String _orDash(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return '-';
    return trimmed;
  }

  void _refreshObligationData() {
    final tab = _resolveTabFromObligationType(widget.obligationTypeValue);
    if (tab == null) return;

    _isRefreshingAfterUpload = true;
    bloc.add(LegalObligationLoadTabEvent(tab));
  }

  void _updateItemAfterRefresh(LegalObligationLoadedState state) {
    if (!_isRefreshingAfterUpload) return;

    final expectedTab =
        _resolveTabFromObligationType(widget.obligationTypeValue);
    if (expectedTab == null || state.tab != expectedTab) return;

    _isRefreshingAfterUpload = false;

    final obligationId = _currentItem.id?.trim();
    if (obligationId == null || obligationId.isEmpty || !mounted) return;

    final updatedItem = _findItemById(state.data.items, obligationId);
    if (updatedItem == null) return;

    setState(() {
      _currentItem = updatedItem;
    });
  }

  LegalObligationItemEntity? _findItemById(
    List<LegalObligationItemEntity> items,
    String id,
  ) {
    for (final item in items) {
      if (item.id?.trim() == id) {
        return item;
      }
    }

    return null;
  }

  LegalObligationTab? _resolveTabFromObligationType(String type) {
    switch (type.trim().toUpperCase()) {
      case 'CONDOMINIUM':
        return LegalObligationTab.condominium;
      case 'EMPLOYEE':
        return LegalObligationTab.employee;
      case 'TECHNICAL_INSPECTION':
        return LegalObligationTab.technicalInspection;
      default:
        return null;
    }
  }
}
