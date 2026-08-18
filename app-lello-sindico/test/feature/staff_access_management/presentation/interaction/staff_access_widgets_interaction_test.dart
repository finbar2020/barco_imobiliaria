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

void main() {
  testWidgets('botão de info dispara onTap', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      StaffAccessManagementInfoButton(
        title: 'Perfis de acesso',
        onTap: () => tapped = true,
      ),
    );
    await tester.tap(find.text('Perfis de acesso'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('cartão de zelador limitado expande o conteúdo', (tester) async {
    await pumpApp(
      tester,
      const LimitedJanitorCard(),
      localized: true,
      locOverrides: const {
        'staff_access_management_limited_service_janitor': 'Zelador limitado',
        'condominium_hub_manage_space': 'Espaços',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );

    expect(find.text('Espaços'), findsNothing);
    await tester.tap(find.text('Zelador limitado'));
    await tester.pumpAndSettle();
    expect(find.text('Espaços'), findsOneWidget);
  });

  testWidgets('dropdown altera o valor', (tester) async {
    String? selected;
    await pumpApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          return StaffAccessManagementDropdown(
            title: 'Perfil',
            value: selected,
            items: const ['staff_access_full', 'staff_access_limited'],
            onChanged: (value) => setState(() => selected = value),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_select': 'Selecione',
        'staff_access_full': 'Completo',
        'staff_access_limited': 'Limitado',
      },
      shrinkWrap: false,
      surface: const Size(400, 400),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completo').last);
    await tester.pumpAndSettle();
    expect(selected, 'staff_access_full');
  });

  testWidgets('adicionar usuário dispara onTap', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      StaffAccessManagementAddNewUserBottom(
        title: 'Adicionar usuário',
        onTap: () => tapped = true,
      ),
    );
    await tester.tap(find.text('Adicionar usuário'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('diálogo de CPF dispara ir', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      StaffAccessManagementCpfDialog(onTap: () => tapped = true),
      localized: true,
      locOverrides: const {
        'staff_access_management_cpf_user_title': 'Usuário já cadastrado',
        'staff_access_management_cpf_user_subtitle':
            'Este CPF já possui acesso.',
        'cancel': 'Cancelar',
        'comfort_to_your_condo_dialog_button_go': 'Ir',
      },
    );

    await tester.tap(find.text('IR'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('cartão de gerente limitado expande o conteúdo', (tester) async {
    await pumpApp(
      tester,
      const LimitedManagerCard(),
      localized: true,
      locOverrides: const {
        'staff_access_management_limited_service_building_manager':
            'Gerente limitado',
        'balance': 'Saldo',
      },
      shrinkWrap: false,
      surface: const Size(400, 520),
    );

    expect(find.text('Saldo'), findsNothing);
    await tester.tap(find.text('Gerente limitado'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo'), findsOneWidget);
  });

  testWidgets('cartão de zelador completo expande o conteúdo', (tester) async {
    await pumpApp(
      tester,
      const FullJanitorCard(),
      localized: true,
      locOverrides: const {
        'staff_access_management_full_service_janitor': 'Zelador completo',
        'income_monthly_billets': 'Boletos',
      },
      shrinkWrap: false,
      surface: const Size(400, 420),
    );

    expect(find.text('Boletos'), findsNothing);
    await tester.tap(find.text('Zelador completo'));
    await tester.pumpAndSettle();
    expect(find.text('Boletos'), findsOneWidget);
  });

  testWidgets('cartão de gerente completo expande o conteúdo', (tester) async {
    await pumpApp(
      tester,
      const FullManagerCard(),
      localized: true,
      locOverrides: const {
        'staff_access_management_full_service_building_manager':
            'Gerente completo',
        'balance': 'Saldo',
      },
      shrinkWrap: false,
      surface: const Size(400, 1600),
    );

    expect(find.text('Saldo'), findsNothing);
    await tester.tap(find.text('Gerente completo'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo'), findsOneWidget);
  });

  testWidgets('cartão de zelador com GDP expande o conteúdo', (tester) async {
    await pumpApp(
      tester,
      const FullJanitorWithGdpCard(),
      localized: true,
      locOverrides: const {
        'staff_access_management_full_service_janitor': 'Zelador completo',
        'access_gdp': 'GDP',
        'income_monthly_billets': 'Boletos',
      },
      shrinkWrap: false,
      surface: const Size(400, 420),
    );

    expect(find.text('Boletos'), findsNothing);
    await tester.tap(find.text('Zelador completo (GDP)'));
    await tester.pumpAndSettle();
    expect(find.text('Boletos'), findsOneWidget);
  });
}
