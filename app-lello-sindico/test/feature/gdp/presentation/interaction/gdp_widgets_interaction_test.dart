import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_vacations_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_grid_button.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_detail_buttons.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_certificates/certificate_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    Intl.defaultLocale = 'pt_BR';
  });

  testWidgets('botão do grid com valor dispara onPressed', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      SizedBox(
        height: 96,
        child: TimesheetMenuGridButton(
          value: '3',
          title: 'Atrasos',
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Atrasos'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('botão do grid zerado não dispara onPressed', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      SizedBox(
        height: 96,
        child: TimesheetMenuGridButton(
          value: '0',
          title: 'Faltas',
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Faltas'));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('dropdown de ocorrência altera o valor', (tester) async {
    String? selected = 'Abonar';
    await pumpApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          return TimesheetOccurrenceDropdown(
            hintText: 'Selecione',
            selectedValue: selected,
            width: 220,
            items: const ['Abonar', 'Descontar'],
            onChanged: (value) => setState(() => selected = value),
          );
        },
      ),
    );

    await tester.tap(find.text('Abonar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descontar').last);
    await tester.pumpAndSettle();
    expect(selected, 'Descontar');
  });

  testWidgets('cartão de atestado dispara o download', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      CertificateCard(
        entity: TimesheetOccurrenceCertificateEntity(
          name: 'Maria',
          initDate: '2026-08-01',
          endDate: '2026-08-02',
          archiveHash: 'hash',
        ),
        onTap: () => tapped = true,
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_certificate_init_date': 'Início: ',
        'gdp_timesheet_certificate_end_date': 'Fim: ',
        'gdp_timesheet_certificate_title': 'Atestado',
      },
    );

    await tester.tap(find.text('Atestado: '));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('cartão de férias dispara o recibo', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      ListVacationCard(
        entity: TimesheetOccurrenceVacationEntity(
          name: 'ANA LIMA',
          initDate: '2026-08-01',
          endDate: '2026-08-15',
          archiveName: 'recibo.pdf',
        ),
        onTap: () => tapped = true,
      ),
      localized: true,
      locOverrides: const {
        'gdp_vacation_employee_name': 'Funcionário',
        'gdp_timesheet_detail_vacation_init': 'Início: ',
        'gdp_timesheet_detail_vacation_end': 'Fim: ',
        'gdp_timesheet_detail_vacation_receipt': 'Recibo',
      },
    );

    await tester.tap(find.text('Recibo'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('botões do detalhe disparam as ações', (tester) async {
    var occurrences = false;
    var report = false;
    var signed = false;
    await pumpApp(
      tester,
      TimesheetDetailButtons(
        showNotifyButton: false,
        isNotifyButton: true,
        goToOccurrences: () => occurrences = true,
        getTimesheetReport: () => report = true,
        put: () => signed = true,
      ),
      localized: true,
      locOverrides: const {
        'gdp_timesheet_go_occurrence': 'Ocorrências',
        'gdp_timesheet_download_report': 'Baixar relatório',
        'gdp_timesheet_notify': 'Notificar',
      },
    );

    await tester.tap(find.text('Ocorrências'));
    await tester.pump();
    await tester.tap(find.text('Baixar relatório'));
    await tester.pump();
    await tester.tap(find.text('Notificar'));
    await tester.pump();
    expect(occurrences, isTrue);
    expect(report, isTrue);
    expect(signed, isTrue);
  });

  testWidgets('cartão de falta dispara o checkbox', (tester) async {
    var checked = false;
    await pumpApp(
      tester,
      ListDetailsCard(
        selectCheckBox: (value) => checked = value == true,
        massAction: true,
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
      },
    );

    expect(find.text('08:00 - 17:00'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(checked, isTrue);
  });

  testWidgets('cartão do espelho dispara o checkbox', (tester) async {
    var checked = false;
    await pumpApp(
      tester,
      TimesheetPointMirrorCard(
        selectCheckBox: (value) => checked = value == true,
        massAction: true,
        indexCheckBox: false,
        selectedValue: null,
        selectIndividualAction: (_) {},
        isNotify: false,
        entity: TimesheetEntity(
          name: 'JOAO SILVA',
          jobPosition: 'Zelador',
          occurrences: 1,
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

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(checked, isTrue);
  });
}
