import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state);

  final MeState _state;
  bool? requestedPhone;
  bool? requestedEmail;

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => Stream.value(_state);

  @override
  void beginCodeRequest({
    required bool isPhoneCheck,
    required bool isEmailCheck,
  }) {
    requestedPhone = isPhoneCheck;
    requestedEmail = isEmailCheck;
  }
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<_FakeMeBloc> _pumpInfo(
  WidgetTester tester, {
  required MeState state,
  bool isPhoneCheck = true,
  bool isEmailCheck = false,
}) async {
  final bloc = _FakeMeBloc(state);
  await pumpApp(
    tester,
    MeEditPhoneInfo(
      bloc: bloc,
      isPhoneCheck: isPhoneCheck,
      isEmailCheck: isEmailCheck,
    ),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 800),
  );
  await tester.pump();
  return bloc;
}

Me _me() => testMe();

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('MeEditPhoneInfo', () {
    testWidgets('explica a validação por telefone', (tester) async {
      await _pumpInfo(tester, state: MeEditPhoneChangedState(me: _me()));

      expect(find.text('profile_change_phone_rationale'), findsOneWidget);
      expect(find.text('receive_code'), findsOneWidget);
      expect(find.text('cancel'), findsOneWidget);
    });

    testWidgets('explica a validação por email', (tester) async {
      await _pumpInfo(
        tester,
        state: MeEditPhoneChangedState(me: _me()),
        isPhoneCheck: false,
        isEmailCheck: true,
      );

      expect(find.text('profile_change_email_rationale'), findsOneWidget);
      expect(find.byIcon(Icons.mail_lock), findsOneWidget);
    });

    testWidgets('pede o código para o canal escolhido', (tester) async {
      final bloc = await _pumpInfo(
        tester,
        state: MeEditPhoneChangedState(me: _me()),
      );

      await tester.tap(find.text('receive_code'));
      await tester.pump();

      expect(bloc.requestedPhone, isTrue);
      expect(bloc.requestedEmail, isFalse);
    });

    testWidgets('enquanto solicita o código mostra o indicador',
        (tester) async {
      await _pumpInfo(tester, state: MeEditRequestingCodeState(_me()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('receive_code'), findsNothing);
    });

    testWidgets('falha ao solicitar o código exibe o erro', (tester) async {
      await _pumpInfo(
        tester,
        state: MeEditRequestCodeFailedState(_me(), KnownFailure('400', 'x')),
      );

      expect(find.text('request_validation_code_failed'), findsOneWidget);
    });

    testWidgets('sem contato cadastrado avisa o colaborador', (tester) async {
      await _pumpInfo(tester, state: MeEditNoContactAvailableState(_me()));

      expect(
        find.text('registration_phone_email_empty_dialog_description'),
        findsOneWidget,
      );
    });
  });
}
