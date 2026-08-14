import 'dart:math';

import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/vox/domain/entity/attachment_kind.dart';
import 'package:lello/feature/vox/domain/entity/document_attachment.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_step.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document.dart';
import 'package:lello/feature/vox/presentation/history/vox_history_cache.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_event.dart';
import 'package:lello/feature/vox/presentation/request/vox_reasons_cache.dart';
import 'package:lello/feature/vox/presentation/request/vox_templates_cache.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_state.dart';
import 'package:lello/feature/vox/presentation/request/vox_analytics.dart';

/// Bloc genérico do wizard de solicitação de documento (advertência/multa/
/// comunicado). Concreto e parametrizado por [DocumentType] — sem a indireção
/// abstrato/impl antiga (Q2). Todo o estado do form vive no state.
class VoxRequestBloc extends Bloc<VoxRequestEvent, VoxRequestState> {
  final DocumentType type;
  final DocumentMode mode;
  final SessionBloc sessionBloc;
  final RequestDocument requestDocument;
  final CreateDocument createDocument;
  final ListDocumentReasons listDocumentReasons;
  final ListDocumentTemplates listDocumentTemplates;
  final VoxHistoryCache historyCache;
  final VoxReasonsCache reasonsCache;
  final VoxTemplatesCache templatesCache;

  static const _order = [
    DocumentStep.data,
    DocumentStep.text,
    DocumentStep.review,
  ];

  VoxRequestBloc({
    required this.type,
    required this.mode,
    required this.sessionBloc,
    required this.requestDocument,
    required this.createDocument,
    required this.listDocumentReasons,
    required this.listDocumentTemplates,
    required this.historyCache,
    required this.reasonsCache,
    required this.templatesCache,
  }) : super(VoxRequestState.initial(type)) {
    on<VoxStartedEvent>(_onStarted);
    on<VoxStepRequestedEvent>(_onStepRequested);
    on<VoxFilesAttachedEvent>(_onFilesAttached);
    on<VoxImageAttachedEvent>(_onImageAttached);
    on<VoxAttachmentRemovedEvent>(_onAttachmentRemoved);
    on<VoxFieldChangedEvent>(
        (event, emit) => emit(state.copyWith(status: state.status)));
    on<VoxSubmittedEvent>(_onSubmitted);
    add(const VoxStartedEvent());
  }

  String get _condominiumId =>
      sessionBloc.state.session?.selectedCondominium?.id ?? "";

  String get _reference =>
      sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
      "";

  Future<void> _onStarted(
      VoxStartedEvent event, Emitter<VoxRequestState> emit) async {
    ManagerAnalyticsLogEvents.logEvent(
        event: VoxAnalytics.access(type, mode), referenceValue: _reference);

    emit(state.copyWith(status: VoxRequestStatus.loading));
    final condominiumId = _condominiumId;

    if (type.hasReasons) {
      // Cache agressivo (24h): motivos quase nunca mudam.
      final cached = reasonsCache.get(type, condominiumId);
      if (cached != null) {
        emit(state.copyWith(reasons: cached));
      } else {
        final result = await listDocumentReasons(ListDocumentReasonsParam(
            type: type, condominiumId: condominiumId));
        final failed = result.fold((err) {
          emit(state.copyWith(status: VoxRequestStatus.failure, error: err));
          return true;
        }, (data) {
          reasonsCache.put(type, condominiumId, data);
          emit(state.copyWith(reasons: data));
          return false;
        });
        if (failed) return;
      }
    }

    if (type.usesTemplates(mode)) {
      // Cache agressivo (24h): modelos ("quem assina") quase nunca mudam.
      final cached = templatesCache.get(type, condominiumId);
      if (cached != null) {
        emit(state.copyWith(templates: cached));
      } else {
        final result = await listDocumentTemplates(ListDocumentTemplatesParam(
            type: type, condominiumId: condominiumId));
        final failed = result.fold((err) {
          emit(state.copyWith(status: VoxRequestStatus.failure, error: err));
          return true;
        }, (data) {
          templatesCache.put(type, condominiumId, data);
          emit(state.copyWith(templates: data));
          return false;
        });
        if (failed) return;
      }
    }

    emit(state.copyWith(status: VoxRequestStatus.ready));
  }

  void _onStepRequested(
      VoxStepRequestedEvent event, Emitter<VoxRequestState> emit) {
    emit(state.copyWith(step: event.step));
  }

  void _onFilesAttached(
      VoxFilesAttachedEvent event, Emitter<VoxRequestState> emit) {
    emit(state.copyWith(files: [...state.files, ...event.files]));
  }

  void _onImageAttached(
      VoxImageAttachedEvent event, Emitter<VoxRequestState> emit) {
    emit(state.copyWith(images: [...state.images, event.image]));
  }

  void _onAttachmentRemoved(
      VoxAttachmentRemovedEvent event, Emitter<VoxRequestState> emit) {
    switch (event.kind) {
      case AttachmentKind.file:
        final files = [...state.files]..removeAt(event.index);
        emit(state.copyWith(files: files));
        break;
      case AttachmentKind.image:
        final images = [...state.images]..removeAt(event.index);
        emit(state.copyWith(images: images));
        break;
    }
  }

  Future<void> _onSubmitted(
      VoxSubmittedEvent event, Emitter<VoxRequestState> emit) async {
    emit(state.copyWith(status: VoxRequestStatus.submitting));

    final request = state.request;
    request.condominiumId = _condominiumId;
    request.recipientList = request.recipientListMap.values.toList();
    // 'Todos' (solicitação) não seleciona unidades; o fio espera um único
    // item 'TODOS' no recipientList (fiel ao contrato antigo).
    if (mode == DocumentMode.request &&
        request.recipientType == RecipientType.all) {
      request.recipientList = ['TODOS'];
    }

    final Try<String> result;
    if (mode == DocumentMode.create) {
      // Criação direta: unidade do primeiro destinatário; sem anexos.
      request.unityId = request.recipientListMap.values.isNotEmpty
          ? request.recipientListMap.values.first
          : null;
      result = await createDocument(CreateDocumentParam(
        type: type,
        condominiumId: _condominiumId,
        request: request,
      ));
    } else {
      // Solicitação: anexos (BYTES crus; o model encoda Base64, B5) + flags.
      final attachments = <DocumentAttachment>[];
      for (final file in state.files) {
        attachments.add(DocumentAttachment(
          type: "application/pdf",
          name: basename(file.path),
          bytes: await file.readAsBytes(),
        ));
      }
      for (final image in state.images) {
        attachments.add(DocumentAttachment(
          type: "image/png",
          name: "${Random.secure().nextInt(9999)}",
          bytes: await image.readAsBytes(),
        ));
      }
      request.attachments = attachments;
      request.flagEmailBodyAttachment = false;
      request.flagEmailDistribution = false;
      request.unityId = null;
      result = await requestDocument(RequestDocumentParam(
        type: type,
        condominiumId: _condominiumId,
        request: request,
      ));
    }

    result.fold(
      (err) =>
          emit(state.copyWith(status: VoxRequestStatus.failure, error: err)),
      (_) {
        // O novo documento invalida o histórico cacheado do tipo.
        historyCache.invalidate(type, _condominiumId);
        ManagerAnalyticsLogEvents.logEvent(
            event: VoxAnalytics.finish(type, mode), referenceValue: _reference);
        emit(state.copyWith(status: VoxRequestStatus.success));
      },
    );
  }

  /// Avança um passo. Retorna nada; a UI escuta o state.
  void goNext() {
    final index = _order.indexOf(state.step);
    if (index < _order.length - 1) {
      add(VoxStepRequestedEvent(_order[index + 1]));
    }
  }

  /// Volta um passo. Retorna `true` se já estava no primeiro (pode sair da tela).
  bool goBack() {
    final index = _order.indexOf(state.step);
    if (index > 0) {
      add(VoxStepRequestedEvent(_order[index - 1]));
      return false;
    }
    return true;
  }
}
