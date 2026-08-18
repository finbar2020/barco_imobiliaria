import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_vacations_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_extra_hour_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_grid_button.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_detail_buttons.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_certificates/certificate_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    Intl.defaultLocale = 'pt_BR';
  });

  testWidgets('golden — botão do grid com valor', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 96,
        child: TimesheetMenuGridButton(
          value: '3',
          title: 'Atrasos',
          onPressed: () {},
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_grid_button.png'),
    );
  });

  testWidgets('golden — botão do grid zerado', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        height: 96,
        child: TimesheetMenuGridButton(
          value: '0',
          title: 'Faltas',
          onPressed: () {},
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_grid_button_zero.png'),
    );
  });

  testWidgets('golden — dropdown de ocorrência', (tester) async {
    await pumpApp(
      tester,
      TimesheetOccurrenceDropdown(
        hintText: 'Selecione',
        selectedValue: 'Abonar',
        width: 200,
        items: const ['Abonar', 'Descontar'],
        onChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_occurrence_dropdown.png'),
    );
  });

  testWidgets('golden — dropdown do espelho de ponto', (tester) async {
    await pumpApp(
      tester,
      TimesheetPointMirrorDropdown(
        hintText: 'Selecione',
        selectedValue: 'Assinar',
        isNotify: false,
        onChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_point_mirror_dropdown.png'),
    );
  });

  testWidgets('golden — dropdown da lista de detalhes', (tester) async {
    await pumpApp(
      tester,
      ListDetailsDropdown(
        hintText: 'Selecione',
        selectedValue: 'Abonar',
        width: 200,
        onChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_list_details_dropdown.png'),
    );
  });

  testWidgets('golden — cartão de atestado', (tester) async {
    await pumpApp(
      tester,
      CertificateCard(
        entity: TimesheetOccurrenceCertificateEntity(
          name: 'JOAO SILVA',
          initDate: '2026-08-01',
          endDate: '2026-08-05',
          archiveHash: 'abc123',
        ),
        onTap: () {},
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_certificate_init_date': 'Início: ',
        'gdp_timesheet_certificate_end_date': 'Fim: ',
        'gdp_timesheet_certificate_title': 'Atestado',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_certificate_card.png'),
    );
  });

  testWidgets('golden — atraso tratado com sucesso', (tester) async {
    await pumpApp(
      tester,
      const TimesheetDetailListSuccessPage(),
      wrapInScaffold: false,
      surface: const Size(400, 640),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_detail_delay_success': 'Atraso tratado',
        'conclude': 'Concluir',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_delay_success.png'),
    );
  });

  testWidgets('golden — falha ao tratar atraso', (tester) async {
    await pumpApp(
      tester,
      const TimesheetDetailListFailedPage(),
      wrapInScaffold: false,
      surface: const Size(400, 640),
      localized: true,
      locOverrides: const {
        'facial_biometric_error_title': 'Não foi possível concluir',
        'error_common_title': 'Tente novamente em instantes.',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_delay_failed.png'),
    );
  });

  testWidgets('golden — cartão de férias', (tester) async {
    await pumpApp(
      tester,
      ListVacationCard(
        entity: TimesheetOccurrenceVacationEntity(
          name: 'ANA LIMA',
          initDate: '2026-08-01',
          endDate: '2026-08-15',
          archiveName: 'recibo.pdf',
        ),
        onTap: () {},
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_detail_vacation_init': 'Início: ',
        'gdp_timesheet_detail_vacation_end': 'Fim: ',
        'gdp_timesheet_detail_vacation_receipt': 'Recibo',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_vacation_card.png'),
    );
  });

  testWidgets('golden — cartão de atraso com ação em massa', (tester) async {
    await pumpApp(
      tester,
      ListDetailsCard(
        selectCheckBox: (_) {},
        massAction: true,
        indexCheckBox: true,
        selectedValue: null,
        selectIndividualAction: (_) {},
        type: TimesheetOccurrenceTypeEnum.delay,
        entity: TimesheetOccurrenceEntity(
          photo: '',
          name: 'JOAO SILVA',
          jobPosition: 'Porteiro',
          numCra: '1',
          receivedMark: '08:00;09:10',
          hourRange: '08:00;17:00',
          referenceDate: '2026-08-10',
          occurenceDuration: 70,
          occurrenceName: 'Atraso',
          canTreat: true,
          occurrenceType: 'DELAY',
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'accountability_history_date': 'Data',
        'gdp_timesheet_detail_marks': 'Marcações: ',
        'gdp_timesheet_detail_delays_in_hours': 'Atraso: ',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_delay_card.png'),
    );
  });

  testWidgets('golden — cartão de hora extra', (tester) async {
    await pumpApp(
      tester,
      ListDetailsCard(
        selectCheckBox: (_) {},
        massAction: false,
        indexCheckBox: false,
        selectedValue: null,
        selectIndividualAction: (_) {},
        type: TimesheetOccurrenceTypeEnum.extraHour,
        entity: TimesheetOccurrenceEntity(
          photo: '',
          name: 'MARIA SOUZA',
          jobPosition: 'Zeladora',
          numCra: '2',
          receivedMark: '18:00;20:00',
          hourRange: '08:00;17:00',
          referenceDate: '2026-08-11',
          occurenceDuration: 120,
          occurrenceName: 'Hora extra 50%',
          canTreat: true,
          occurrenceType: 'EXTRA',
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'accountability_history_date': 'Data',
        'gdp_timesheet_detail_marks': 'Marcações: ',
        'gdp_timesheet_grid_extra_hours': 'Hora extra',
        'gdp_payslip_selection_type': 'Tipo',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_extra_hour_card.png'),
    );
  });

  testWidgets('golden — botões do detalhe com download', (tester) async {
    await pumpApp(
      tester,
      TimesheetDetailButtons(
        showNotifyButton: true,
        isNotifyButton: false,
        goToOccurrences: () {},
        getTimesheetReport: () {},
        put: () {},
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_go_occurrence': 'Ocorrências',
        'gdp_timesheet_download_report': 'Baixar relatório',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_detail_buttons.png'),
    );
  });

  testWidgets('golden — horas extras do menu', (tester) async {
    await pumpApp(
      tester,
      TimesheetMenuExtraHourWidget(
        state: TimesheetMonthResumeLoadedState(
          date: DateTime(2026, 8, 1),
          entity: TimesheetMonthResumeEntity(
            extraHoursHundred: 90,
            otherExtraHours: -30,
          ),
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_extra_hour_detail_info': 'Detalhe das horas extras',
        'gdp_timesheet_grid_extra_hours': 'Horas extras',
        'gdp_timesheet_extra_hour_100': '100%',
        'gdp_timesheet_extra_hour_other': 'Outras',
        'gdp_timesheet_extra_hour_more': 'a mais ',
        'gdp_timesheet_extra_hour_less': 'a menos ',
        'gdp_timesheet_extra_hour_month': 'no mês',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_extra_hours.png'),
    );
  });

  testWidgets('golden — cartão de falta', (tester) async {
    await pumpApp(
      tester,
      ListDetailsCard(
        selectCheckBox: (_) {},
        massAction: false,
        indexCheckBox: false,
        selectedValue: null,
        selectIndividualAction: (_) {},
        type: TimesheetOccurrenceTypeEnum.fouls,
        entity: TimesheetOccurrenceEntity(
          photo: '',
          name: 'PEDRO ALVES',
          jobPosition: 'Porteiro',
          numCra: '3',
          receivedMark: '08:00;17:00',
          hourRange: '08:00;17:00',
          referenceDate: '2026-08-12',
          occurenceDuration: 480,
          occurrenceName: 'Falta',
          canTreat: true,
          occurrenceType: 'FOUL',
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'accountability_history_date': 'Data',
        'gdp_timesheet_detail_turn': 'Turno: ',
        'gdp_timesheet_detail_select': 'Selecione',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_foul_card.png'),
    );
  });

  testWidgets('golden — cartão do espelho de ponto', (tester) async {
    await pumpApp(
      tester,
      TimesheetPointMirrorCard(
        selectCheckBox: (_) {},
        massAction: true,
        indexCheckBox: true,
        selectedValue: null,
        selectIndividualAction: (_) {},
        isNotify: false,
        entity: TimesheetEntity(
          name: 'JOAO SILVA',
          jobPosition: 'Zelador',
          occurrences: 2,
          signatureEmployee: true,
          action: TimesheetActionEnum.none,
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_point_mirror_job': 'Cargo: ',
        'gdp_timesheet_point_mirror_signature': 'Assinatura: ',
        'gdp_timesheet_point_mirror_signatured': 'Assinado',
        'gdp_timesheet_point_mirror_pending': 'Pendente',
        'gdp_timesheet_point_mirror_ocurrence_pending': 'Pendências: ',
      },
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_point_mirror_card.png'),
    );
  });

  testWidgets('golden — cartão do espelho com assinatura pendente',
      (tester) async {
    await pumpApp(
      tester,
      TimesheetPointMirrorCard(
        selectCheckBox: (_) {},
        massAction: false,
        indexCheckBox: false,
        selectedValue: null,
        selectIndividualAction: (_) {},
        isNotify: false,
        entity: TimesheetEntity(
          name: 'ANA LIMA',
          jobPosition: 'Porteira',
          occurrences: 0,
          signatureEmployee: false,
          action: TimesheetActionEnum.sign,
        ),
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_point_mirror_job': 'Cargo: ',
        'gdp_timesheet_point_mirror_signature': 'Assinatura: ',
        'gdp_timesheet_point_mirror_signatured': 'Assinado',
        'gdp_timesheet_point_mirror_pending': 'Pendente',
        'gdp_timesheet_point_mirror_ocurrence_pending': 'Pendências: ',
        'gdp_timesheet_detail_select': 'Selecione',
      },
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/timesheet_point_mirror_pending.png'),
    );
  });
}
