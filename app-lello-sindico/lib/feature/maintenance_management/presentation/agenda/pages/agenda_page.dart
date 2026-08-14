import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/maintenance_management/domain/enum/legal_obligation_type.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_condominium_info_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_legal_obligations_use_case.dart';
import '../widgets/widgets.dart';
import '../widgets/schedule_events_list_widget.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/legal_obligation_entity.dart';
import '../../../domain/entity/legal_obligation_status.dart';
import '../../../domain/entity/schedule_events_detail_response_entity.dart';
import '../../home/pages/maintenance_management_filters_page.dart';
import '../../legal_obligation/enums/legal_obligation_tab.dart';
import '../../legal_obligation/pages/legal_obligation_detail_page.dart';
import '../bloc/calendar_indicators_bloc.dart';
import '../bloc/calendar_indicators_event.dart';
import '../bloc/schedule_events_bloc.dart';
import '../bloc/schedule_events_event.dart';
import '../bloc/schedule_events_state.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _isCalendarExpanded = true;
  FilterOptionsEntity? _appliedFilters;
  bool _isTrackingTradeServiceUnavailable = false;
  bool _isRetryingUnavailableTasks = false;
  bool _didReadRouteArguments = false;

  final GetCondominiumInfoUseCase _getCondominiumInfoUseCase =
      ApplicationContainer.instance().resolve<GetCondominiumInfoUseCase>();
  final GetLegalObligationsUseCase _getLegalObligationsUseCase =
      ApplicationContainer.instance().resolve<GetLegalObligationsUseCase>();

  @override
  void initState() {
    super.initState();
    _loadCalendarIndicators();
    _loadInitialEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didReadRouteArguments) return;

    _didReadRouteArguments = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Map<String, dynamic>) return;

    final routeUnavailable = args['isTrackingTradeServiceUnavailable'];
    if (routeUnavailable is bool) {
      _isTrackingTradeServiceUnavailable = routeUnavailable;
    }

    final routeTrackingTradeStatus = args['trackingTradeStatus'];
    if (routeTrackingTradeStatus is String &&
        routeTrackingTradeStatus.toUpperCase() ==
            TrackingTradeStatus.serviceUnavailable.apiValue) {
      _isTrackingTradeServiceUnavailable = true;
    }
  }

  void _loadCalendarIndicators() {
    try {
      context.read<CalendarIndicatorsBloc>().add(
            LoadCalendarIndicatorsEvent(
              month: _focusedDay.month,
              year: _focusedDay.year,
              appliedFilters: _appliedFilters,
            ),
          );
    } catch (e) {
      // Silenciosamente falha se houver problema com o carregamento dos indicadores
      // A agenda continuará funcionando sem as bolinhas azuis
    }
  }

  void _loadInitialEvents() {
    try {
      final today = DateTime.now();
      setState(() {
        _selectedDay = today;
        _focusedDay = today;
      });

      // Carrega os eventos do dia atual usando ScheduleEventsBloc
      context.read<ScheduleEventsBloc>().add(
            LoadScheduleEventsEvent(
              selectedDate: today,
              appliedFilters: _appliedFilters,
              pageName: "CALENDAR",
            ),
          );
    } catch (e) {
      // Silenciosamente falha se houver problema com o carregamento dos eventos
    }
  }

  String _resolveDateLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode.toLowerCase() == 'pt') {
      return 'pt_BR';
    }

    return 'en_US';
  }

  String getFormattedDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;
    final locale = _resolveDateLocale(context);
    final formattedDate = DateFormat.yMMMMd(locale).format(date);

    if (difference == 0) {
      return getStringWithParams(
        context,
        'maintenance_management_date_today_with_date',
        [formattedDate],
      );
    } else if (difference == -1) {
      return getStringWithParams(
        context,
        'maintenance_management_date_yesterday_with_date',
        [formattedDate],
      );
    } else if (difference == 1) {
      return getStringWithParams(
        context,
        'maintenance_management_date_tomorrow_with_date',
        [formattedDate],
      );
    } else {
      return formattedDate;
    }
  }

  Widget _buildAgendaSelectedDateText(
    BuildContext context,
    ThemeData theme,
    DateTime selectedDate,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowScreen = constraints.maxWidth < 340;
        final baseStyle = isNarrowScreen
            ? LelloTextStyles.titleSmallBold(theme)
            : LelloTextStyles.title(theme);

        return Text(
          getFormattedDate(context, selectedDate),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: baseStyle?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _loadTasksForSelectedDate();
  }

  void _onFormatChanged(CalendarFormat format) {
    // Formato controlado apenas pelo handle de arrasto.
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });

    context.read<CalendarIndicatorsBloc>().add(
          LoadCalendarIndicatorsEvent(
            month: focusedDay.month,
            year: focusedDay.year,
            appliedFilters: _appliedFilters,
          ),
        );
  }

  void _toggleCalendarExpansion() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
      if (!_isCalendarExpanded) {
        _calendarFormat = CalendarFormat.week;
      } else {
        _calendarFormat = CalendarFormat.month;
      }
    });
  }

  void _loadTasksForSelectedDate() {
    final dateToUse = _selectedDay ?? _focusedDay;

    context.read<ScheduleEventsBloc>().add(
          LoadScheduleEventsEvent(
            selectedDate: dateToUse,
            appliedFilters: _appliedFilters,
            pageName: "CALENDAR",
          ),
        );
  }

  Future<void> _retryUnavailableTasksSection() async {
    if (_isRetryingUnavailableTasks) return;

    setState(() {
      _isRetryingUnavailableTasks = true;
    });

    final result = await _getCondominiumInfoUseCase();

    if (!mounted) return;

    result.fold(
      (_) {},
      (data) {
        final isUnavailable =
            data.trackingTradeStatus == TrackingTradeStatus.serviceUnavailable;

        setState(() {
          _isTrackingTradeServiceUnavailable = isUnavailable;
        });

        if (!isUnavailable) {
          _loadTasksForSelectedDate();
          _loadCalendarIndicators();
        }
      },
    );

    if (!mounted) return;
    setState(() {
      _isRetryingUnavailableTasks = false;
    });
  }

  Future<void> _openFilters(BuildContext context) async {
    final emptyFilterOptions = FilterOptionsEntity(
      taskType: [],
      taskStatus: [],
      locals: [],
      assets: [],
      responsibles: [],
      employeeGroup: [],
    );

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MaintenanceManagementFiltersPage(
          filterOptions: emptyFilterOptions,
          appliedFilters: _appliedFilters,
        ),
      ),
    );

    if (result != null && result is FilterOptionsEntity) {
      setState(() {
        _appliedFilters = result;
      });

      context.read<ScheduleEventsBloc>().add(ClearScheduleEventsCacheEvent());
      context
          .read<CalendarIndicatorsBloc>()
          .add(ClearCalendarIndicatorsCacheEvent());

      _loadTasksForSelectedDate();

      context.read<CalendarIndicatorsBloc>().add(
            LoadCalendarIndicatorsEvent(
              month: _focusedDay.month,
              year: _focusedDay.year,
              appliedFilters: _appliedFilters,
            ),
          );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDate = _selectedDay ?? _focusedDay;
    final legalObligationsLabel = getString(
      context,
      'maintenance_management_legal_entitlements',
      defaultText: 'Obrigações Legais',
    ).toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: PrimaryAppBar(
        title: getString(context, "maintenance_management_schedule"),
        theme: theme,
      ),
      body: _isTrackingTradeServiceUnavailable
          ? _buildUnavailableAgendaBody(context, theme, selectedDate)
          : LayoutBuilder(
              builder: (context, constraints) {
                final shouldUsePageScrollForTasks =
                    _isCalendarExpanded && constraints.maxHeight < 760;

                return _buildAgendaBody(
                  context,
                  theme,
                  selectedDate,
                  legalObligationsLabel,
                  usePageScrollForTasks: shouldUsePageScrollForTasks,
                );
              },
            ),
    );
  }

  Widget _buildAgendaBody(
    BuildContext context,
    ThemeData theme,
    DateTime selectedDate,
    String legalObligationsLabel, {
    required bool usePageScrollForTasks,
  }) {
    final headerChildren = [
      Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              getString(context, "maintenance_management_schedule"),
              style: LelloTextStyles.title(theme)?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      AgendaCalendarWidget(
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
        calendarFormat: _calendarFormat,
        onDaySelected: _onDaySelected,
        onFormatChanged: _onFormatChanged,
        onPageChanged: _onPageChanged,
        isExpanded: _isCalendarExpanded,
        onToggleExpansion: _toggleCalendarExpansion,
        appliedFilters: _appliedFilters,
      ),
      Container(
        width: double.infinity,
        color: const Color(0xFFF2F2F2),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAgendaSelectedDateText(
              context,
              theme,
              selectedDate,
            ),
            const SizedBox(height: 10),
            Text(
              getStringWithParams(
                context,
                'maintenance_management_reminders_with_subject',
                [legalObligationsLabel],
              ),
              style: LelloTextStyles.titleSmallBold(theme),
            ),
          ],
        ),
      ),
      _buildLegalObligationsCards(theme),
      _buildTasksSectionHeader(
        context,
        theme,
        showFilterButton: true,
      ),
    ];

    if (usePageScrollForTasks) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ...headerChildren,
            ScheduleEventsListWidget(
              selectedDate: selectedDate,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...headerChildren,
        Expanded(
          child: ScheduleEventsListWidget(
            selectedDate: selectedDate,
          ),
        ),
      ],
    );
  }

  Widget _buildUnavailableAgendaBody(
    BuildContext context,
    ThemeData theme,
    DateTime selectedDate,
  ) {
    final legalObligationsLabel = getString(
      context,
      'maintenance_management_legal_entitlements',
      defaultText: 'Obrigações Legais',
    ).toLowerCase();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  getString(context, "maintenance_management_schedule"),
                  style: LelloTextStyles.title(theme)?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          AgendaCalendarWidget(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
            onPageChanged: _onPageChanged,
            isExpanded: _isCalendarExpanded,
            onToggleExpansion: _toggleCalendarExpansion,
            appliedFilters: _appliedFilters,
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFF2F2F2),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAgendaSelectedDateText(
                  context,
                  theme,
                  selectedDate,
                ),
                const SizedBox(height: 10),
                Text(
                  getStringWithParams(
                    context,
                    'maintenance_management_reminders_with_subject',
                    [legalObligationsLabel],
                  ),
                  style: LelloTextStyles.titleSmallBold(theme),
                ),
              ],
            ),
          ),
          _buildLegalObligationsCards(theme),
          _buildTasksSectionHeader(context, theme),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildUnavailableTasksCard(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSectionHeader(
    BuildContext context,
    ThemeData theme, {
    bool showFilterButton = false,
  }) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getString(
                context,
                'maintenance_management_tasks_of_day_title',
                defaultText: 'Tarefas do dia',
              ),
              style: LelloTextStyles.titleSmallBold(theme),
            ),
          ),
          if (showFilterButton) buildFilterButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildLegalObligationsCards(ThemeData theme) {
    return BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
      builder: (context, state) {
        if (state is! ScheduleEventsLoadedState || state.obligations.isEmpty) {
          return const SizedBox.shrink();
        }

        final displayedObligations = state.obligations.take(3).toList();
        final hasMoreObligations =
            state.obligations.length > displayedObligations.length;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Column(
            children: [
              ...displayedObligations.map(
                (obligation) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildLegalObligationReminderCard(obligation),
                ),
              ),
              if (hasMoreObligations)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        ApplicationRoute.maintenanceManagementLegalObligation,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Ver mais',
                      style: LelloTextStyles.bodyBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).primary(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegalObligationReminderCard(
    ScheduleEventObligationEntity obligation,
  ) {
    final dueLabel = _buildLegalObligationBadgeLabel(obligation);
    final badgeColor = _buildLegalObligationBadgeColor(context, obligation);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _openLegalObligationDetail(obligation),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                obligation.name.isNotEmpty ? obligation.name : '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (dueLabel.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  dueLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF4E4E4E),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLegalObligationDetail(
    ScheduleEventObligationEntity obligation,
  ) async {
    final tab = _resolveTabByObligationType(obligation.legalObligationType);
    final fallbackItem = _buildFallbackLegalObligationItem(obligation);

    var itemToOpen = fallbackItem;
    final request = GetLegalObligationsRequest(
      type: _resolveTypeByTab(tab),
    );

    final result = await _getLegalObligationsUseCase(request);
    result.fold(
      (_) {},
      (data) {
        final matchedItem = _findMatchingLegalObligationItem(
          data.items,
          obligation,
        );
        if (matchedItem != null) {
          itemToOpen = matchedItem;
        }
      },
    );

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LegalObligationDetailPage(
          item: itemToOpen,
          listCategoryLabel: tab.listCategoryLabel,
          obligationTypeValue: tab.obligationTypeValue,
        ),
      ),
    );
  }

  LegalObligationItemEntity _buildFallbackLegalObligationItem(
    ScheduleEventObligationEntity obligation,
  ) {
    return LegalObligationItemEntity(
      id: obligation.id,
      reference:
          obligation.reference > 0 ? obligation.reference.toString() : null,
      collectionCode: obligation.collectionCode.isNotEmpty
          ? obligation.collectionCode
          : null,
      description: obligation.name.isNotEmpty ? obligation.name : null,
      status: obligation.expirationStatus,
      expirationDate: obligation.expirationDate.isNotEmpty
          ? obligation.expirationDate
          : null,
      statusTooltip: obligation.expirationDescription,
      availableActions: const [],
    );
  }

  LegalObligationItemEntity? _findMatchingLegalObligationItem(
    List<LegalObligationItemEntity> items,
    ScheduleEventObligationEntity obligation,
  ) {
    final obligationId = obligation.id.trim();
    final obligationCollectionCode = obligation.collectionCode.trim();
    final obligationReference = obligation.reference.toString();

    for (final item in items) {
      if ((item.id ?? '').trim() == obligationId) {
        return item;
      }
    }

    for (final item in items) {
      final collectionCodeMatches =
          (item.collectionCode ?? '').trim() == obligationCollectionCode;
      final referenceMatches =
          (item.reference ?? '').trim() == obligationReference;
      if (collectionCodeMatches && referenceMatches) {
        return item;
      }
    }

    return null;
  }

  LegalObligationType _resolveTypeByTab(LegalObligationTab tab) {
    switch (tab) {
      case LegalObligationTab.condominium:
        return LegalObligationType.condominium;
      case LegalObligationTab.employee:
        return LegalObligationType.employee;
      case LegalObligationTab.technicalInspection:
        return LegalObligationType.technicalInspection;
    }
  }

  LegalObligationTab _resolveTabByObligationType(String legalObligationType) {
    final normalized = legalObligationType.trim().toUpperCase();

    if (normalized == LegalObligationTab.employee.obligationTypeValue) {
      return LegalObligationTab.employee;
    }

    if (normalized ==
        LegalObligationTab.technicalInspection.obligationTypeValue) {
      return LegalObligationTab.technicalInspection;
    }

    return LegalObligationTab.condominium;
  }

  String _buildLegalObligationBadgeLabel(
    ScheduleEventObligationEntity obligation,
  ) {
    final status = obligation.expirationStatus.trim();
    return status.isNotEmpty ? status.toUpperCase().replaceAll('_', ' ') : '';
  }

  Color _buildLegalObligationBadgeColor(
    BuildContext context,
    ScheduleEventObligationEntity obligation,
  ) {
    final status = _resolveLegalObligationBadgeStatus(obligation);
    return status.color(Theme.of(context));
  }

  LegalObligationStatus _resolveLegalObligationBadgeStatus(
    ScheduleEventObligationEntity obligation,
  ) {
    final normalizedStatus = obligation.expirationStatus.trim().toLowerCase();
    final normalizedDescription =
        obligation.expirationDescription.trim().toLowerCase();

    if (normalizedStatus.contains('vencido') ||
        normalizedStatus.contains('hoje') ||
        normalizedDescription.contains('vencido') ||
        normalizedDescription.contains('hoje')) {
      return LegalObligationStatus.vencido;
    }

    if (normalizedStatus.contains('pendente')) {
      return LegalObligationStatus.pendente;
    }

    if (normalizedStatus.contains('renova')) {
      return LegalObligationStatus.emRenovacao;
    }

    if (normalizedStatus.contains('analis')) {
      return LegalObligationStatus.emAnalise;
    }

    if (normalizedStatus.contains('recus')) {
      return LegalObligationStatus.recusado;
    }

    if (normalizedStatus.contains('valid')) {
      return LegalObligationStatus.valido;
    }

    final expirationDate = DateTime.tryParse(obligation.expirationDate);
    if (expirationDate != null) {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      final normalizedDate = DateTime(
          expirationDate.year, expirationDate.month, expirationDate.day);
      final days = normalizedDate.difference(normalizedNow).inDays;

      if (days <= 0) {
        return LegalObligationStatus.vencido;
      }
    }

    return LegalObligationStatus.aVencer;
  }

  Widget _buildUnavailableTasksCard(BuildContext context, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/ic_bella_not_available_error.svg',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 8),
          Text(
            getString(
              context,
              'maintenance_management_service_unavailable_title',
              defaultText: 'Serviço temporariamente\nindisponível',
            ),
            textAlign: TextAlign.center,
            style: LelloTextStyles.title(theme)?.copyWith(
              color: palette.textLight(),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            getString(
              context,
              'maintenance_management_service_unavailable_description',
              defaultText:
                  'O sistema que fornece estes dados está fora do ar no momento. '
                  'Já estamos cientes e trabalhando para que tudo volte ao normal logo.\n'
                  'Tente atualizar a página daqui a pouco.',
            ),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.textLight(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              theme: theme,
              onPressed: _isRetryingUnavailableTasks
                  ? null
                  : _retryUnavailableTasksSection,
              text: _isRetryingUnavailableTasks
                  ? null
                  : getString(
                      context,
                      'maintenance_management_service_unavailable_retry_button',
                      defaultText: 'Tentar novamente',
                    ),
              child: _isRetryingUnavailableTasks
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : null,
              buttonColor: palette.primary(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () => _openFilters(context),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFBDBDBD),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/ic_filter_dropdown.svg',
              width: 25,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              getString(context, "maintenance_management_filters"),
              style: LelloTextStyles.titleSmallBold(theme)?.copyWith(
                color: const Color(0xFF212121),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: Color(0xFF212121),
            ),
          ],
        ),
      ),
    );
  }
}
