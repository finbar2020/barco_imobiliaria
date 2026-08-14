import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency/application_container.dart';
import '../bloc/task_history_bloc.dart';
import '../../../domain/entity/schedule_event_history_entity.dart';

class TaskHistoryPage extends StatefulWidget {
  final String taskId;
  final String taskName;

  const TaskHistoryPage({
    super.key,
    required this.taskId,
    required this.taskName,
  });

  @override
  State<TaskHistoryPage> createState() => _TaskHistoryPageState();
}

class _TaskHistoryPageState extends State<TaskHistoryPage> {
  late final TaskHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    print(
        'DEBUG: TaskHistoryPage iniciada com taskId: ${widget.taskId}, taskName: ${widget.taskName}');
    _bloc = ApplicationContainer.instance().resolve<TaskHistoryBloc>();
    _bloc.add(LoadTaskHistoryEvent(widget.taskId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(theme, palette),
      body: BlocBuilder<TaskHistoryBloc, TaskHistoryState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is TaskHistoryLoadingState) {
            return _buildLoadingState();
          }

          if (state is TaskHistoryErrorState) {
            return _buildErrorState(state.message, theme, palette);
          }

          if (state is TaskHistoryLoadedState) {
            return _buildLoadedState(state.history, theme, palette);
          }

          return _buildLoadingState(); // Estado padrão
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorPallete palette) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: palette.primary()),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Histórico da tarefa',
        style: LelloTextStyles.body(theme)?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(
      String message, ThemeData theme, ColorPallete palette) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: palette.warning(),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              'Erro ao carregar histórico',
              style: LelloTextStyles.title(theme)?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              message,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.grey(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingLarge),
            ElevatedButton(
              onPressed: () {
                _bloc.add(LoadTaskHistoryEvent(widget.taskId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary(),
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(
    ScheduleEventHistoryEntity history,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTaskInfoHeader(history, theme, palette),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHistoryTimeline(history, theme, palette),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfoHeader(
    ScheduleEventHistoryEntity history,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Usar data do dtStart do history ou data atual como fallback
    String formattedDate = '';
    if (history.dtStart.isNotEmpty) {
      formattedDate = _formatDateFromString(history.dtStart);
    } else {
      final now = DateTime.now();
      formattedDate =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    }

    // Pegar o responsável do primeiro item ou usar fallback
    String responsibleName = '-';
    if (history.items.isNotEmpty &&
        history.items.first.responsibleName?.isNotEmpty == true) {
      responsibleName = history.items.first.responsibleName!;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: Dimens.spacingMedium, horizontal: Dimens.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data com ícone de calendário e indicador allDay (se aplicável)
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: palette.grey(),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Text(
                formattedDate,
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: palette.grey(),
                  fontSize: 16,
                ),
              ),
              if (history.allDay) ...[
                SizedBox(width: Dimens.spacingLarge),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: palette.grey(),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      'Dia inteiro',
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: palette.grey(),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          SizedBox(height: Dimens.spacingSmall),

          // Responsável com ícone
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: palette.grey(),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Text(
                responsibleName,
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: palette.grey(),
                  fontSize: 16,
                ),
              ),
            ],
          ),

          SizedBox(height: Dimens.spacingMedium),

          // Nome da tarefa (título principal)
          Text(
            history.name.isNotEmpty ? history.name : widget.taskName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(
    ScheduleEventHistoryEntity history,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Column(
      children: history.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == history.items.length - 1;

        return _buildTimelineItem(
          item,
          isLast,
          theme,
          palette,
        );
      }).toList(),
    );
  }

  Widget _buildTimelineItem(
    ScheduleEventHistoryItemEntity item,
    bool isLast,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Formatação da data
    String formattedDate = _formatItemDate(item.dtStart);
    String formattedTime = _formatItemTime(item.dtStart);

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data, hora e status na mesma linha
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Text(
                  '$formattedDate $formattedTime',
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.grey(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Text(
                  item.status,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.grey(),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Dimens.spacingXSmall),

          // Responsável
          RichText(
            text: TextSpan(
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.grey(),
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: 'Responsável: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: item.responsibleName?.isNotEmpty == true
                      ? item.responsibleName
                      : "-",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateFromString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      // Parse mantendo o timezone original da string (sem conversão)
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  String _formatItemDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      // Extrair data diretamente da string sem conversão de timezone
      // Formato: "2025-11-21T16:56:12-03:00"
      final regex = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
      final match = regex.firstMatch(dateString);
      if (match != null) {
        final year = match.group(1);
        final month = match.group(2);
        final day = match.group(3);
        return '$day/$month/$year';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  String _formatItemTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      // Extrair hora diretamente da string sem conversão de timezone
      // Formato: "2025-11-21T16:56:12-03:00"
      final regex = RegExp(r'T(\d{2}):(\d{2}):(\d{2})');
      final match = regex.firstMatch(dateString);
      if (match != null) {
        final hour = match.group(1);
        final minute = match.group(2);
        final second = match.group(3);
        return '$hour:$minute:$second';
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
