import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_status.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_progress_bar_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_card.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_help_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_notify_partner_empty_state.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_notify_partner_success_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_confirmation_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_failure_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_partner_renewal_success_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_receive_by_email_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/widgets/legal_obligation_status_tag.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/efficiency_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/efficiency_tabs_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/efficiency_tile_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_box_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/search_field_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_tooltip_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/simple_tooltip_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/task_tabs_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/week_day_selector_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/task_details_event.dart';

import '../../../../helpers/pump_app.dart';

const _labels = {
  'task_type_routine': 'Rotina',
  'task_type_service_order': 'OS',
  'task_status_pending': 'Pendente',
  'task_status_in_progress': 'Andamento',
  'task_status_completed': 'Concluída',
  'task_card_view_task': 'Ver tarefa',
  'pending': 'Pendentes',
  'concluded': 'Concluídas',
};

void main() {
  testWidgets('golden — info box', (tester) async {
    await pumpApp(
      tester,
      const Padding(
        padding: EdgeInsets.all(16),
        child: InfoBoxWidget(
          message: 'A tarefa será visível até a conclusão.',
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/info_box.png'),
    );
  });

  testWidgets('golden — search field', (tester) async {
    await pumpApp(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: SearchFieldWidget(
          hintText: 'Buscar funcionário',
          onChanged: (_) {},
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/search_field.png'),
    );
  });

  testWidgets('golden — dias da semana com seleção', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: WeekDaySelectorWidget(
              selectedDays: const [1, 3, 5],
              onDayToggled: (_) {},
              theme: theme,
              palette: LelloTheme.palleteOf(theme),
              title: 'Dias da semana',
            ),
          );
        },
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/week_day_selector.png'),
    );
  });

  testWidgets('golden — efficiency card', (tester) async {
    await pumpApp(
      tester,
      const Padding(
        padding: EdgeInsets.all(16),
        child: EfficiencyCardWidget(
          title: 'Eficiência da semana',
          child: SizedBox(height: 48, child: Text('Conteúdo')),
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/efficiency_card.png'),
    );
  });

  testWidgets('golden — tooltip simples', (tester) async {
    await pumpApp(
      tester,
      const Padding(
        padding: EdgeInsets.all(16),
        child: SimpleTooltipWidget(
          title: 'Atenção:',
          message: 'permanecerá visível até a conclusão.',
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/simple_tooltip.png'),
    );
  });

  testWidgets('golden — abas da tarefa', (tester) async {
    await pumpApp(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: TaskTabsWidget(
          selectedTab: TaskDetailsTabType.steps,
          onTabChanged: (_) {},
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/task_tabs.png'),
    );
  });

  testWidgets('golden — cartão de rotina pendente', (tester) async {
    await pumpApp(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: TaskCardWidget(
          title: 'Limpeza do hall',
          start: '08:00',
          timeDescription: '08:00 - 09:00',
          type: TaskType.routine,
          status: TaskStatusType.pending,
          isAllDay: false,
          onTap: () {},
        ),
      ),
      localized: true,
      locOverrides: _labels,
      surface: const Size(420, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/task_card_routine_pending.png'),
    );
  });

  testWidgets('golden — cartão de OS em andamento', (tester) async {
    await pumpApp(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: TaskCardWidget(
          title: 'Troca da bomba',
          start: '10:00',
          timeDescription: 'Dia todo',
          type: TaskType.serviceOrder,
          status: TaskStatusType.inProgress,
          isAllDay: true,
          onTap: () {},
        ),
      ),
      localized: true,
      locOverrides: _labels,
      surface: const Size(420, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/task_card_os_in_progress.png'),
    );
  });

  testWidgets('golden — barra de progresso', (tester) async {
    await pumpApp(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: TaskProgressBar(
          statuses: [
            TaskStatus(status: TaskStatusType.pending, count: 2),
            TaskStatus(status: TaskStatusType.inProgress, count: 1),
            TaskStatus(status: TaskStatusType.completed, count: 3),
          ],
        ),
      ),
      localized: true,
      locOverrides: _labels,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/task_progress_bar.png'),
    );
  });

  testWidgets('golden — tooltips de info, alerta, sucesso e erro',
      (tester) async {
    await pumpApp(
      tester,
      const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoTooltip(message: 'Informação complementar da tarefa.'),
          WarningTooltip(message: 'Atenção ao prazo da obrigação.'),
          SuccessTooltip(message: 'Tarefa concluída com sucesso.'),
          ErrorTooltip(message: 'Não foi possível salvar a tarefa.'),
        ],
      ),
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/info_tooltips.png'),
    );
  });

  testWidgets('golden — tile de eficiência', (tester) async {
    await pumpApp(
      tester,
      const EfficiencyTileWidget(
        item: EfficiencyItem(
          id: '1',
          title: 'João Silva',
          subtitle: 'Zelador',
          completed: 4,
          pending: 2,
          inProgress: 1,
          avatarColor: '#C20332',
        ),
      ),
      localized: true,
      locOverrides: _labels,
      shrinkWrap: false,
      surface: const Size(400, 200),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/efficiency_tile.png'),
    );
  });

  testWidgets('golden — cartão de obrigação legal pendente', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationCard(
        item: LegalObligationItemEntity(
          documentType: 'AVCB',
          description: 'Auto de Vistoria do Corpo de Bombeiros',
          status: 'pendente',
          expirationDate: '2026-12-31',
        ),
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_status_pending': 'Pendente',
        'legal_obligation_expiration': 'Vencimento',
        'legal_obligation_see_details': 'Ver detalhes',
      },
      shrinkWrap: false,
      surface: const Size(400, 220),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_card.png'),
    );
  });

  testWidgets('golden — cartão de obrigação em análise', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationCard(
        item: LegalObligationItemEntity(
          documentType: 'PPCI',
          description: 'Projeto de prevenção',
          status: 'em-analise',
          expirationDate: '2026-09-15',
          statusTooltip: 'Documento enviado para análise.',
        ),
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_status_under_review': 'Em análise',
        'legal_obligation_expiration': 'Vencimento',
        'legal_obligation_see_details': 'Ver detalhes',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_card_review.png'),
    );
  });

  testWidgets('golden — cartão de obrigação recusado', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationCard(
        listCategoryLabel: 'Condomínio',
        item: LegalObligationItemEntity(
          documentType: 'AVCB',
          description: 'Auto recusado',
          status: 'recusado',
          expirationDate: 'invalida',
          submittedByName: 'Ana Souza',
        ),
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_status_rejected': 'Recusado',
        'legal_obligation_expiration': 'Vencimento',
        'legal_obligation_see_details': 'Ver detalhes',
        'legal_obligation_document_sent_by_name': 'Enviado por Ana Souza',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_card_rejected.png'),
    );
  });

  testWidgets('golden — empty state de notificar parceiro', (tester) async {
    await pumpApp(
      tester,
      LegalObligationNotifyPartnerEmptyState(
        alreadyNotified: false,
        onNotifyPressed: () {},
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_empty_title':
            'Nenhuma obrigação encontrada',
        'legal_obligation_notify_partner_empty_description':
            'Notifique o parceiro para receber os documentos.',
        'legal_obligation_notify_partner_button': 'Notificar parceiro',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_empty.png'),
    );
  });

  testWidgets('golden — empty state já notificado', (tester) async {
    await pumpApp(
      tester,
      LegalObligationNotifyPartnerEmptyState(
        alreadyNotified: true,
        onNotifyPressed: () {},
      ),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_empty_title':
            'Nenhuma obrigação encontrada',
        'legal_obligation_notify_partner_empty_description':
            'Notifique o parceiro para receber os documentos.',
        'legal_obligation_notify_partner_button': 'Notificar parceiro',
        'legal_obligation_notify_partner_already_sent_tooltip':
            'Notificação já enviada.',
      },
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_empty_notified.png'),
    );
  });

  testWidgets('golden — ajuda dos status da obrigação', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationHelpBottomSheet(),
      localized: true,
      locOverrides: const {
        'legal_obligation_help_why_title': 'Por que enviar?',
        'legal_obligation_help_why_description': 'Para manter o condomínio em dia.',
        'legal_obligation_help_how_title': 'Status',
        'legal_obligation_help_actions_disclaimer': 'As ações dependem do status.',
        'legal_obligation_help_understood_button': 'Entendi',
        'legal_obligation_status_pending': 'Pendente',
        'legal_obligation_status_expiring': 'À vencer',
        'legal_obligation_status_expired': 'Vencido',
        'legal_obligation_status_in_renewal': 'Em renovação',
        'legal_obligation_status_under_review': 'Em análise',
        'legal_obligation_status_rejected': 'Recusado',
        'legal_obligation_status_valid': 'Válido',
        'legal_obligation_help_status_pending_description':
            'Pendente: ainda não enviado.',
        'legal_obligation_help_status_expiring_description':
            'À vencer: próximo do prazo.',
        'legal_obligation_help_status_expired_description':
            'Vencido: prazo ultrapassado.',
        'legal_obligation_help_status_in_renewal_description':
            'Em renovação: parceiro acionado.',
        'legal_obligation_help_status_under_review_description':
            'Em análise: documento em checagem.',
        'legal_obligation_help_status_rejected_description':
            'Recusado: precisa reenviar.',
        'legal_obligation_help_status_valid_description':
            'Válido: documento aceito.',
      },
      shrinkWrap: false,
      surface: const Size(400, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_help.png'),
    );
  });

  testWidgets('golden — modal de renovação com sucesso', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationPartnerRenewalSuccessModal(),
      localized: true,
      locOverrides: const {
        'legal_obligation_partner_renewal_success_message':
            'Renovação solicitada com sucesso.',
        'close': 'Fechar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_renewal_success.png'),
    );
  });

  testWidgets('golden — modal de renovação com falha', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationPartnerRenewalFailureModal(),
      localized: true,
      locOverrides: const {
        'legal_obligation_partner_renewal_failure_message':
            'Não foi possível solicitar a renovação.',
        'close': 'Fechar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_renewal_failure.png'),
    );
  });

  testWidgets('golden — modal de parceiro notificado', (tester) async {
    await pumpApp(
      tester,
      const LegalObligationNotifyPartnerSuccessModal(),
      localized: true,
      locOverrides: const {
        'legal_obligation_notify_partner_success_message':
            'Parceiro notificado com sucesso.',
        'close': 'Fechar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_notify_success.png'),
    );
  });

  testWidgets('golden — receber por e-mail', (tester) async {
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
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_email.png'),
    );
  });

  testWidgets('golden — abas de eficiência', (tester) async {
    await pumpApp(
      tester,
      EfficiencyTabsWidget(
        selectedTab: EfficiencyTabType.responsibles,
        onTabChanged: (_) {},
        responsiblesLabel: 'Responsáveis',
        groupsLabel: 'Grupos',
      ),
      shrinkWrap: false,
      surface: const Size(400, 90),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/efficiency_tabs.png'),
    );
  });

  testWidgets('golden — tile sem subtítulo e cor inválida', (tester) async {
    await pumpApp(
      tester,
      const EfficiencyTileWidget(
        item: EfficiencyItem(
          id: '2',
          title: '',
          completed: 0,
          pending: 1,
          inProgress: 0,
          avatarColor: 'bad-color',
        ),
        showDivider: false,
      ),
      localized: true,
      locOverrides: _labels,
      shrinkWrap: false,
      surface: const Size(400, 160),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/efficiency_tile_fallback.png'),
    );
  });

  testWidgets('golden — tooltip simples sem título', (tester) async {
    await pumpApp(
      tester,
      const Padding(
        padding: EdgeInsets.all(16),
        child: SimpleTooltipWidget(
          message: 'A tarefa permanece visível.',
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/simple_tooltip_message.png'),
    );
  });

  testWidgets('golden — tag de status sem rótulo customizado', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return LegalObligationStatusTag(
            status: LegalObligationStatus.emAnalise,
            theme: Theme.of(context),
          );
        },
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_status_tag.png'),
    );
  });

  testWidgets('golden — confirmação de renovação', (tester) async {
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/legal_obligation_renewal_confirm.png'),
    );
  });
}
