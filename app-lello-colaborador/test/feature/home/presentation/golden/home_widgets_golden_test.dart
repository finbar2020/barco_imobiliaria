import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_not_connected_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_timer_widget.dart';
import 'package:colaborador/feature/home_cards_preferences/widgets/preferences_home_cards_widget.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_notification_checkbox.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('HomeTimerWidget renderiza relógio', (tester) async {
    await pumpApp(
      tester,
      const HomeTimerWidget(),
      localized: true,
      settle: false,
      surface: const Size(400, 140),
    );
    await tester.pump();
    expect(find.byType(HomeTimerWidget), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('golden — not connected dialog', (tester) async {
    await pumpApp(
      tester,
      const HomeNotConnectedDialogWidget(),
      localized: true,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_not_connected.png'),
    );
  });

  testWidgets('golden — proof card', (tester) async {
    await pumpApp(
      tester,
      ProofCardWidget(onTap: () {}, dateTimeClockIn: '08:00'),
      localized: true,
      surface: const Size(400, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_card.png'),
    );
  });

  testWidgets('golden — preferences notification checkbox', (tester) async {
    await pumpApp(
      tester,
      PreferencesNotificationCheckBox(
        onTap: () {},
        checked: true,
        title: 'notifications_marketing',
      ),
      localized: true,
      surface: const Size(400, 60),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_notification_checkbox.png'),
    );
  });

  testWidgets('golden — preferences home card favorito', (tester) async {
    await pumpApp(
      tester,
      PreferencesHomeCardWidget(
        imagePath: 'assets/ic_benefits.svg',
        text: 'digital_point_page_benefits',
        sessionBloc: FakeSessionBloc(),
        onTap: () {},
        isFavorite: true,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(240, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_home_card_fav.png'),
    );
  });
}
