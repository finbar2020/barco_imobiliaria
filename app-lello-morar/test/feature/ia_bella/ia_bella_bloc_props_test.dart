import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_event.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_state.dart';

void main() {
  test('eventos da Bella expõem seus props para igualdade', () {
    expect(const IaBellaEmptyEvent().props, isEmpty);
    expect(const IaBellaLoadingEvent().props, isEmpty);
    expect(const IaBellaStartSessionEvent().props, isEmpty);
    expect(const IaBellaStartSessionErrorEvent().props, isEmpty);
    expect(const IaBellaFinalEvaluationEvent().props, isEmpty);
    expect(const IaBellaFinalEvaluationErrorEvent().props, isEmpty);
    expect(const IaBellaFinalEvaluationSuccessEvent().props, isEmpty);
    expect(const IaBellaLoadedEvent(['a']).props, [
      ['a']
    ]);
    expect(const IaBellaSessionStartedEvent('s').props, ['s']);
    expect(const IaBellaDownloadPdfEvent('d').props, ['d']);
    expect(const IaBellaDownloadingEvent('d').props, ['d']);
    expect(const IaBellaDownloadPdfSuccessEvent('d').props, ['d']);
    expect(const IaBellaRenderPdfEvent('d').props, ['d']);
    expect(const IaBellaRenderingPdfEvent('d').props, ['d']);
    expect(const IaBellaRenderPdfSuccessEvent('d').props, ['d']);
    expect(const IaBellaSendMessageEvent('m').props, ['m']);
    expect(const IaBellaRateMessageEvent('r').props, ['r']);
    expect(const IaBellaRateMessageSuccessEvent('r').props, ['r']);
    expect(const IaBellaErrorEvent('e').props, ['e']);
    expect(const IaBellaReceiveMessageEvent('x').props, ['x']);
    expect(const IaBellaLoadedEvent(['a']), const IaBellaLoadedEvent(['a']));
    expect(const IaBellaErrorEvent('e'), isNot(const IaBellaErrorEvent('f')));
  });

  test('estados da Bella expõem seus props para igualdade', () {
    expect(const IaBellaInitialState().props, isEmpty);
    expect(const IaBellaLoadingState().props, isEmpty);
    expect(const IaBellaStartSessionState().props, isEmpty);
    expect(const IaBellaStartSessionErrorState().props, isEmpty);
    expect(const IaBellaFinalEvaluationState().props, isEmpty);
    expect(const IaBellaFinalEvaluationErrorState().props, isEmpty);
    expect(const IaBellaFinalEvaluationSuccessState().props, isEmpty);
    expect(const IaBellaDownloadPdfSuccessState().props, isEmpty);
    expect(const IaBellaLoadedState(['a']).props, [
      ['a']
    ]);
    expect(const IaBellaSessionStartedState('s').props, ['s']);
    expect(const IaBellaSendMessageState('m').props, ['m']);
    expect(const IaBellaReceiveMessageState('r').props, ['r']);
    expect(const IaBellaDownloadPdfState('d').props, ['d']);
    expect(const IaBellaDownloadingState('d').props, ['d']);
    expect(const IaBellaRenderPdfState('d').props, ['d']);
    expect(const IaBellaRenderingPdfState('d').props, ['d']);
    expect(const IaBellaRenderPdfSuccessState('d').props, ['d']);
    expect(const IaBellaRateMessageState('r').props, ['r']);
    expect(const IaBellaRateMessageSuccessState('r').props, ['r']);
    expect(const IaBellaErrorState('e').props, ['e']);
    expect(const IaBellaInitialState(), const IaBellaInitialState());
  });
}
