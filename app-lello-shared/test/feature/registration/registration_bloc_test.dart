import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'registration_support.dart';

void main() {
  test('estado inicial é vazio', () {
    final bloc = RegistrationBloc();
    expect(bloc.state, const RegistrationEmptyState());
    bloc.close();
  });

  test('cada evento emite o estado correspondente', () async {
    final bloc = RegistrationBloc();
    final erro = RegistrationAuthFailure();
    final codeData = buildCodeData();
    final request = CodeRequest(
        source: CodeValidationSource.email,
        origin: CodeValidationOrigin.registration,
        value: 'v',
        token: '');
    final states = <RegistrationState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const RegistrationLoadingEvent(loadingMessage: 'm'));
    bloc.add(const RegistrationCodeRequestLoadingEvent(loadingMessage: 'm'));
    bloc.add(RegistrationCodeRequestFailedEvent(error: erro));
    bloc.add(RegistrationRequestMyUserFailedEvent(error: erro));
    bloc.add(const RegistrationRequestMyUserLoadingEvent(
        cpf: 'c', loadingMessage: 'busca'));
    bloc.add(RegistrationRequestMyUserSucceededEvent(
        codeData: codeData, selectedValue: 's', type: CodeValidationSource.phone));
    bloc.add(RegistrationCodeRequestSucceededEvent(codeRequest: request));
    bloc.add(RegistrationFailedEvent(error: erro));
    bloc.add(RegistrationAuthFailedEvent(error: erro));
    bloc.add(const RegistrationSucceededEvent());
    bloc.add(const RegistrationEmptyEvent());
    for (var i = 0; i < 3; i++) {
      await Future<void>.delayed(Duration.zero);
    }

    expect(states, [
      const RegistrationLoadingState(),
      const RegistrationCodeRequestLoadingState(),
      RegistrationCodeRequestFailedState(error: erro),
      RegistrationRequestMyUserFailedState(error: erro),
      const RegistrationRequestMyUserLoadingState(loadingMessage: 'busca'),
      RegistrationRequestMyUserSucceededState(
          codeData: codeData, selectedValue: 's', type: CodeValidationSource.phone),
      RegistrationCodeRequestSucceededState(codeRequest: request),
      RegistrationFailedState(error: erro),
      RegistrationAuthFailedState(error: erro),
      const RegistrationSucceededState(),
      const RegistrationEmptyState(),
    ]);
    await sub.cancel();
    await bloc.close();
  });
}
