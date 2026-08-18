import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_select_date_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — proof lista vazia', (tester) async {
    final controller = TextEditingController(text: '10/01/2026');
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProofSelectDateWidget(onTap: (_) {}, controller: controller),
          SizedBox(height: Dimens.spacing),
          Text('proof_clock_in_empty'),
        ],
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_list_empty.png'),
    );
  });

  testWidgets('golden — proof lista com itens', (tester) async {
    final controller = TextEditingController(text: '10/01/2026');
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      SizedBox(
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProofSelectDateWidget(onTap: (_) {}, controller: controller),
            SizedBox(height: Dimens.spacing),
            Text('proof_clock_in'),
            SizedBox(height: Dimens.spacingSmall),
            Expanded(
              child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) => ProofCardWidget(
                  dateTimeClockIn: index == 0
                      ? '10/01/2026 08:00'
                      : '10/01/2026 12:00',
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_list_items.png'),
    );
  });
}
