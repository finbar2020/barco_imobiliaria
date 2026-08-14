import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../domain/entity/legal_obligation_entity.dart';
import '../bloc/legal_obligation_bloc.dart';
import '../bloc/legal_obligation_event.dart';
import '../bloc/legal_obligation_state.dart';
import '../enums/legal_obligation_tab.dart';
import 'legal_obligation_detail_page.dart';
import '../widgets/legal_obligation_widgets.dart';

class LegalObligationPage extends StatefulWidget {
  final bool hasEmployee;
  final bool hasTechnicalInspection;

  const LegalObligationPage({
    super.key,
    required this.hasEmployee,
    required this.hasTechnicalInspection,
  });

  @override
  State<LegalObligationPage> createState() => _LegalObligationPageState();
}

class _LegalObligationPageState extends State<LegalObligationPage> {
  final bloc = ApplicationContainer.instance().resolve<LegalObligationBloc>();

  LegalObligationTab _selectedTab = LegalObligationTab.condominium;
  LegalObligationItemEntity? _technicalInspectionItem;
  final Map<LegalObligationTab, LegalObligationLoadedState> _loadedStateByTab =
      {};

  /// Tipos de obrigação (`obligationTypeValue`) cujo aviso de "ausência de dados"
  /// já foi enviado nesta sessão. Mantido por aba para que cada aba conserve seu
  /// próprio estado de "já notificado".
  final Set<String> _notifiedPartnerTypes = <String>{};

  @override
  void initState() {
    super.initState();
    _loadTab(_selectedTab);
  }

  void _loadTab(LegalObligationTab tab) {
    setState(() => _selectedTab = tab);
    bloc.add(LegalObligationLoadTabEvent(tab));
  }

  String _tabDescriptionKey() {
    switch (_selectedTab) {
      case LegalObligationTab.condominium:
        return 'legal_obligation_description_condominium';
      case LegalObligationTab.employee:
        return 'legal_obligation_description_employees';
      case LegalObligationTab.technicalInspection:
        return 'legal_obligation_description_technical_inspection';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocListener<LegalObligationBloc, LegalObligationState>(
      bloc: bloc,
      listenWhen: (_, curr) =>
          curr is LegalObligationLoadedState ||
          curr is LegalObligationEmailSentState ||
          curr is LegalObligationEmailErrorState ||
          curr is LegalObligationNotifyPartnerEmptyDataSuccessState ||
          curr is LegalObligationNotifyPartnerEmptyDataErrorState,
      listener: (context, state) async {
        if (state is LegalObligationLoadedState) {
          _loadedStateByTab[state.tab] = state;
          final requestPartner = state.data.requestPartner;
          if (requestPartner != null) {
            _updateNotifyPartnerButtonState(
              type: state.tab.obligationTypeValue,
              shouldLockButton: requestPartner,
            );
          }
          if (state.tab == LegalObligationTab.technicalInspection &&
              state.data.items.isNotEmpty) {
            setState(() => _technicalInspectionItem = state.data.items.first);
          }
        } else if (state is LegalObligationEmailSentState) {
          if (!context.mounted) return;
          await LegalObligationReceiveByEmailSuccessBottomSheet.show(context);
        } else if (state is LegalObligationEmailErrorState) {
          if (!context.mounted) return;
          await LegalObligationReceiveByEmailErrorBottomSheet.show(context);
        } else if (state
            is LegalObligationNotifyPartnerEmptyDataSuccessState) {
          if (!mounted) return;
          _updateNotifyPartnerButtonState(
            type: state.type,
            shouldLockButton: state.shouldLockButton,
          );
          if (!context.mounted) return;
          await LegalObligationNotifyPartnerSuccessModal.show(context);
        } else if (state
            is LegalObligationNotifyPartnerEmptyDataErrorState) {
          if (!mounted) return;
          _updateNotifyPartnerButtonState(
            type: state.type,
            shouldLockButton: state.shouldLockButton,
          );
          if (!context.mounted) return;
          await LegalObligationPartnerRenewalFailureModal.show(context);
        }
      },
      child: Scaffold(
        backgroundColor: palette.background(),
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, 'legal_obligation_title'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.spacing, Dimens.spacing, Dimens.spacing, 0),
              child: Text(
                getString(context, 'legal_obligation_title'),
                style: LelloTextStyles.subtitleBold(theme),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.spacing),
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: InkWell(
                      onTap: () => _loadTab(LegalObligationTab.condominium),
                      child: _buildTabButton(
                        getString(context, 'legal_obligation_tab_condominium'),
                        LegalObligationTab.condominium,
                        theme,
                      ),
                    ),
                  ),
                  if (widget.hasEmployee) ...[
                    SizedBox(width: Dimens.spacingSmall),
                    Flexible(
                      flex: 4,
                      child: InkWell(
                        onTap: () => _loadTab(LegalObligationTab.employee),
                        child: _buildTabButton(
                          getString(context, 'legal_obligation_tab_employees'),
                          LegalObligationTab.employee,
                          theme,
                        ),
                      ),
                    ),
                  ],
                  if (widget.hasTechnicalInspection) ...[
                    SizedBox(width: Dimens.spacingSmall),
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () =>
                            _loadTab(LegalObligationTab.technicalInspection),
                        child: _buildTabButton(
                          getString(context,
                              'legal_obligation_tab_technical_inspection'),
                          LegalObligationTab.technicalInspection,
                          theme,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.spacing, 0, Dimens.spacing, Dimens.spacing),
              child: Text(
                getString(context, _tabDescriptionKey()),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: palette.textLight(),
                ),
              ),
            ),
            Expanded(
              child: _selectedTab == LegalObligationTab.technicalInspection
                  ? _buildTechnicalInspectionTab(theme)
                  : BlocBuilder<LegalObligationBloc, LegalObligationState>(
                      bloc: bloc,
                      builder: (context, state) {
                        final loadedState = _resolveLoadedState(state);

                        if (state is LegalObligationLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: palette.primary(),
                            ),
                          );
                        }

                        if (state is LegalObligationErrorState) {
                          return _buildErrorState(theme, state.message);
                        }

                        if (loadedState == null) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: palette.primary(),
                            ),
                          );
                        }

                        if (loadedState.data.isEmpty) {
                          return _buildEmptyState(theme, loadedState.tab);
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.spacing,
                            vertical: Dimens.spacingSmall,
                          ),
                          itemCount: loadedState.data.items.length,
                          itemBuilder: (context, index) {
                            final item = loadedState.data.items[index];

                            return LegalObligationCard(
                              item: item,
                              listCategoryLabel:
                                  loadedState.tab.listCategoryLabel,
                              onSeeDetails: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LegalObligationDetailPage(
                                      item: item,
                                      listCategoryLabel:
                                          loadedState.tab.listCategoryLabel,
                                      obligationTypeValue:
                                          loadedState.tab.obligationTypeValue,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalInspectionTab(ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimens.spacingSmall),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                final email =
                    await LegalObligationReceiveByEmailBottomSheet.show(
                        context);
                if (!context.mounted || email == null || email.isEmpty) {
                  return;
                }
                final item = _technicalInspectionItem;
                bloc.add(LegalObligationSendTechnicalInspectionEmailEvent(
                  email: email,
                  type: 'TECHNICAL_INSPECTION',
                  id: item?.id ?? '',
                ));
              },
              icon: Icon(Icons.send_rounded, color: Colors.white),
              label: Text(
                getString(context, 'legal_obligation_receive_by_email'),
                style: LelloTextStyles.bodyBold(theme)
                    ?.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.spacingSmall),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, LegalObligationTab tab, ThemeData theme) {
    final bool isSelected = _selectedTab == tab;
    final palette = LelloTheme.palleteOf(theme);
    final singleLineText = text.replaceAll('\n', ' ').trim();

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.spacingSmall, horizontal: Dimens.spacingSmall),
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? palette.primary() : Colors.white,
        borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        border: isSelected
            ? null
            : Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: palette.primary().withAlpha(30),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Center(
        child: AutoSizeText(
          singleLineText,
          maxLines: 1,
          minFontSize: 11,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: isSelected ? Colors.white : palette.text(),
          ),
        ),
      ),
    );
  }

  LegalObligationLoadedState? _resolveLoadedState(LegalObligationState state) {
    if (state is LegalObligationLoadedState && state.tab == _selectedTab) {
      return state;
    }

    return _loadedStateByTab[_selectedTab];
  }

  Widget _buildEmptyState(ThemeData theme, LegalObligationTab tab) {
    final typeValue = tab.obligationTypeValue;

    return BlocBuilder<LegalObligationBloc, LegalObligationState>(
      bloc: bloc,
      buildWhen: (_, curr) =>
          curr is LegalObligationNotifyPartnerEmptyDataSendingState ||
          curr is LegalObligationNotifyPartnerEmptyDataSuccessState ||
          curr is LegalObligationNotifyPartnerEmptyDataErrorState,
      builder: (context, state) {
        final isSending =
            state is LegalObligationNotifyPartnerEmptyDataSendingState &&
                state.type == typeValue;
        final alreadyNotified = _notifiedPartnerTypes.contains(typeValue);

        return LegalObligationNotifyPartnerEmptyState(
          alreadyNotified: alreadyNotified,
          isSending: isSending,
          onNotifyPressed: () {
            bloc.add(LegalObligationNotifyPartnerEmptyDataEvent(
              type: typeValue,
            ));
          },
        );
      },
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme),
            ),
            SizedBox(height: Dimens.spacing),
            TextButton(
              onPressed: () => _loadTab(_selectedTab),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateNotifyPartnerButtonState({
    required String type,
    required bool shouldLockButton,
  }) {
    if (!mounted) return;

    setState(() {
      if (shouldLockButton) {
        _notifiedPartnerTypes.add(type);
      } else {
        _notifiedPartnerTypes.remove(type);
      }
    });
  }
}
