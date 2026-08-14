import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';

import '../../../../domain/entity/task_details_entity.dart';
import '../../../../domain/use_cases/get_event_details_use_case.dart';
import '../../../../domain/use_cases/submit_form_use_case.dart';
import '../../../../domain/use_cases/reset_schedule_event_use_case.dart';
import '../../../../domain/entity/submit_form_entity.dart';
import 'task_init_step_event.dart';
import 'task_init_step_state.dart';

class TaskInitStepBloc extends Bloc<TaskInitStepEvent, TaskInitStepState> {
  final GetEventDetailsUseCase _getEventDetailsUseCase;
  final SubmitFormUseCase _submitFormUseCase;
  final ResetScheduleEventUseCase _resetScheduleEventUseCase;

  TaskInitStepBloc(
    this._getEventDetailsUseCase,
    this._submitFormUseCase,
    this._resetScheduleEventUseCase,
  ) : super(const TaskInitStepState(eventId: '', task: null, taskId: '')) {
    on<TaskInitStepStartedEvent>(_onStarted);
    on<TaskInitStepAnswerChangedEvent>(_onAnswerChanged);
    on<TaskInitStepSubmitPressedEvent>(_onSubmitPressed);
    on<TaskInitStepBackPressedEvent>(_onBackPressed);
    on<TaskInitStepConfirmDiscardEvent>(_onConfirmDiscard);
    on<TaskInitStepRequestResetEvent>(_onRequestReset);
    on<TaskInitStepConfirmResetEvent>(_onConfirmReset);
    on<TaskInitStepDialogDismissedEvent>(_onDialogDismissed);
    on<TaskInitStepStatusClearedEvent>(_onOutcomeCleared);
  }

  void initialize(String eventId, TaskDetailsEntity task, String taskId) {
    add(TaskInitStepStartedEvent(eventId, task, taskId));
  }

  Future<void> _onStarted(
      TaskInitStepStartedEvent event, Emitter<TaskInitStepState> emit) async {
    // event.eventId contém o eventId (retornado do POST CreateTaskFromSchedule)
    // event.taskId contém o taskId original (da lista de schedule events)
    final eventId = event.eventId;
    final originalTaskId = event.taskId;

    emit(TaskInitStepState(
      eventId: eventId,
      taskId: originalTaskId,
      task: event.task,
      isLoading: true,
    ));

    // Buscar detalhes do evento usando o eventId correto (retornado do POST)
    final request = GetEventDetailsRequest(eventId: eventId);
    final result = await _getEventDetailsUseCase.call(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar formulário: ${failure.toString()}',
        ));
      },
      (eventDetails) {
        // Extrair formulário e questions
        final formulary = eventDetails.lastContentAnswers?.formulary;
        final questions = formulary?.questions ?? [];

        // Ordenar questions por position
        final sortedQuestions = questions.toList()
          ..sort((a, b) => a.position.compareTo(b.position));

        // Filtrar questions não escondidas
        final visibleQuestions =
            sortedQuestions.where((q) => !q.hidden).toList();

        emit(state.copyWith(
          isLoading: false,
          formulary: formulary,
          questions: visibleQuestions,
        ));
      },
    );
  }

  void _onAnswerChanged(
      TaskInitStepAnswerChangedEvent event, Emitter<TaskInitStepState> emit) {
    final updatedAnswers = Map<String, dynamic>.from(state.answers);
    updatedAnswers[event.questionId] = event.answer;
    emit(state.copyWith(answers: updatedAnswers));
  }

  Future<void> _onSubmitPressed(
      TaskInitStepSubmitPressedEvent event, Emitter<TaskInitStepState> emit) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true));

    // Converter respostas para o formato da API
    final answersMap = <String, AnswerEntity>{};

    for (final question in state.questions) {
      final rawAnswer = state.answers[question.id];

      // Determinar o tipo baseado no fieldType da question
      final answerType = _getAnswerType(question.fieldType);

      // Processar content de acordo com o tipo
      final processedContent = _processContentByType(
        answerType,
        rawAnswer,
        question.fieldType,
      );

      answersMap[question.id] = AnswerEntity(
        type: answerType.toUpperCase(),
        questionId: question.id,
        content: processedContent,
      );
    }

    // Criar request
    final request = SubmitFormRequestEntity(
      eventId: state.eventId,
      answers: answersMap,
    );

    // Chamar use case
    final result = await _submitFormUseCase.call(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          outcome: TaskInitStepStatus.error,
          errorMessage: 'Erro ao enviar formulário: ${failure.toString()}',
        ));
      },
      (response) {
        emit(state.copyWith(
          isSubmitting: false,
          outcome: TaskInitStepStatus.success,
        ));
      },
    );
  }

  String _getAnswerType(String fieldType) {
    final normalized = fieldType.toLowerCase();

    // Mapear fieldType para os tipos da API
    if (normalized == 'file') return 'FILE';
    if (normalized == 'text') return 'TEXT';
    if (normalized == 'textarea') return 'TEXTAREA';
    if (normalized == 'number') return 'NUMBER';
    if (normalized == 'decimal') return 'DECIMAL';
    if (normalized == 'date') return 'DATE';
    if (normalized == 'select') return 'SELECT';
    if (normalized == 'radio') return 'RADIO';
    if (normalized == 'checkbox') return 'CHECKBOX';
    if (normalized == 'combo_select') return 'COMBO_SELECT';
    if (normalized == 'rating_stars') return 'RATING_STARS';
    if (normalized == 'asset') return 'ASSET';
    if (normalized == 'local') return 'LOCAL';
    if (normalized == 'sector') return 'SECTOR';
    if (normalized == 'signature') return 'SIGNATURE';
    if (normalized == 'collection') return 'COLLECTION';
    if (normalized == 'collections') return 'COLLECTIONS';

    return 'TEXT'; // default
  }

  dynamic _processContentByType(
      String type, dynamic rawAnswer, String fieldType) {
    if (rawAnswer == null) return null;

    switch (type.toUpperCase()) {
      case 'TEXT':
      case 'TEXTAREA':
        // String simples
        return rawAnswer.toString();

      case 'NUMBER':
        // Converter para int (JSON number)
        if (rawAnswer is int) return rawAnswer;
        if (rawAnswer is String) return int.tryParse(rawAnswer) ?? 0;
        return 0;

      case 'DECIMAL':
        // Converter para double (JSON number)
        if (rawAnswer is double) return rawAnswer;
        if (rawAnswer is int) return rawAnswer.toDouble();
        if (rawAnswer is String) return double.tryParse(rawAnswer) ?? 0.0;
        return 0.0;

      case 'RADIO':
      case 'SELECT':
        // String ou boolean (ID da opção ou true/false)
        if (rawAnswer is bool) return rawAnswer;
        return rawAnswer.toString();

      case 'CHECKBOX':
      case 'COMBO_SELECT':
        // Array de strings/numbers
        if (rawAnswer is List) return rawAnswer;
        return [rawAnswer];

      case 'DATE':
        // ISO 8601 UTC string
        if (rawAnswer is DateTime) {
          return rawAnswer.toUtc().toIso8601String();
        }
        return rawAnswer.toString();

      case 'RATING_STARS':
        // Number (1-5)
        if (rawAnswer is int) return rawAnswer;
        if (rawAnswer is String) return int.tryParse(rawAnswer) ?? 1;
        return 1;

      case 'FILE':
        // Cria objeto com metadados do arquivo
        if (rawAnswer is List) {
          // Múltiplos arquivos
          return (rawAnswer as List<String>)
              .map((url) => _createFileObject(url))
              .toList();
        } else if (rawAnswer is String) {
          // Arquivo único
          return _createFileObject(rawAnswer);
        }
        return null;

      case 'ASSET':
      case 'LOCAL':
      case 'SECTOR':
        // String (ID) ou objeto {id, name}
        if (rawAnswer is Map) return rawAnswer;
        return rawAnswer.toString();

      case 'SIGNATURE':
        // Objeto {imageUrl, signedBy, signedAt}
        if (rawAnswer is Map) return rawAnswer;
        return null;

      case 'COLLECTION':
      case 'COLLECTIONS':
        // Array de objetos
        if (rawAnswer is List) return rawAnswer;
        return [];

      default:
        return rawAnswer;
    }
  }

  /// Cria objeto com metadados do arquivo a partir da URL do Firebase Storage
  Map<String, dynamic> _createFileObject(String url) {
    // Extrai o nome do arquivo da URL
    // URL format: https://firebasestorage.googleapis.com/.../filename.ext?token=...
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    final fileNameWithPath =
        pathSegments.isNotEmpty ? pathSegments.last : 'file';

    // Remove o path encoding (ex: maintenance%2Fforms%2F... -> apenas o nome do arquivo)
    final fileName = Uri.decodeComponent(fileNameWithPath.split('/').last);

    // Extrai a extensão
    final extension =
        fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';

    // Determina o contentType baseado na extensão
    final contentType = _getContentTypeFromExtension(extension);

    return {
      'url': url,
      'name': fileName,
      'contentType': contentType,
      'size': null, // Não temos essa informação sem fazer request adicional
    };
  }

  /// Retorna o MIME type baseado na extensão do arquivo
  String _getContentTypeFromExtension(String extension) {
    switch (extension) {
      // Imagens
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';

      // PDFs
      case 'pdf':
        return 'application/pdf';

      // Documentos
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

      // Vídeos
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';

      default:
        return 'application/octet-stream';
    }
  }

  void _onBackPressed(
      TaskInitStepBackPressedEvent event, Emitter<TaskInitStepState> emit) {
    // Sempre mostra dialog de reset porque ao abrir a tela já inicia uma sessão
    // que precisa ser resetada ao sair, independente de ter dados preenchidos
    emit(state.copyWith(dialog: TaskInitStepDialogType.reset));
  }

  void _onRequestReset(
      TaskInitStepRequestResetEvent event, Emitter<TaskInitStepState> emit) {
    // Mostra dialog de confirmação do reset
    emit(state.copyWith(dialog: TaskInitStepDialogType.reset));
  }

  Future<void> _onConfirmReset(
      TaskInitStepConfirmResetEvent event, Emitter<TaskInitStepState> emit) async {
    debugPrint('[TaskInitStepBloc] _onConfirmReset iniciado');
    // Fechar dialog
    emit(state.copyWith(dialog: TaskInitStepDialogType.none));

    // Usar o taskId correto (o ID original da task para fazer o reset)
    final taskId = state.taskId;

    if (taskId.isNotEmpty) {
      emit(state.copyWith(isLoading: true));

      final result = await _resetScheduleEventUseCase.call(taskId);

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Erro ao resetar evento: ${failure.toString()}',
          ));
        },
        (response) {
          // Reset realizado com sucesso, sai da tela
          emit(state.copyWith(
            isLoading: false,
            outcome: TaskInitStepStatus.reset,
          ));
        },
      );
    } else {
      // Se não há taskId, apenas descarta
      emit(state.copyWith(outcome: TaskInitStepStatus.discarded));
    }
  }

  void _onConfirmDiscard(
      TaskInitStepConfirmDiscardEvent event, Emitter<TaskInitStepState> emit) {
    emit(state.copyWith(
      dialog: TaskInitStepDialogType.none,
      outcome: TaskInitStepStatus.discarded,
    ));
  }

  void _onDialogDismissed(
      TaskInitStepDialogDismissedEvent event, Emitter<TaskInitStepState> emit) {
    emit(state.copyWith(dialog: TaskInitStepDialogType.none));
  }

  void _onOutcomeCleared(
      TaskInitStepStatusClearedEvent event, Emitter<TaskInitStepState> emit) {
    emit(state.copyWith(outcome: null));
  }
}
