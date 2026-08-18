import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entity/task_report_entity.dart';
import '../bloc/task_report/task_report_bloc.dart';
import '../bloc/task_report/task_report_event.dart';
import '../bloc/task_report/task_report_state.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../../../../core/navigation/application_route.dart';
import 'task_report_file_preview_page.dart';

class TaskReportPage extends StatefulWidget {
  final String taskId;
  final String stepId;
  final String stepName;
  final String? eventId;

  const TaskReportPage({
    super.key,
    required this.taskId,
    required this.stepId,
    required this.stepName,
    this.eventId,
  });

  @override
  State<TaskReportPage> createState() => _TaskReportPageState();
}

class _TaskReportPageState extends State<TaskReportPage> {
  late final TaskReportBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<TaskReportBloc>();

    if (widget.eventId != null) {
      _bloc.add(LoadTaskReport(eventId: widget.eventId!));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(theme, palette),
      body: BlocBuilder<TaskReportBloc, TaskReportState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is TaskReportLoading) {
            return _buildLoadingState(theme, palette);
          } else if (state is TaskReportLoaded) {
            return _buildLoadedState(state.report, theme, palette);
          } else if (state is TaskReportError) {
            return _buildErrorState(state.message, theme, palette);
          } else {
            return _buildNoDataState(theme, palette);
          }
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
        'Relatório da etapa',
        style: LelloTextStyles.body(theme)?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorPallete palette) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedState(
      TaskReportEntity report, ThemeData theme, ColorPallete palette) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTaskInfoHeader(report, theme, palette),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...report.questions
                      .map((question) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildQuestionCard(
                                question, report, theme, palette),
                          ))
                      .toList(),
                  if (report.questions.isNotEmpty) const SizedBox(height: 16),
                  // _buildWarningCard(theme, palette),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      String message, ThemeData theme, ColorPallete palette) {
    return Column(
      children: [
        // Cabeçalho genérico para erro
        Container(
          width: double.infinity,
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: palette.grey()),
                  const SizedBox(width: 8),
                  Text(
                    'Data não disponível',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: palette.grey()),
                  const SizedBox(width: 8),
                  Text(
                    'Responsável não disponível',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: palette.warning(), size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar relatório',
                    style: LelloTextStyles.title(theme)?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.eventId != null) {
                        _bloc.add(RefreshTaskReport(eventId: widget.eventId!));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Tentar novamente',
                      style: LelloTextStyles.body(theme)?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataState(ThemeData theme, ColorPallete palette) {
    return Column(
      children: [
        // Cabeçalho genérico para no data
        Container(
          width: double.infinity,
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: palette.grey()),
                  const SizedBox(width: 8),
                  Text(
                    'Data não disponível',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: palette.grey()),
                  const SizedBox(width: 8),
                  Text(
                    'Responsável não disponível',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_outlined,
                    color: palette.grey(), size: 56),
                const SizedBox(height: 12),
                Text(
                  'Nenhum relatório disponível',
                  style: LelloTextStyles.title(theme)?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Não há dados de relatório para esta tarefa.',
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.grey(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskInfoHeader(
      TaskReportEntity report, ThemeData theme, ColorPallete palette) {
    // Formatação do período (data início - data fim)
    String getDateRange() {
      final startDate = _formatDate(report.createdAt);
      final endDate = _formatDate(report.finishedAt);

      if (startDate != '-' && endDate != '-') {
        return '$startDate - $endDate';
      } else if (startDate != '-') {
        return startDate;
      } else if (endDate != '-') {
        return endDate;
      }
      return _formatDate(report.completedAt);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data de início - fim (período) com ícone de calendário
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18,
                color: palette.grey(),
              ),
              const SizedBox(width: 8),
              Text(
                getDateRange(),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: palette.grey(),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Nome do responsável com ícone de pessoa
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: palette.grey(),
              ),
              const SizedBox(width: 8),
              Text(
                report.responsibleName,
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: palette.grey(),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nome do formulário (maior e em bold preto)
          Text(
            report.formularName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 12),

          // Etapa (label em negrito, valor em cinza bold)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Etapa: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: report.formularName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.grey(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Responsável (label em negrito, valor em cinza bold)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Responsável: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: report.responsibleName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.grey(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  Widget _buildQuestionCard(TaskReportQuestionEntity question,
      TaskReportEntity report, ThemeData theme, ColorPallete palette) {
    // Verifica se esta pergunta originou uma OS (correlação por questionId)
    final hasOriginAnswerId = report.childTasks?.any(
            (childTask) => childTask.originAnswer?.questionId == question.id) ??
        false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuestionAnswer(question, theme, palette),
          SizedBox(height: hasOriginAnswerId ? Dimens.spacingSmall : 0),
          // Card vermelho para questions que originaram OS (na parte de baixo)
          if (hasOriginAnswerId)
            _buildOriginAnswerTooltip(question, theme, palette),
        ],
      ),
    );
  }

  Widget _buildQuestionAnswer(TaskReportQuestionEntity question,
      ThemeData theme, ColorPallete palette) {
    if (question.answer == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.grey().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Não respondido',
          style: LelloTextStyles.body(theme)?.copyWith(
            color: palette.grey(),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final answer = question.answer!;

    Widget mainAnswer;
    switch (question.type) {
      case TaskReportQuestionType.textarea:
        mainAnswer = _buildTextAnswer(answer, theme, palette);
        break;
      case TaskReportQuestionType.radio:
        mainAnswer = _buildRadioAnswer(answer, theme, palette);
        break;
      case TaskReportQuestionType.select:
        mainAnswer = _buildSelectAnswer(answer, theme, palette);
        break;
      case TaskReportQuestionType.file:
        mainAnswer = _buildFileAnswer(answer, theme, palette);
        break;
    }

    // Se há respostas de arquivo dependentes, exibe-as junto
    if (question.dependentFileAnswers != null &&
        question.dependentFileAnswers!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainAnswer,
          const SizedBox(height: 16),
          ...question.dependentFileAnswers!.map(
            (fileAnswer) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fileAnswer.questionName != null &&
                      fileAnswer.questionName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        fileAnswer.questionName!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  _buildFileAnswer(fileAnswer, theme, palette),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return mainAnswer;
  }

  Widget _buildTextAnswer(
    TaskReportAnswerEntity answer,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Text(
        answer.textValue ?? '',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildRadioAnswer(
    TaskReportAnswerEntity answer,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final selectedOption = answer.selectedOption;
    if (selectedOption == null) return const SizedBox();

    // Para RADIO, mostrar como botões Sim/Não verticalmente
    if (selectedOption.toLowerCase() == 'sim' ||
        selectedOption.toLowerCase() == 'não') {
      return Column(
        children: [
          _buildChoiceButton(
              'Sim', selectedOption.toLowerCase() == 'sim', palette),
          const SizedBox(height: 8),
          _buildChoiceButton(
              'Não', selectedOption.toLowerCase() == 'não', palette),
        ],
      );
    }

    // Para outras opções de radio, mostrar texto normal
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Text(
        selectedOption,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSelectAnswer(
    TaskReportAnswerEntity answer,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final selectedOption = answer.selectedOption;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedOption ?? 'Selecionar opção',
              style: TextStyle(
                color:
                    selectedOption != null ? Colors.black87 : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(
      String text, bool isSelected, ColorPallete palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? palette.primary() : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? palette.primary() : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFileAnswer(
    TaskReportAnswerEntity answer,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final files = answer.files;
    if (files == null || files.isEmpty) {
      return Text(
        'Nenhum arquivo anexado',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid 2x2 centralizado
          SizedBox(
            width: files.length == 1
                ? 150 // Para uma única imagem, usa largura menor
                : double.infinity, // Para múltiplas imagens, usa largura total
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    files.length == 1 ? 1 : 2, // 1 coluna se só tem 1 arquivo
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: files.length > 4
                  ? 4
                  : files.length, // Máximo 4 imagens como no Figma
              itemBuilder: (context, index) {
                final file = files[index];
                return _buildFilePreview(file, files, theme, palette);
              },
            ),
          ),
          if (files.length > 4) ...[
            const SizedBox(height: 8),
            Text(
              '+${files.length - 4} mais arquivos',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilePreview(
    TaskReportFileEntity file,
    List<TaskReportFileEntity> allFiles,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final isImage = _isImageFile(file.extension);

    return GestureDetector(
      onTap: () => _openFilePreview(file, allFiles),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: palette.grey().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: isImage
                ? Image.network(
                    file.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFileIcon(file.extension, palette);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  )
                : _buildFileIcon(file.extension, palette),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(String extension, ColorPallete palette) {
    IconData icon;
    Color color;

    switch (extension.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = palette.grey();
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          color: color,
        ),
      ),
    );
  }

  bool _isImageFile(String extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  void _openFilePreview(
      TaskReportFileEntity file, List<TaskReportFileEntity> allFiles) {
    final initialIndex = allFiles.indexOf(file);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskReportFilePreviewPage(
          file: file,
          allFiles: allFiles,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildOriginAnswerTooltip(
    TaskReportQuestionEntity question,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2), // Vermelho bem clarinho
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: palette.primary(), // Borda vermelha primária
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/ic_info_red.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Uma ordem de serviço foi criada a partir desta resposta.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.primary(), // Vermelho primário
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                print(
                    '🔴 DEBUG: "Ver tarefa" button clicked for question: ${question.id}');
                _navigateToOriginAnswerTask(question.id);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver tarefa',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.primary(), // Vermelho primário
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: palette.primary(), // Vermelho primário
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOriginAnswerTask(String? questionId) {
    // Busca o childTask que tem este questionId como originAnswer.questionId
    final currentState = _bloc.state;
    if (currentState is! TaskReportLoaded) {
      print('🔴 DEBUG: Estado atual não é TaskReportLoaded');
      return;
    }

    print('🔴 DEBUG: Buscando childTask para questionId: $questionId');

    // Debug: imprimir todos os childTasks
    currentState.report.childTasks?.forEach((childTask) {
      print(
          '🔴 DEBUG: ChildTask - scheduleEventId: ${childTask.scheduleEventId}');
      print(
          '🔴 DEBUG: OriginAnswer - questionId: ${childTask.originAnswer?.questionId}');
    });

    final childTask = currentState.report.childTasks?.firstWhere(
      (child) => child.originAnswer?.questionId == questionId,
      orElse: () => ChildTaskEntity(),
    );

    final scheduleEventId = childTask?.scheduleEventId;

    print('🔴 DEBUG: scheduleEventId encontrado: $scheduleEventId');

    if (scheduleEventId == null || scheduleEventId.isEmpty) {
      print('🔴 DEBUG: scheduleEventId está null ou vazio, não navegando');
      return;
    }

    print(
        '🔴 DEBUG: Navegando para task com scheduleEventId: $scheduleEventId');

    // Navegar para a tarefa que foi criada a partir desta resposta
    Navigator.pushNamed(
      context,
      ApplicationRoute.maintenanceManagementTaskDetails,
      arguments: scheduleEventId,
    );
  }
}
