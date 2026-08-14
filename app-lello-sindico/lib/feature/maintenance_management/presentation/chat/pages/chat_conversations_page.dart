import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/navigation/application_route.dart';
import '../../../../../core/dependency/application_container.dart';
import '../bloc/chat_conversations_bloc.dart';
import '../bloc/chat_conversations_event.dart';
import '../bloc/chat_conversations_state.dart';
import '../widgets/chat_conversation_card_widget.dart';
import '../../home/pages/maintenance_management_filters_page.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../home/widgets/task_card/task_card_enum.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';

/// Página de lista de conversas de chat
class ChatConversationsPage extends StatefulWidget {
  final String? taskId;
  final String? status;

  const ChatConversationsPage({
    this.taskId,
    this.status,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatConversationsPage> createState() => _ChatConversationsPageState();
}

class _ChatConversationsPageState extends State<ChatConversationsPage> {
  late ChatConversationsBloc _bloc;
  DateTime _selectedDate = DateTime.now();
  FilterOptionsEntity? _appliedFilters;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChatConversationsBloc>();
    
    // Garantir que sempre use a data atual ao carregar
    final now = DateTime.now();
    final formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    
    _bloc.add(LoadChatConversationsEvent(
      taskId: widget.taskId,
      status: widget.status != null ? [widget.status!] : null,
      dayCurrent: formattedDate,
    ));
  }

  Future<void> _showDatePicker() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      
      // Fazer nova requisição com a data selecionada
      final formattedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _bloc.add(LoadChatConversationsEvent(
        taskId: widget.taskId,
        status: widget.status != null ? [widget.status!] : null,
        dayCurrent: formattedDate,
      ));
    }
  }

  Future<void> _showFiltersPage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MaintenanceManagementFiltersPage(
          filterOptions: _bloc.filterOptions,
          appliedFilters: _appliedFilters,
        ),
      ),
    );

    if (result != null && result is FilterOptionsEntity) {
      setState(() {
        _appliedFilters = result;
      });

      // Aplicar filtros na requisição
      final mappedStatus = result.taskStatus.isNotEmpty
          ? result.taskStatus.map((statusType) {
              switch (statusType) {
                case TaskStatusType.pending:
                  return 'NOT_STARTED';
                case TaskStatusType.inProgress:
                  return 'DRAFT';
                case TaskStatusType.completed:
                  return 'DONE';
              }
            }).toList()
          : null;

      final mappedTypeTask = result.taskType.isNotEmpty
          ? result.taskType.map((type) {
              switch (type) {
                case TaskType.routine:
                  return 'ROTINA';
                case TaskType.serviceOrder:
                  return 'ORDEM_SERVICO';
              }
            }).toList()
          : null;

      final formattedDate = '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

      _bloc.add(LoadChatConversationsEvent(
        taskId: widget.taskId,
        dayCurrent: formattedDate,
        typeTask: mappedTypeTask?.isNotEmpty == true ? mappedTypeTask : null,
        status: mappedStatus?.isNotEmpty == true ? mappedStatus : null,
        assetIds: result.assets.isNotEmpty ? result.assets.map((asset) => asset.id).toList() : null,
        localIds: result.locals.isNotEmpty ? result.locals.map((local) => local.id).toList() : null,
        responsibleIds: result.responsibles.isNotEmpty ? result.responsibles.map((resp) => resp.id).toList() : null,
      ));
    }
  }

  int _getActiveFilterCount() {
    if (_appliedFilters == null) return 0;

    int count = 0;
    if (_appliedFilters!.taskType.isNotEmpty) count++;
    if (_appliedFilters!.taskStatus.isNotEmpty) count++;
    if (_appliedFilters!.locals.isNotEmpty) count++;
    if (_appliedFilters!.assets.isNotEmpty) count++;
    if (_appliedFilters!.responsibles.isNotEmpty) count++;
    if (_appliedFilters!.employeeGroup.isNotEmpty) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: palette.background(),
      appBar: AppBar(
        backgroundColor: palette.primary(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Conversas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header com data e filtros (sempre visível)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: palette.background(),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Data
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: palette.background(),
                      border: Border.all(
                        color: const Color(0xFFBEBEBE),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: palette.text(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                          style: TextStyle(
                            color: palette.text(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: palette.text(),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botão Filtros
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _showFiltersPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: palette.background(),
                          border: Border.all(
                            color: const Color(0xFFBEBEBE),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune,
                              size: 18,
                              color: palette.text(),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filtros',
                              style: TextStyle(
                                color: palette.text(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: palette.text(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Badge com contador de filtros
                    if (_getActiveFilterCount() > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: palette.primary(),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${_getActiveFilterCount()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Conteúdo (BLoC)
          Expanded(
            child: BlocBuilder<ChatConversationsBloc, ChatConversationsState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is ChatConversationsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ChatConversationsErrorState) {
                  final env = ApplicationContainer.instance().resolve<Environment>();
                  return ErrorHandlingWidget(
                    isProduction: env.isProduction,
                    errorCode: 'CHAT_CONVERSATIONS_ERROR',
                    error: state.message,
                    message: 'Erro ao carregar conversas',
                    reTryFunction: () {
                      _bloc.add(const RefreshChatConversationsEvent());
                    },
                    backFunction: () {
                      Navigator.of(context).pop();
                    },
                  );
                }

                if (state is ChatConversationsEmptyState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: palette.textLight(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma conversa',
                          style: TextStyle(
                            color: palette.text(),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Comece uma conversa sobre uma tarefa',
                          style: TextStyle(
                            color: const Color(0xFF666666),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ChatConversationsLoadedState) {
                  final conversations = state.conversations;
                  final pageInfo = state.pageInfo;
                  final hasMore = pageInfo?.hasNextPage ?? false;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: conversations.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Botão "Ver mais" no final
                      if (index == conversations.length) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: TextButton(
                              onPressed: _isLoadingMore
                                  ? null
                                  : () {
                                      if (pageInfo?.endCursor != null) {
                                        setState(() {
                                          _isLoadingMore = true;
                                        });
                                        
                                        final formattedDate = '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';
                                        
                                        _bloc.add(LoadMoreConversationsEvent(
                                          dayCurrent: formattedDate,
                                          status: widget.status != null ? [widget.status!] : null,
                                          endCursor: pageInfo!.endCursor!,
                                        ));
                                        
                                        setState(() {
                                          _isLoadingMore = false;
                                        });
                                      }
                                    },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isLoadingMore)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  else
                                    const Text(
                                      'Ver mais',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  if (!_isLoadingMore)
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final conversation = conversations[index];
                      return ChatConversationCardWidget(
                        conversation: conversation,
                        onTap: () {
                          // Marcar como lido
                          _bloc.add(MarkChannelAsReadEvent(conversation.id));
                          
                          Navigator.of(context).pushNamed(
                            ApplicationRoute.maintenanceManagementChatMessages,
                            arguments: {
                              'channel': conversation,
                              'ttJwtToken': state.ttJwtToken,
                              // NÃO passar taskId - permite navegação para detalhes ao clicar no título
                            },
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
