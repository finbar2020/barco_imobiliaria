import 'dart:async';

import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_request_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/location_timeout_error_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

class _Pumped {
  _Pumped(this.routes, this.arguments);

  final List<String> routes;
  final List<Object?> arguments;
}

Future<_Pumped> _pumpErrorPage(
  WidgetTester tester, {
  required Widget page,
  required Object args,
}) async {
  final routes = <String>[];
  final arguments = <Object?>[];

  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        routes.add(settings.name ?? Navigator.defaultRouteName);
        arguments.add(settings.arguments);
        if (settings.name == ApplicationRoute.faceDetectionView) {
          return MaterialPageRoute(builder: (_) => const SizedBox());
        }
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name, arguments: args),
          builder: (_) => page,
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 900),
  );
  await tester.pump();

  return _Pumped(routes, arguments);
}

void main() {
  group('LocationTimeoutErrorPage', () {
    testWidgets('explica a falha de localização', (tester) async {
      await _pumpErrorPage(
        tester,
        page: const LocationTimeoutErrorPage(),
        args: LocationTimeoutErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          employee: null,
          condoRef: null,
        ),
      );

      expect(find.text('location_capture_error'), findsOneWidget);
      expect(
        find.text('face_register_error_location_timeout'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.location_off_rounded), findsOneWidget);
      expect(find.text('try_again'), findsOneWidget);
    });

    testWidgets('tentar novamente volta para a captura facial',
        (tester) async {
      final pumped = await _pumpErrorPage(
        tester,
        page: const LocationTimeoutErrorPage(),
        args: LocationTimeoutErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: false,
          employee: null,
          condoRef: 'R1',
        ),
      );

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(pumped.routes, contains(ApplicationRoute.faceDetectionView));
    });
  });

  group('FaceRequestErrorPage', () {
    testWidgets('mostra o erro genérico quando não há exceção conhecida',
        (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRequestErrorPage(),
        args: FaceRequestErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          knowException: null,
          employee: null,
        ),
      );

      expect(find.text('face_request_error_title'), findsOneWidget);
      expect(find.text('face_request_error_subtitle'), findsOneWidget);
      expect(find.text('try_again'), findsOneWidget);
    });

    testWidgets('rosto não identificado troca o título e o ícone',
        (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRequestErrorPage(),
        args: FaceRequestErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          knowException: const FormatException('sem rosto'),
          employee: null,
        ),
      );

      expect(find.text('face_register_error_no_face_title'), findsOneWidget);
      expect(find.byIcon(Icons.face_retouching_off), findsOneWidget);
    });

    testWidgets('timeout mantém o erro de requisição', (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRequestErrorPage(),
        args: FaceRequestErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          knowException: TimeoutException('tempo esgotado'),
          employee: null,
        ),
      );

      expect(find.text('face_request_error_title'), findsOneWidget);
      expect(find.byIcon(Icons.face_retouching_off), findsNothing);
    });

    testWidgets('tentar novamente volta para a captura facial',
        (tester) async {
      final pumped = await _pumpErrorPage(
        tester,
        page: const FaceRequestErrorPage(),
        args: FaceRequestErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          knowException: null,
          employee: null,
        ),
      );

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(pumped.routes, contains(ApplicationRoute.faceDetectionView));
    });
  });

  group('FaceRegisterErrorPage', () {
    testWidgets('sem exceção conhecida mostra apenas o título', (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRegisterErrorPage(),
        args: FaceRegisterErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          employee: null,
          condoRef: null,
        ),
      );

      expect(find.text('face_register_error_title'), findsOneWidget);
      expect(
        find.text('face_register_error_location_timeout'),
        findsNothing,
      );
    });

    testWidgets('timeout de localização explica o motivo', (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRegisterErrorPage(),
        args: FaceRegisterErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          employee: null,
          condoRef: null,
          knowException: TimeoutException('tempo esgotado'),
        ),
      );

      expect(
        find.text('face_register_error_location_timeout'),
        findsOneWidget,
      );
    });

    testWidgets('exceção desconhecida cai no texto padrão', (tester) async {
      await _pumpErrorPage(
        tester,
        page: const FaceRegisterErrorPage(),
        args: FaceRegisterErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          employee: null,
          condoRef: null,
          knowException: const FormatException('outro erro'),
        ),
      );

      expect(find.text('face_register_error_subtitle'), findsOneWidget);
    });

    testWidgets('tentar novamente volta para a captura facial',
        (tester) async {
      final pumped = await _pumpErrorPage(
        tester,
        page: const FaceRegisterErrorPage(),
        args: FaceRegisterErrorPageArgs(
          statusEnum: DigitalTimesheetStatusEnum.approved,
          isOnline: true,
          employee: null,
          condoRef: null,
        ),
      );

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(pumped.routes, contains(ApplicationRoute.faceDetectionView));
    });
  });
}
