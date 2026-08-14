import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

/// Adaptador da sessão do Síndico para a abstração `SharedSession` consumida
/// pela feature compartilhada de documentos. Lê ao vivo do `SessionBloc`.
/// O síndico atua no condomínio selecionado e NÃO tem unidade → `unitId` vazio
/// (a listagem cai no escopo do condomínio).
class SindicoSharedSession implements SharedSession {
  final SessionBloc sessionBloc;

  SindicoSharedSession(this.sessionBloc);

  @override
  String get condominiumId =>
      sessionBloc.state.session?.selectedCondominium?.id ?? "";

  @override
  String get condominiumReference =>
      sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
      "";

  @override
  String get unitId => "";

  @override
  String get userId => sessionBloc.state.session?.me?.id ?? "";
}
