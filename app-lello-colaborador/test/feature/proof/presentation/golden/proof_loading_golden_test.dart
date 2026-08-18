import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — proof loading', (tester) async {
    await pumpApp(
      tester,
      const LoadingWidget(message: 'proof_page_loading_message'),
      localized: true,
      settle: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_loading.png'),
    );
  });

  testWidgets('golden — dashboard documentos', (tester) async {
    await pumpApp(
      tester,
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.6,
        children: const [
          HomeDashboardItem(homeItem: HomeItemEnum.payStub),
          HomeDashboardItem(homeItem: HomeItemEnum.vacation),
          HomeDashboardItem(homeItem: HomeItemEnum.incomeReport),
          HomeDashboardItem(homeItem: HomeItemEnum.benefits),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_dashboard_documents.png'),
    );
  });

  testWidgets('golden — dashboard ponto digital', (tester) async {
    await pumpApp(
      tester,
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.6,
        children: const [
          HomeDashboardItem(homeItem: HomeItemEnum.registerDigitalPoint),
          HomeDashboardItem(homeItem: HomeItemEnum.timeSheet),
          HomeDashboardItem(homeItem: HomeItemEnum.sickNote),
          HomeDashboardItem(homeItem: HomeItemEnum.sendTimeSheet),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/home_dashboard_digital_point.png'),
    );
  });
}
