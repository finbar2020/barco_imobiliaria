import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('DigitalTimesheetStatus.color e text para todos os status',
      (tester) async {
    final sessionBloc = FakeSessionBloc();
    late final Map<DigitalTimesheetStatusEnum, Color> colors;
    late final Map<DigitalTimesheetStatusEnum, String> texts;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          colors = {
            for (final status in DigitalTimesheetStatusEnum.values)
              status: DigitalTimesheetStatus.color(status, sessionBloc),
          };
          texts = {
            for (final status in DigitalTimesheetStatusEnum.values)
              status: DigitalTimesheetStatus.text(
                context: context,
                statusEnum: status,
                sessionBloc: sessionBloc,
              ),
          };
          return const SizedBox.shrink();
        },
      ),
      localized: true,
    );

    expect(colors[DigitalTimesheetStatusEnum.approved], const Color(0xFF42B883));
    expect(colors[DigitalTimesheetStatusEnum.pending], const Color(0xFF979797));
    expect(colors[DigitalTimesheetStatusEnum.notRequested], const Color(0xFF922885));
    expect(colors[DigitalTimesheetStatusEnum.declined], const Color(0xFF922885));
    expect(colors[DigitalTimesheetStatusEnum.notActivated], const Color(0xFFCB2640));
    expect(colors[DigitalTimesheetStatusEnum.removed], const Color(0xFF922885));

    expect(texts[DigitalTimesheetStatusEnum.approved], 'home_page_register_point');
    expect(texts[DigitalTimesheetStatusEnum.pending], 'home_page_register_waiting_release');
    expect(texts[DigitalTimesheetStatusEnum.notRequested], 'home_page_release_digital_point');
    expect(texts[DigitalTimesheetStatusEnum.declined], 'home_page_release_digital_point');
    expect(texts[DigitalTimesheetStatusEnum.notActivated], 'home_page_register_know_digital_point');
    expect(texts[DigitalTimesheetStatusEnum.removed], 'home_page_release_digital_point');

    expect(DigitalTimesheetStatusEnum.approved.isApproved, isTrue);
    expect(DigitalTimesheetStatusEnum.pending.isPending, isTrue);
    expect(DigitalTimesheetStatusEnum.notActivated.isNotActivated, isTrue);
    expect(DigitalTimesheetStatusEnum.notRequested.isNotRequested, isTrue);
    expect(DigitalTimesheetStatusEnum.declined.isDeclined, isTrue);
    expect(DigitalTimesheetStatusEnum.removed.isRemoved, isTrue);
  });

  testWidgets('texto de afastamento quando o ponto está bloqueado',
      (tester) async {
    final sessionBloc = FakeSessionBloc(
      Session(
        me: testMe(),
        condominium: testCondominium(
          shouldIgnoreDigitalPoint: true,
          digitalTimesheetStatus: DigitalTimesheetStatusEnum.approved,
        ),
      ),
    );
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          expect(
            DigitalTimesheetStatus.text(
              context: context,
              statusEnum: DigitalTimesheetStatusEnum.approved,
              sessionBloc: sessionBloc,
            ),
            'afastado',
          );
          expect(
            DigitalTimesheetStatus.color(
              DigitalTimesheetStatusEnum.approved,
              sessionBloc,
            ),
            isA<Color>(),
          );
          return const SizedBox.shrink();
        },
      ),
      localized: true,
    );
  });

  testWidgets('bloqueio por tipo de dispositivo', (tester) async {
    final tabletOnly = FakeSessionBloc(
      Session(
        me: testMe(isTabletSession: false),
        condominium: testCondominium(
          deviceTypeEnum: DeviceTypeAllowedEnum.tablet,
        ),
      ),
    );
    final phoneOnly = FakeSessionBloc(
      Session(
        me: testMe(isTabletSession: true),
        condominium: testCondominium(
          deviceTypeEnum: DeviceTypeAllowedEnum.phone,
        ),
      ),
    );
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          expect(
            DigitalTimesheetStatus.text(
              context: context,
              statusEnum: DigitalTimesheetStatusEnum.approved,
              sessionBloc: tabletOnly,
            ),
            'home_page_register_point_blocked',
          );
          expect(
            DigitalTimesheetStatus.text(
              context: context,
              statusEnum: DigitalTimesheetStatusEnum.approved,
              sessionBloc: phoneOnly,
            ),
            'home_page_register_point_blocked',
          );
          expect(
            DigitalTimesheetStatus.color(
              DigitalTimesheetStatusEnum.approved,
              tabletOnly,
            ),
            isA<Color>(),
          );
          expect(
            DigitalTimesheetStatus.color(
              DigitalTimesheetStatusEnum.approved,
              phoneOnly,
            ),
            isA<Color>(),
          );
          return const SizedBox.shrink();
        },
      ),
      localized: true,
    );
  });
}
