import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_invite_failed_page.dart';
import 'package:lello/feature/unit/presentation/widget/unit_list_item.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — item da lista de unidades', (tester) async {
    await pumpApp(
      tester,
      UnitListItem(
        unit: Unit(title: '101', group: 'Torre A', residentCount: 3),
      ),
      localized: true,
      locOverrides: const {
        'units_unit': 'Unidade',
        'units_residents': 'Moradores',
        'units_vehicle': 'Veículos',
        'units_group': 'Grupo',
      },
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/unit_list_item.png'),
    );
  });

  testWidgets('golden — item de unidade com grupo', (tester) async {
    await pumpApp(
      tester,
      UnitListItem(
        isDetails: true,
        unit: Unit(
          title: '101',
          group: 'Torre A',
          residentCount: 3,
          vehicleCount: 1,
        ),
      ),
      localized: true,
      locOverrides: const {
        'units_unit': 'Unidade',
        'units_residents': 'Moradores',
        'units_vehicle': 'Veículos',
        'units_group': 'Grupo',
      },
      shrinkWrap: false,
      surface: const Size(400, 160),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/unit_list_item_details.png'),
    );
  });

  testWidgets('golden — erro ao convidar morador', (tester) async {
    await pumpApp(
      tester,
      const UnitDetailInviteErrorPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'residents_link_error_title': 'Não foi possível enviar o convite',
        'residents_link_error_subtitle': 'Tente novamente mais tarde.',
        'try_again': 'Tentar novamente',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/unit_invite_error.png'),
    );
  });
}
