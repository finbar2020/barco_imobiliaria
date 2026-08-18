import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_full_janitor_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_full_janitor_gdp_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_full_manager_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_limited_janitor_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_limited_manager_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_add_new_user_bottom.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_cpf_dialog.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_dropdown.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_info_button.dart';

import '../../../../helpers/pump_app.dart';

const _profileLoc = {
  'staff_access_management_limited_service_janitor': 'Zelador limitado',
  'staff_access_management_limited_service_building_manager':
      'Gerente limitado',
  'staff_access_management_full_service_janitor': 'Zelador completo',
  'staff_access_management_full_service_building_manager': 'Gerente completo',
  'access_gdp': 'GDP',
};

void main() {
  testWidgets('golden — botão de info de acesso', (tester) async {
    await pumpApp(
      tester,
      StaffAccessManagementInfoButton(
        title: 'Perfis de acesso',
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_access_info_button.png'),
    );
  });

  testWidgets('golden — cartão de zelador limitado', (tester) async {
    await pumpApp(
      tester,
      const LimitedJanitorCard(),
      localized: true,
      locOverrides: _profileLoc,
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_limited_janitor.png'),
    );
  });

  testWidgets('golden — cartão de gerente limitado', (tester) async {
    await pumpApp(
      tester,
      const LimitedManagerCard(),
      localized: true,
      locOverrides: _profileLoc,
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_limited_manager.png'),
    );
  });

  testWidgets('golden — cartão de zelador completo', (tester) async {
    await pumpApp(
      tester,
      const FullJanitorCard(),
      localized: true,
      locOverrides: _profileLoc,
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_full_janitor.png'),
    );
  });

  testWidgets('golden — cartão de zelador completo com GDP', (tester) async {
    await pumpApp(
      tester,
      const FullJanitorWithGdpCard(),
      localized: true,
      locOverrides: _profileLoc,
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_full_janitor_gdp.png'),
    );
  });

  testWidgets('golden — cartão de gerente completo', (tester) async {
    await pumpApp(
      tester,
      const FullManagerCard(),
      localized: true,
      locOverrides: _profileLoc,
      shrinkWrap: false,
      surface: const Size(400, 140),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_full_manager.png'),
    );
  });

  testWidgets('golden — dropdown obrigatório', (tester) async {
    await pumpApp(
      tester,
      StaffAccessManagementDropdown(
        title: 'Perfil',
        items: const ['staff_access_full', 'staff_access_limited'],
        onChanged: (_) {},
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_select': 'Selecione',
        'staff_access_full': 'Completo',
        'staff_access_limited': 'Limitado',
      },
      shrinkWrap: false,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_access_dropdown.png'),
    );
  });

  testWidgets('golden — dropdown opcional', (tester) async {
    await pumpApp(
      tester,
      StaffAccessManagementDropdown(
        title: 'Perfil',
        isNotRequired: true,
        value: 'staff_access_full',
        items: const ['staff_access_full', 'staff_access_limited'],
        onChanged: (_) {},
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_select': 'Selecione',
        'staff_access_full': 'Completo',
        'staff_access_limited': 'Limitado',
      },
      shrinkWrap: false,
      surface: const Size(400, 160),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_access_dropdown_optional.png'),
    );
  });

  testWidgets('golden — diálogo de CPF', (tester) async {
    await pumpApp(
      tester,
      StaffAccessManagementCpfDialog(onTap: () {}),
      localized: true,
      locOverrides: const {
        'staff_access_management_cpf_user_title': 'Usuário já cadastrado',
        'staff_access_management_cpf_user_subtitle':
            'Este CPF já possui acesso.',
        'cancel': 'Cancelar',
        'comfort_to_your_condo_dialog_button_go': 'Ir',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_access_cpf_dialog.png'),
    );
  });

  testWidgets('golden — adicionar novo usuário', (tester) async {
    await pumpApp(
      tester,
      StaffAccessManagementAddNewUserBottom(
        title: 'Adicionar usuário',
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/staff_access_add_user.png'),
    );
  });
}
