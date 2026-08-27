import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';

import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortMyRequestItemActionsBloc bloc;

  setUp(() => bloc = ComfortMyRequestItemActionsBloc());
  tearDown(() => bloc.close());

  test('estado inicial', () {
    expect(bloc.state, const ComfortMyRequestItemActionsInitialState());
  });

  test('eventos emitem os estados correspondentes', () async {
    final request = buildRequest();
    final states = <ComfortMyRequestItemActionsState>[];
    final sub = bloc.stream.listen(states.add);

    bloc
      ..add(ComfortMyRequestItemActionsLoadedEvent(request))
      ..add(ComfortMyRequestItemActionsLoadingEvent(
          request, ComfortMyRequestItemActions.resend))
      ..add(ComfortMyRequestItemActionsErrorEvent(
          request: request,
          action: ComfortMyRequestItemActions.cancel,
          errorMessageKey: 'erro',
          errorCode: '500',
          errorDescription: 'desc'))
      ..add(ComfortMyRequestItemActionsSuccessEvent(
          request, ComfortMyRequestItemActions.rate));
    await flush();
    await sub.cancel();

    /// Defeito: Loading/Error/Success herdam de LoadedEvent, então o handler
    /// `on<ComfortMyRequestItemActionsLoadedEvent>` também roda para eles e
    /// um `LoadedState` intermediário é emitido antes de cada estado
    /// específico (a tela pisca o corpo carregado antes do loading).
    expect(states, [
      ComfortMyRequestItemActionsLoadedState(request),
      ComfortMyRequestItemActionsLoadingState(
          ComfortMyRequestItemActions.resend, request),
      ComfortMyRequestItemActionsLoadedState(request),
      ComfortMyRequestItemActionsErrorState(
          request: request,
          action: ComfortMyRequestItemActions.cancel,
          errorMessageKey: 'erro',
          errorCode: '500',
          errorDescription: 'desc'),
      ComfortMyRequestItemActionsLoadedState(request),
      ComfortMyRequestItemActionsSuccessState(
          ComfortMyRequestItemActions.rate, request),
    ]);
  });

  test('props de eventos e estados', () {
    final request = buildRequest();
    expect(ComfortMyRequestItemActionsLoadedEvent(request).props, [request]);
    expect(
        ComfortMyRequestItemActionsLoadingEvent(
                request, ComfortMyRequestItemActions.message)
            .props,
        [request, ComfortMyRequestItemActions.message]);
    expect(
        ComfortMyRequestItemActionsErrorEvent(
                request: request,
                action: ComfortMyRequestItemActions.rate,
                errorMessageKey: 'k')
            .props,
        [request, ComfortMyRequestItemActions.rate, 'k', null, null]);
    expect(
        ComfortMyRequestItemActionsSuccessEvent(
                request, ComfortMyRequestItemActions.cancel)
            .props,
        [request, ComfortMyRequestItemActions.cancel]);
    expect(const ComfortMyRequestItemActionsInitialState().props, isEmpty);
    expect(ComfortMyRequestItemActionsLoadedState(request).props, [request]);
    expect(
        ComfortMyRequestItemActionsLoadingState(
                ComfortMyRequestItemActions.resend, request)
            .props,
        [request, ComfortMyRequestItemActions.resend]);
    expect(
        ComfortMyRequestItemActionsErrorState(
                request: request,
                action: ComfortMyRequestItemActions.rate,
                errorMessageKey: 'k',
                errorCode: '1',
                errorDescription: 'd')
            .props,
        [request, ComfortMyRequestItemActions.rate, 'k', 'd', '1']);
    expect(
        ComfortMyRequestItemActionsSuccessState(
                ComfortMyRequestItemActions.message, request)
            .props,
        [request, ComfortMyRequestItemActions.message]);
    // Loading/Error/Success herdam de Loaded.
    expect(
        ComfortMyRequestItemActionsSuccessState(
            ComfortMyRequestItemActions.message, request),
        isA<ComfortMyRequestItemActionsLoadedState>());
  });
}
