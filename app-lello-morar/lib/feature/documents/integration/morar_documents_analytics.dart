import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_analytics.dart';

/// Analytics da feature de documentos no Morar (eventos do morador/owner).
/// Puxa userId/unidade/referência da sessão do app.
class MorarDocumentsAnalytics implements DocumentsAnalytics {
  final SessionBloc sessionBloc;

  MorarDocumentsAnalytics(this.sessionBloc);

  String get _userId => sessionBloc.state.session?.me?.id ?? "";
  String get _unit => sessionBloc.state.session?.unity?.title?.toString() ?? "";
  String get _reference =>
      sessionBloc.state.session?.condominium?.reference?.toString() ?? "";

  void _log(dynamic event) {
    OwnerAnalyticsLogEvents.logEvent(
      event: event,
      userId: _userId,
      unitValue: _unit,
      referenceValue: _reference,
    );
  }

  @override
  void logAccess(String documentType) {
    switch (documentType) {
      case "documents_minutes":
        _log(AnalyticsEventsOwner.documentosAtasAcessar());
        break;
      case "documents_notices":
        _log(AnalyticsEventsOwner.documentosEditaisAcessar());
        break;
      case "documents_circulars":
        _log(AnalyticsEventsOwner.documentosCircularesAcessar());
        break;
      case "documents_divers":
        _log(AnalyticsEventsOwner.documentosDiversosAcessar());
        break;
    }
  }

  @override
  void logShare(String documentType) {
    _log(AnalyticsEventsOwner.documentosAcessarCompartilhar());
  }
}
