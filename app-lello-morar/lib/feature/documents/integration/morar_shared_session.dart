import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

/// Adaptador da sessão do Morar para a abstração `SharedSession` consumida
/// pela feature compartilhada de documentos. Lê ao vivo do `SessionBloc` (não
/// é snapshot) — reflete troca de unidade/condomínio do morador.
class MorarSharedSession implements SharedSession {
  final SessionBloc sessionBloc;

  MorarSharedSession(this.sessionBloc);

  @override
  String get condominiumId =>
      sessionBloc.state.session?.condominium?.id ?? "";

  @override
  String get condominiumReference =>
      sessionBloc.state.session?.condominium?.reference?.toString() ?? "";

  @override
  String get unitId => sessionBloc.state.session?.unity?.id ?? "";

  @override
  String get userId => sessionBloc.state.session?.me?.id ?? "";
}
