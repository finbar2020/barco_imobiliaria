import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_receipts.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_datail_title_subtitle_widget.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_detail_hearder_widget.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_detail_list_widget.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_grid_detail_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_build_title_subtitle_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_details_widget.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    Intl.defaultLocale = 'pt_BR';
  });

  testWidgets('golden — cabeçalho de inadimplência', (tester) async {
    await pumpApp(
      tester,
      DetailHeaderWidget(
        detail: NonPaymentsDetail(
          period: DateTime(2026, 2, 1),
          resident: Resident(
            name: 'João Souza',
            unit: Unit(title: '101', billingStatus: 'Inadimplente'),
          ),
        ),
      ),
      localized: true,
      locOverrides: const {
        'non_payments_item_container_billing_status': 'Situação',
        'non_payments_detail_header_title': 'Competência',
        'non_payments_detail_header_title2': 'Vencimento',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_header.png'),
    );
  });

  testWidgets('golden — título e subtítulo de inadimplência', (tester) async {
    await pumpApp(
      tester,
      const TitleSubtitleWidget(
        title: 'Morador',
        subTitle: 'João Souza',
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_title_subtitle.png'),
    );
  });

  testWidgets('golden — título e subtítulo do detalhe', (tester) async {
    await pumpApp(
      tester,
      const DetailTitleSubtitleWidget(
        title: 'Fatura',
        subTitle: 'NF-10',
        usingSpacingBottom: false,
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_detail_title_subtitle.png'),
    );
  });

  testWidgets('golden — lista de recibos', (tester) async {
    await pumpApp(
      tester,
      DetailListWidget(
        detail: NonPaymentsDetail(
          receipts: [
            NonPaymentsReceipts()
              ..receipt = 'NF-10'
              ..period = DateTime(2026, 8, 1)
              ..valueLiquid = 120
              ..penalty = 10
              ..interest = 5
              ..value = 135,
          ],
        ),
      ),
      localized: true,
      locOverrides: const {
        'non_payments_detail_invoice': 'Fatura',
        'non_payments_detail_period': 'Período',
        'non_payments_detail_value': 'Valor',
        'non_payments_detail_penalty': 'Multa',
        'non_payments_detail_correction': 'Correção',
        'non_payments_detail_total_value': 'Total',
      },
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_receipt_list.png'),
    );
  });

  testWidgets('golden — grade de valores do detalhe', (tester) async {
    await pumpApp(
      tester,
      GridDetailWidget(
        detail: NonPaymentsDetail(
          valueLiquid: 120,
          interest: 5,
          penalty: 10,
          value: 135,
        ),
      ),
      localized: true,
      locOverrides: const {
        'non_payments_detail_container_title': 'Resumo',
        'non_payments_detail_value': 'Valor',
        'non_payments_detail_correction': 'Correção',
        'non_payments_detail_penalty': 'Multa',
        'non_payments_detail_total_value': 'Total',
      },
      shrinkWrap: false,
      surface: const Size(560, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_grid_detail.png'),
    );
  });

  testWidgets('golden — resumo de cotas', (tester) async {
    await pumpApp(
      tester,
      DetailsWidget(
        payments: NonPayment(
          quotes: 3,
          value: 120,
          valueWithPenalty: 135,
        ),
      ),
      localized: true,
      locOverrides: const {
        'non_payments_details_container_quotas': 'Cotas',
        'non_payments_details_container_value': 'Valor',
        'non_payments_details_container_value_penalty': 'Com multa',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/nonpayment_details.png'),
    );
  });
}
