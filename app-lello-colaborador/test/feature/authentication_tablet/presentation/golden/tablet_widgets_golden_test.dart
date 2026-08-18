import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_fill_condo_code_widget.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:colaborador/feature/home_cards_preferences/pages/preferences_home_cards_onboarding_page.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

class _OnboardingSessionBloc extends Fake implements SessionBloc {
  @override
  SessionState get state => SessionLoadedState(
        session: testSession(),
        isTabletSession: false,
      );

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  Session? get getSession => testSession();

  @override
  bool checkRback(String rbac) => true;
}

void main() {
  testWidgets('golden — login tablet condo code', (tester) async {
    final controller = TextEditingController(text: '123456');
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/login_tablet_condo_code.png'),
    );
  });

  testWidgets('golden — login tablet condo code erro', (tester) async {
    final controller = TextEditingController(text: '000');
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
        isFailure: true,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/login_tablet_condo_code_error.png'),
    );
  });

  testWidgets('golden — preferences cards onboarding', (tester) async {
    final cardsBloc = PreferencesHomeCardsBloc();
    addTearDown(cardsBloc.close);
    final controller = PreferencesHomeCardsController(
      bloc: cardsBloc,
      sessionBloc: _OnboardingSessionBloc(),
    );

    await pumpApp(
      tester,
      PreferencesHomeCardsOnboardingPage(controller: controller),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_cards_onboarding.png'),
    );
  });
}
