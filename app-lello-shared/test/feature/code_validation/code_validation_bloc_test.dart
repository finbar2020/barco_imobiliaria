import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  test('estado inicial é vazio', () {
    final bloc = CodeValidationBloc();
    expect(bloc.state, const CodeValidationEmptyState());
    bloc.close();
  });

  test('cada evento emite o estado correspondente', () async {
    final bloc = CodeValidationBloc();
    final validation = CodeValidation(id: 'I', code: '1234', token: 't');
    final erro = InvalidCodeValidationFailure();
    final states = <CodeValidationState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const CodeValidationLoadingEvent());
    bloc.add(CodeValidationSucceededEvent(validation: validation));
    bloc.add(CodeValidationResendEvent(validation: validation));
    bloc.add(CodeValidationFailedEvent(error: erro));
    bloc.add(const CodeValidationEmptyEvent());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(states, [
      const CodeValidationValidatingState(),
      CodeValidationSucceededState(validation: validation),
      CodeValidationResendState(validation: validation),
      CodeValidationFailedState(error: erro),
      const CodeValidationEmptyState(),
    ]);
    await sub.cancel();
    await bloc.close();
  });
}
