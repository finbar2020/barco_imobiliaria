import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Eventos de analytics por (tipo, modo) de documento, preservados 1-pra-1 dos
/// fluxos antigos (solicitar/criar advertência/multa/comunicado).
class VoxAnalytics {
  /// Evento de acesso à tela.
  static AnalyticsEvent access(DocumentType type, DocumentMode mode) {
    switch (type) {
      case DocumentType.warning:
        return AnalyticsEventsManager.criarSolicitarAdvertAcessar(
            mode == DocumentMode.create ? "read_create" : "read_request");
      case DocumentType.fine:
        return AnalyticsEventsManager.solicitarMultaAcessar();
      case DocumentType.announcement:
        return mode == DocumentMode.create
            ? AnalyticsEventsManager.criarComunicadosAcessar()
            : AnalyticsEventsManager.solicitarComunicadosAcessar();
    }
  }

  /// Evento de conclusão.
  static AnalyticsEvent finish(DocumentType type, DocumentMode mode) {
    switch (type) {
      case DocumentType.warning:
        return AnalyticsEventsManager.criarSolicitarAdvertFinalizado(
            mode == DocumentMode.create ? "write_create" : "write_request");
      case DocumentType.fine:
        return AnalyticsEventsManager.solicitarMultaFinalizado("write_request");
      case DocumentType.announcement:
        return mode == DocumentMode.create
            ? AnalyticsEventsManager.criarComunicadosFinalizado()
            : AnalyticsEventsManager.solicitarComunicadosFinalizado();
    }
  }
}
