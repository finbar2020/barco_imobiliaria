import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_notification_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — grid de documentos', (tester) async {
    await pumpApp(
      tester,
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        children: const [
          HomeDashboardItem(homeItem: HomeItemEnum.payStub),
          HomeDashboardItem(homeItem: HomeItemEnum.vacation),
          HomeDashboardItem(homeItem: HomeItemEnum.incomeReport),
          HomeDashboardItem(homeItem: HomeItemEnum.benefits),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_dashboard_documents.png'),
    );
  });

  testWidgets('golden — grid de vantagens', (tester) async {
    await pumpApp(
      tester,
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        children: const [
          HomeDashboardItem(homeItem: HomeItemEnum.discounts),
          HomeDashboardItem(homeItem: HomeItemEnum.indicateReceiveBenefits),
          HomeDashboardItem(homeItem: HomeItemEnum.condolivre),
          HomeDashboardItem(homeItem: HomeItemEnum.employeeReferral),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_dashboard_benefits.png'),
    );
  });

  testWidgets('golden — preferences notification checkbox desmarcado', (tester) async {
    await pumpApp(
      tester,
      PreferencesNotificationCheckBox(
        onTap: () {},
        checked: false,
        title: 'notifications_marketing',
      ),
      localized: true,
      surface: const Size(400, 60),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_notification_unchecked.png'),
    );
  });

  testWidgets('golden — lista de preferências de notificação', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          PreferencesNotificationCheckBox(
            onTap: () {},
            checked: true,
            title: 'notifications_gdp',
          ),
          PreferencesNotificationCheckBox(
            onTap: () {},
            checked: false,
            title: 'notifications_marketing',
          ),
          PreferencesNotificationCheckBox(
            onTap: () {},
            checked: true,
            title: 'notifications_comunicados',
          ),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 220),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_notification_list.png'),
    );
  });
}
