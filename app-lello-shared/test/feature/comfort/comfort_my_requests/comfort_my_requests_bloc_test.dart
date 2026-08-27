import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';

import 'comfort_requests_test_support.dart';

void main() {
  late ComfortMyRequestsBloc bloc;

  setUp(() => bloc = ComfortMyRequestsBloc());
  tearDown(() => bloc.close());

  test('estado inicial é carregando', () {
    expect(bloc.state, const LoadingComfortMyRequestsState());
  });

  test('cada evento emite o estado correspondente', () async {
    final request = buildRequest();
    final subcategories = [ComfortSubcategories(comfortType: ComfortType.gym)];
    final states = <ComfortMyRequestsState>[];
    final sub = bloc.stream.listen(states.add);

    bloc
      ..add(const EmptyComfortMyRequestsEvent())
      ..add(const SuccessComfortMyRequestsEvent())
      ..add(const ErrorComfortMyRequestsEvent(
          errorMessageKey: 'erro', errorCode: '500', errorDescription: 'desc'))
      ..add(LoadedMyRequestsEvent(
          myRequests: [request],
          flushbarMessage: 'msg',
          selectedRequest: request))
      ..add(LoadedRateRequestEvent(selectedRequest: request, flushbarMessage: 'f'))
      ..add(const LoadingComfortMyRequestsEvent())
      ..add(LoadedSubcategoriesMyRequestEvent(
          subcategories: subcategories, flushbarMessage: 'f'));
    await flush();
    await sub.cancel();

    expect(states, [
      const EmptyComfortMyRequestsState(),
      const SuccessComfortMyRequestsState(),
      const ErrorComfortMyRequestsState(errorMessageKey: 'erro'),
      LoadedMyRequestsState(
          myRequests: [request], flushbarMessage: 'msg', selectedRequest: request),
      LoadedRateRequestState(selectedRequest: request),
      const LoadingComfortMyRequestsState(),
      LoadedSubcategoriesMyRequestState(subcategories: subcategories),
    ]);
    /// Defeito: o handler de erro descarta `errorCode` e `errorDescription`
    /// do evento; o estado só carrega a chave da mensagem.
    final error = states[2] as ErrorComfortMyRequestsState;
    expect(error.errorCode, isNull);
    expect(error.errorDescription, isNull);

    /// Defeito: os handlers de LoadedRateRequestEvent e
    /// LoadedSubcategoriesMyRequestEvent também descartam `flushbarMessage`.
    expect((states[4] as LoadedRateRequestState).flushbarMessage, isNull);
    expect((states[6] as LoadedSubcategoriesMyRequestState).flushbarMessage,
        isNull);
  });

  test('props dos eventos e estados consideram todos os campos', () {
    final request = buildRequest();
    expect(
      const ErrorComfortMyRequestsEvent(
          errorMessageKey: 'a', errorCode: '1', errorDescription: 'd'),
      const ErrorComfortMyRequestsEvent(
          errorMessageKey: 'a', errorCode: '1', errorDescription: 'd'),
    );
    expect(
      const ErrorComfortMyRequestsEvent(
          errorMessageKey: 'a', errorCode: '1', errorDescription: 'd'),
      isNot(const ErrorComfortMyRequestsEvent(
          errorMessageKey: 'a', errorCode: '2', errorDescription: 'd')),
    );
    expect(LoadedRateRequestEvent(selectedRequest: request).props,
        [request, null]);
    expect(
        LoadedRateRequestEvent(selectedRequest: request, flushbarMessage: 'x'),
        isNot(LoadedRateRequestEvent(selectedRequest: request)));
    expect(const LoadedSubcategoriesMyRequestEvent(subcategories: []).props,
        [[], null]);
    expect(const LoadedSubcategoriesMyRequestEvent(subcategories: []),
        const LoadedSubcategoriesMyRequestEvent(subcategories: []));
    expect(const EmptyComfortMyRequestsEvent().props, isEmpty);
    expect(const EmptyComfortMyRequestsState().props, isEmpty);
    expect(
        const ErrorComfortMyRequestsState(
                errorMessageKey: 'a', errorCode: '1', errorDescription: 'd')
            .props,
        ['a', 'd', '1']);
    expect(LoadedMyRequestsState(myRequests: [request]).props,
        [[request], null, null]);
    expect(LoadedRateRequestState(selectedRequest: request, flushbarMessage: 'm').props,
        [request, 'm']);
    expect(const LoadedSubcategoriesMyRequestState(subcategories: [], flushbarMessage: 'm').props,
        [[], 'm']);
  });
}
