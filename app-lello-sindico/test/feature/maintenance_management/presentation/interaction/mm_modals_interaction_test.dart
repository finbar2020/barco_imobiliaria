import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/button/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/widgets/chat_conversation_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/widgets/equipment_selection_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_help_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_notify_partner_success_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_confirmation_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_failure_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_success_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_receive_by_email_bottom_sheet.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('cartão de conversa dispara onTap', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      ChatConversationCardWidget(
        conversation: const ChatChannelEntity(
          id: 'c1',
          typeTask: 'ROTINA',
          status: 'DRAFT',
          task: ChannelTaskEntity(id: 't1', name: 'Limpeza da piscina'),
        ),
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.text('Limpeza da piscina'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('seleciona equipamento na lista filtrada', (tester) async {
    FilterAssetEntity? selected;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return EquipmentSelectionWidget(
            selectedEquipment: null,
            availableEquipments: [
              FilterAssetEntity(id: 'e1', name: 'Bomba d\'água'),
              FilterAssetEntity(id: 'e2', name: 'Portão automático'),
            ],
            onEquipmentSelected: (value) => selected = value,
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
          );
        },
      ),
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Selecione'));
    await tester.pumpAndSettle();
    expect(find.text('Por equipamentos'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'port');
    await tester.pump();
    expect(find.text('Bomba d\'água'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    await tester.tap(find.text('Portão automático'));
    await tester.pumpAndSettle();
    expect(selected?.id, 'e2');
  });

  testWidgets('fecha o seletor de equipamento', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return EquipmentSelectionWidget(
            selectedEquipment: FilterAssetEntity(id: 'e1', name: 'Bomba'),
            availableEquipments: [
              FilterAssetEntity(id: 'e1', name: 'Bomba'),
            ],
            onEquipmentSelected: (_) {},
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
          );
        },
      ),
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Bomba'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Por equipamentos'), findsNothing);
  });

  testWidgets('fecha o modal de sucesso da renovação', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () =>
                LegalObligationPartnerRenewalSuccessModal.show(context),
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_partner_renewal_success_message':
            'Renovação solicitada.',
        'close': 'Fechar',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Renovação solicitada.'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('Renovação solicitada.'), findsNothing);
  });

  testWidgets('confirma a renovação e devolve true', (tester) async {
    bool? confirmed;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              confirmed =
                  await LegalObligationPartnerRenewalConfirmationModal.show(
                context,
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
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

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PrimaryButton, 'Confirmar'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });

  testWidgets('cancela a renovação e devolve false', (tester) async {
    bool? confirmed;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              confirmed =
                  await LegalObligationPartnerRenewalConfirmationModal.show(
                context,
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
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

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(confirmed, isFalse);
  });

  testWidgets('fecha a ajuda ao tocar em Entendi', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () => LegalObligationHelpBottomSheet.show(context),
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_help_why_title': 'Por que?',
        'legal_obligation_help_why_description': 'Para manter o condomínio.',
        'legal_obligation_help_how_title': 'Como?',
        'legal_obligation_help_actions_disclaimer': 'Ações no portal.',
        'legal_obligation_help_understood_button': 'Entendi',
      },
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Entendi'), findsOneWidget);
    await tester.tap(find.text('Entendi'));
    await tester.pumpAndSettle();
    expect(find.text('Entendi'), findsNothing);
  });

  testWidgets('cancela o envio por e-mail', (tester) async {
    var closed = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              await LegalObligationReceiveByEmailBottomSheet.show(context);
              closed = true;
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_receive_by_email_title': 'Receber por e-mail',
        'legal_obligation_receive_by_email_description': 'Informe o e-mail.',
        'legal_obligation_receive_by_email_email_label': 'E-mail',
        'legal_obligation_receive_by_email_hint': 'nome@email.com',
        'legal_obligation_cancel': 'Cancelar',
        'legal_obligation_confirm': 'Confirmar',
      },
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SecondaryButton, 'Cancelar'));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });

  testWidgets('confirma o e-mail válido', (tester) async {
    String? email;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              email = await LegalObligationReceiveByEmailBottomSheet.show(
                context,
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_receive_by_email_title': 'Receber por e-mail',
        'legal_obligation_receive_by_email_description': 'Informe o e-mail.',
        'legal_obligation_receive_by_email_email_label': 'E-mail',
        'legal_obligation_receive_by_email_hint': 'nome@email.com',
        'legal_obligation_cancel': 'Cancelar',
        'legal_obligation_confirm': 'Confirmar',
      },
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'nome@email.com');
    await tester.pump();
    await tester.tap(find.widgetWithText(PrimaryButton, 'Confirmar'));
    await tester.pumpAndSettle();
    expect(email, 'nome@email.com');
  });

  testWidgets('submete o e-mail pelo teclado', (tester) async {
    String? email;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              email = await LegalObligationReceiveByEmailBottomSheet.show(
                context,
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_receive_by_email_title': 'Receber por e-mail',
        'legal_obligation_receive_by_email_description': 'Informe o e-mail.',
        'legal_obligation_receive_by_email_email_label': 'E-mail',
        'legal_obligation_receive_by_email_hint': 'nome@email.com',
        'legal_obligation_cancel': 'Cancelar',
        'legal_obligation_confirm': 'Confirmar',
      },
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'nome@email.com');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(email, 'nome@email.com');
  });

  testWidgets('fecha o modal de falha da renovação', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () =>
                LegalObligationPartnerRenewalFailureModal.show(context),
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_partner_renewal_failure_message':
            'Não foi possível solicitar.',
        'close': 'Fechar',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível solicitar.'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível solicitar.'), findsNothing);
  });

  testWidgets('fecha o modal de parceiro notificado', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () =>
                LegalObligationNotifyPartnerSuccessModal.show(context),
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_success_message':
            'Parceiro notificado.',
        'close': 'Fechar',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Parceiro notificado.'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('Parceiro notificado.'), findsNothing);
  });
}
