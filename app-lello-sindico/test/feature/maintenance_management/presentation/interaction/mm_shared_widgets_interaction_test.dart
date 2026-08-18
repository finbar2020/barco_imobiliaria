import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_card.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_confirmation_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_notify_partner_empty_state.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_receive_by_email_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/efficiency_tabs_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/search_field_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/week_day_selector_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('alterna o dia da semana', (tester) async {
    final days = <int>[1];
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return WeekDaySelectorWidget(
            selectedDays: days,
            onDayToggled: days.add,
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
            title: 'Dias',
          );
        },
      ),
    );

    await tester.tap(find.text('Qua'));
    await tester.pump();
    expect(days, contains(3));
  });

  testWidgets('cartão de obrigação dispara ver detalhes', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      LegalObligationCard(
        item: const LegalObligationItemEntity(
          documentType: 'AVCB',
          description: 'Auto de vistoria',
          status: 'valido',
          expirationDate: '2026-12-01',
        ),
        onSeeDetails: () => tapped = true,
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_status_valid': 'Válido',
        'legal_obligation_expiration': 'Vencimento',
        'legal_obligation_see_details': 'Ver detalhes',
      },
      shrinkWrap: false,
      surface: const Size(400, 220),
    );

    await tester.tap(find.text('Ver detalhes'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('cartão recusado usa o texto padrão do banner', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationCard(
        item: LegalObligationItemEntity(
          documentType: 'AVCB',
          description: 'Auto recusado',
          status: 'recusado',
          expirationDate: '',
        ),
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_status_rejected': 'Recusado',
        'legal_obligation_expiration': 'Vencimento',
        'legal_obligation_see_details': 'Ver detalhes',
        'legal_obligation_document_sent_by_user':
            'Este documento foi enviado pelo usuário.',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );

    expect(
      find.text('Este documento foi enviado pelo usuário.'),
      findsOneWidget,
    );
    expect(find.textContaining('Vencimento -'), findsOneWidget);
  });

  testWidgets('empty state notifica o parceiro', (tester) async {
    var notified = false;
    await pumpApp(
      tester,
      LegalObligationNotifyPartnerEmptyState(
        alreadyNotified: false,
        onNotifyPressed: () => notified = true,
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_empty_title': 'Sem obrigações',
        'legal_obligation_notify_partner_empty_description': 'Avise o parceiro.',
        'legal_obligation_notify_partner_button': 'Notificar parceiro',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );

    await tester.tap(find.text('Notificar parceiro'));
    await tester.pump();
    expect(notified, isTrue);
  });

  testWidgets('alterna a aba de eficiência', (tester) async {
    var selected = EfficiencyTabType.responsibles;
    await pumpApp(
      tester,
      EfficiencyTabsWidget(
        selectedTab: selected,
        onTabChanged: (tab) => selected = tab,
        responsiblesLabel: 'Responsáveis',
        groupsLabel: 'Grupos',
      ),
      shrinkWrap: false,
      surface: const Size(400, 90),
    );

    await tester.tap(find.text('Grupos'));
    await tester.pump();
    expect(selected, EfficiencyTabType.groups);
  });

  testWidgets('empty state em envio mostra o loader', (tester) async {
    await pumpApp(
      tester,
      LegalObligationNotifyPartnerEmptyState(
        alreadyNotified: false,
        isSending: true,
        onNotifyPressed: () {},
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_empty_title': 'Sem obrigações',
        'legal_obligation_notify_partner_empty_description': 'Avise o parceiro.',
        'legal_obligation_notify_partner_button': 'Notificar parceiro',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
      settle: false,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('e-mail inválido mantém o confirmar desabilitado', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationReceiveByEmailBottomSheet(),
      localized: true,
      locOverrides: const {
        'legal_obligation_receive_by_email_title': 'Receber por e-mail',
        'legal_obligation_receive_by_email_description':
            'Informe o e-mail para envio.',
        'legal_obligation_receive_by_email_email_label': 'E-mail',
        'legal_obligation_receive_by_email_hint': 'nome@email.com',
        'legal_obligation_cancel': 'Cancelar',
        'legal_obligation_confirm': 'Confirmar',
      },
    );

    await tester.enterText(find.byType(TextField), 'invalido');
    await tester.pump();

    expect(
      tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), 'nome@email.com');
    await tester.pump();

    expect(
      tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('modal de confirmação de renovação exibe textos', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationPartnerRenewalConfirmationModal(),
      localized: true,
      locOverrides: const {
        'legal_obligation_partner_renewal_confirmation_title':
            'Solicitar renovação?',
        'legal_obligation_partner_renewal_confirmation_description':
            'O parceiro receberá o pedido.',
        'legal_obligation_partner_renewal_confirmation_confirm': 'Confirmar',
        'legal_obligation_partner_renewal_confirmation_cancel': 'Cancelar',
      },
    );

    expect(find.text('Solicitar renovação?'), findsOneWidget);
    expect(find.text('Confirmar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });

  testWidgets('busca dispara onChanged', (tester) async {
    var query = '';
    await pumpApp(
      tester,
      SearchFieldWidget(
        hintText: 'Buscar',
        onChanged: (value) => query = value,
      ),
    );

    await tester.enterText(find.byType(TextField), 'Maria');
    await tester.pump();
    expect(query, 'Maria');
  });
}
