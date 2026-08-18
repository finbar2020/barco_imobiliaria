import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_password.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state, {this.onSave});

  final MeState _state;
  final void Function(String newPassword, String originPassword)? onSave;
  String? savedNewPassword;
  String? savedOriginPassword;

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => Stream.value(_state);

  @override
  void beginEditSavePassword(password, originPassword) {
    savedNewPassword = password as String?;
    savedOriginPassword = originPassword as String?;
    onSave?.call(password as String, originPassword as String);
  }
}

Widget _wrap(MeBloc bloc) => BlocProvider<MeBloc>.value(
      value: bloc,
      child: const MeEditPassword(),
    );

void main() {
  final me = testMe();

  testWidgets('renderiza formulário de senha', (tester) async {
    await installTestValidator();
    addTearDown(resetTestApplicationContainer);

    await pumpApp(
      tester,
      _wrap(_FakeMeBloc(MeLoadedState(me))),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    expect(find.text('origin_password'), findsOneWidget);
    expect(find.text('new_password'), findsOneWidget);
    expect(find.text('save'), findsOneWidget);
  });

  testWidgets('alterna visibilidade das senhas', (tester) async {
    await installTestValidator();
    addTearDown(resetTestApplicationContainer);

    await pumpApp(
      tester,
      _wrap(_FakeMeBloc(MeLoadedState(me))),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pump();
    expect(find.byIcon(Icons.visibility), findsWidgets);
  });

  testWidgets('exibe erro ao falhar salvamento', (tester) async {
    await installTestValidator();
    addTearDown(resetTestApplicationContainer);

    await pumpApp(
      tester,
      _wrap(
        _FakeMeBloc(
          MeEditPasswordFailedState(
            me,
            'old',
            'new',
            KnownFailure('400', 'fail'),
          ),
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    expect(find.text('income_control_error'), findsOneWidget);
  });

  testWidgets('exibe loading ao salvar', (tester) async {
    await installTestValidator();
    addTearDown(resetTestApplicationContainer);

    await pumpApp(
      tester,
      _wrap(_FakeMeBloc(MeEditPasswordLoadingState(me, 'old', 'new'))),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('save'), findsNothing);
  });

  testWidgets('salva senha quando formulário é válido', (tester) async {
    await installTestValidator();
    addTearDown(resetTestApplicationContainer);
    final bloc = _FakeMeBloc(MeLoadedState(me));

    await pumpApp(
      tester,
      _wrap(bloc),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'type_password').at(0),
      'Senha@123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'type_password').at(1),
      'Nova@1234',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'type_password').at(2),
      'Nova@1234',
    );
    await tester.tap(find.text('save'));
    await tester.pump();

    expect(bloc.savedNewPassword, 'Nova@1234');
    expect(bloc.savedOriginPassword, 'Senha@123');
  });
}
