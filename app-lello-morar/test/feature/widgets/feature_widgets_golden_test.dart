import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_period_group_list_widget.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_no_avaible.dart';
import 'package:morar/feature/home/presentation/widget/badge_icon.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/widget/preferences_notification_toggle.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:morar/feature/vehicles/presentation/widgets/vehicle_widget.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('VehicleContainer e BadgeIcon', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          VehicleContainer(child: const Center(child: Text('Gol ABC-1234'))),
          const SizedBox(height: 8),
          VehicleContainer(height: 40, child: const Center(child: BadgeIcon(text: '3'))),
        ],
      ),
    );
    expect(find.text('Gol ABC-1234'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/vehicle_container_badge.png'));
  });

  testWidgets('EmptyStateWidget', (tester) async {
    await pumpApp(tester, const EmptyStateWidget(), shrinkWrap: false, surface: const Size(400, 500));
    expect(find.text('Suas ferramentas disponíveis serão exibidas aqui.'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/empty_state_widget.png'));
    await pumpApp(tester, const EmptyStateWidget(message: 'Nada aqui'), shrinkWrap: false, surface: const Size(400, 500));
    expect(find.text('Nada aqui'), findsOneWidget);
  });

  testWidgets('AgreementsNoAvailableWidget', (tester) async {
    await pumpApp(
      tester,
      const Column(children: [
        AgreementsNoAvailableWidget(),
        AgreementsNoAvailableWidget(agreement: true),
      ]),
      localized: true,
    );
    expect(find.text('you_have_no_quotas'), findsOneWidget);
    expect(find.text('you_have_no_agreements'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/agreements_no_available.png'));
  });

  testWidgets('PreferencesCheckBox e PreferencesNotificationToggle', (tester) async {
    var taps = 0;
    bool? toggled;
    await pumpApp(
      tester,
      Column(
        children: [
          Row(children: [
            PreferencesCheckBox(onTap: () => taps++, checked: true),
            const SizedBox(width: 8),
            PreferencesCheckBox(onTap: () => taps++, checked: false),
          ]),
          PreferencesNotificationToggle(value: true, onChanged: (v) => toggled = v, title: 'Boletos'),
          PreferencesNotificationToggle(value: false, onChanged: (v) => toggled = v, title: 'Acordos', style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
    await tester.tap(find.byType(PreferencesCheckBox).first);
    await tester.tap(find.byType(PreferencesCheckBox).last);
    expect(taps, 2);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(toggled, isFalse);
    expect(find.text('Boletos'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/preferences_controls.png'));
  });

  testWidgets('AccountabilityPeriodGroupListWidget', (tester) async {
    final grouped = AccountabilityGrouped(
      type: 'RECEITA',
      description: 'Receitas',
      id: 1,
      debits: 10,
      credits: 100,
      accounts: [
        AccountabilityGroupedAccount(
          account: 1,
          description: 'Taxa condominial',
          entries: [
            AccountabilityGroupedAccountEntrie(id: 1, date: DateTime(2026, 1, 5), value: 100, signal: '+', credit: 100, debit: 0, history: 'Cota'),
          ],
        ),
      ],
    );
    await pumpApp(
      tester,
      AccountabilityPeriodGroupListWidget(title: 'Janeiro - 2026', groupedEntries: [grouped]),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 600),
    );
    expect(find.text('Janeiro - 2026'), findsOneWidget);
    expect(find.text('accountability_historial_releases'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/accountability_period_group_list.png'));
  });
}
