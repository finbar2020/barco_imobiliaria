import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_analytics.dart';

/// Analytics da feature de documentos no Síndico (eventos de gestor/manager).
/// O catálogo do síndico tem um único evento de acesso a documentos
/// (`docsCondominioAcessar`) e nenhum evento de compartilhamento.
class SindicoDocumentsAnalytics implements DocumentsAnalytics {
  final SessionBloc sessionBloc;

  SindicoDocumentsAnalytics(this.sessionBloc);

  String get _reference =>
      sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
      "";

  @override
  void logAccess(String documentType) {
    ManagerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.docsCondominioAcessar(),
      referenceValue: _reference,
    );
  }

  @override
  void logShare(String documentType) {
    // Sem evento de compartilhamento de documentos no catálogo do síndico.
  }
}
