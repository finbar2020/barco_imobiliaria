import 'dart:async';

import 'package:colaborador/feature/digital_point/presentation/page/face_request_error_page.dart';
import 'package:colaborador/feature/home/presentation/page/home_navigation_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

FaceRequestErrorPageArgs _args([Exception? ex]) => FaceRequestErrorPageArgs(
      statusEnum: DigitalTimesheetStatusEnum.approved,
      isOnline: true,
      knowException: ex,
      employee: null,
    );

void main() {
  testWidgets('golden — loading home', (tester) async {
    await pumpApp(
      tester,
      const LoadingHomeWidget(),
      localized: true,
      wrapInScaffold: false,
      settle: false,
      surface: const Size(400, 400),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/loading_home.png'),
    );
  });

  testWidgets('golden — face error genérico', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          settings: RouteSettings(arguments: _args()),
          builder: (_) => const FaceRequestErrorPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/face_error_generic.png'),
    );
  });

  testWidgets('golden — face error sem rosto', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          settings: RouteSettings(arguments: _args(const FormatException())),
          builder: (_) => const FaceRequestErrorPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/face_error_no_face.png'),
    );
  });

  testWidgets('golden — face error timeout', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          settings: RouteSettings(arguments: _args(TimeoutException('loc'))),
          builder: (_) => const FaceRequestErrorPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/face_error_timeout.png'),
    );
  });

  testWidgets('golden — preferences checkbox', (tester) async {
    await pumpApp(
      tester,
      PreferencesCheckBox(onTap: () {}, checked: true),
      localized: true,
      surface: const Size(80, 60),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_checkbox.png'),
    );
  });
}
