import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state);

  final MeState _state;

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => Stream.value(_state);
}

void main() {
  final me = testMe();

  testWidgets('golden — edit phone info telefone', (tester) async {
    await pumpApp(
      tester,
      MeEditPhoneInfo(
        bloc: _FakeMeBloc(MeEditPhoneChangedState(me: me, isPhone: true)),
        isPhoneCheck: true,
        isEmailCheck: false,
      ),
      localized: true,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_edit_phone.png'),
    );
  });

  testWidgets('golden — edit phone info e-mail', (tester) async {
    await pumpApp(
      tester,
      MeEditPhoneInfo(
        bloc: _FakeMeBloc(MeEditPhoneChangedState(me: me, isEmail: true)),
        isPhoneCheck: false,
        isEmailCheck: true,
      ),
      localized: true,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_edit_email.png'),
    );
  });

  testWidgets('golden — edit phone solicita código', (tester) async {
    await pumpApp(
      tester,
      MeEditPhoneInfo(
        bloc: _FakeMeBloc(MeEditRequestingCodeState(me)),
        isPhoneCheck: true,
        isEmailCheck: false,
      ),
      localized: true,
      settle: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_edit_phone_loading.png'),
    );
  });

  testWidgets('golden — edit phone falha ao solicitar código', (tester) async {
    await pumpApp(
      tester,
      MeEditPhoneInfo(
        bloc: _FakeMeBloc(
          MeEditRequestCodeFailedState(me, UnknownFailure('fail')),
        ),
        isPhoneCheck: true,
        isEmailCheck: false,
      ),
      localized: true,
      surface: const Size(400, 560),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_edit_phone_failed.png'),
    );
  });
}
