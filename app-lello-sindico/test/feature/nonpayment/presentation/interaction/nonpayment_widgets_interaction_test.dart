import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_receipts.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_detail_list_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_details_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_hearder_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    Intl.defaultLocale = 'pt_BR';
  });

  testWidgets('cabeçalho mostra o condomínio', (tester) async {
    await pumpApp(
      tester,
      const HeaderWidget(condominiumName: 'Residencial Aurora'),
      localized: true,
      locOverrides: const {
        'non_payments_header_title': 'Inadimplência',
        'non_payments_header_condominium': 'Condomínio',
      },
    );

    expect(find.text('Residencial Aurora'), findsOneWidget);
    expect(find.text('Condomínio'), findsOneWidget);
  });

  testWidgets('lista de recibos mostra valor e fatura', (tester) async {
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

    expect(find.text('NF-10'), findsOneWidget);
    expect(find.text('Fatura'), findsOneWidget);
  });

  testWidgets('resumo de quotas mostra valores e vazio', (tester) async {
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

    expect(find.text('Cotas'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('resumo de quotas vazio não quebra', (tester) async {
    await pumpApp(
      tester,
      DetailsWidget(payments: NonPayment()),
      localized: true,
      locOverrides: const {
        'non_payments_details_container_quotas': 'Cotas',
        'non_payments_details_container_value': 'Valor',
        'non_payments_details_container_value_penalty': 'Com multa',
      },
    );

    expect(find.text('Cotas'), findsOneWidget);
    expect(find.text('Valor'), findsOneWidget);
  });
}
