import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinMenuController {
  final ResinMenuBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinParams getResinParams;

  ResinMenuController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinParams,
  });

  menuGetParams() async {
    bloc.add(ResinMenuLoadingsEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //buscaRemote
    final response = await getResinParams
        .call(GetResinParamsParams(condominiumId: condominiumId));

    response.fold(
        (error) => bloc.add(
            ResinMenuErrorEvent(errorMessageKey: "resin_get_params_error")),
        (data) {
      bloc.add(ResinMenuLoadedEvent(params: data));
    });
  }
}
