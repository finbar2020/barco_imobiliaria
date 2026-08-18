import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/model/agenda_task_model.dart';

AgendaTaskModel _model({
  String type = 'limpeza',
  String status = 'pendente',
  bool allDay = false,
  DateTime? endTime,
  DateTime? start,
}) {
  return AgendaTaskModel(
    id: '1',
    title: 'Tarefa',
    description: 'desc',
    type: type,
    status: status,
    startTime: start ?? DateTime(2026, 1, 10, 8, 30),
    endTime: endTime,
    location: 'Hall',
    responsible: 'Ana',
    isAllDay: allDay,
  );
}

void main() {
  test('fromEntity preenche fim, local e id vazio', () {
    final entity = MaintenanceTaskEventEntity(
      typeTask: 'manutenção',
      name: 'Vistoria',
      fullDescription: 'Conferir o elevador do bloco B. Depois a portaria.',
      responsibleUserable: 'João',
      timeStart: '08:00',
      timeEnd: '09:00',
      timeDescription: 'manhã',
      dtstart: '2026-01-10T08:00:00',
      dtend: '2026-01-10T09:00:00',
      dtstartFormatted: '10/01/2026',
      dtendFormatted: '10/01/2026',
      status: 'done',
      allDay: false,
    );
    final model = AgendaTaskModel.fromEntity(entity);
    expect(model.id, '');
    expect(model.title, 'Vistoria');
    expect(model.endTime, isNotNull);
    expect(model.location.toLowerCase(), contains('elevador'));
    expect(model.responsible, 'João');
  });

  test('fromEntity sem dtend e descrição longa sem local conhecido', () {
    final entity = MaintenanceTaskEventEntity(
      idTask: 't9',
      typeTask: 'outro',
      name: 'X',
      fullDescription:
          'Texto bem longo sem palavra-chave de local para forçar o recorte da descrição usada como local.',
      responsibleUserable: '',
      timeStart: '',
      timeEnd: '',
      timeDescription: '',
      dtstart: '2026-03-01T00:00:00',
      dtend: '',
      dtstartFormatted: '',
      dtendFormatted: '',
      status: 'x',
      allDay: true,
    );
    final model = AgendaTaskModel.fromEntity(entity);
    expect(model.id, 't9');
    expect(model.endTime, isNull);
    expect(model.location.endsWith('...'), isTrue);
  });

  test('fromScheduleEventTaskEntity cobre datas e responsável vazio', () {
    final withIso = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e1',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'ok',
        responsibleUserable: 'Ana',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '08:00',
        timeDescription: '',
        dtStart: '2026-01-10T08:00:00',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(withIso.startTime.hour, 8);
    expect(withIso.responsible, 'Ana');

    final withBr = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e2',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: '',
        responsibleUserable: '',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: '10/01/2026 08:30:15',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(withBr.startTime, DateTime(2026, 1, 10, 8, 30, 15));
    expect(withBr.responsible, 'Não atribuído');
    expect(withBr.location, 'Local não especificado');

    final dateOnly = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e3',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'sala 2',
        responsibleUserable: 'x',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: '10/01/2026',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(dateOnly.startTime, DateTime(2026, 1, 10));
    expect(dateOnly.location, 'sala 2');

    final hourOnly = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e4',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'ok',
        responsibleUserable: 'x',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: '10/01/2026 7',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(hourOnly.startTime.hour, 7);

    final plain = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e5',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'ok',
        responsibleUserable: 'x',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: '2026-02-02',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(plain.startTime.month, 2);

    final invalid = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e6',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'ok',
        responsibleUserable: 'x',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: 'invalido',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(invalid.startTime.year, greaterThanOrEqualTo(2026));

    final emptyDate = AgendaTaskModel.fromScheduleEventTaskEntity(
      const ScheduleEventTaskEntity(
        idSchedule: 's',
        idScheduleEvent: 'e7',
        typeTask: 'OS',
        name: 'Bomba',
        fullDescription: 'ok',
        responsibleUserable: 'x',
        procedureGroupId: '',
        responsibleId: '',
        timeStart: '',
        timeDescription: '',
        dtStart: '',
        dtStartFormatted: '',
        status: 'DONE',
        allDay: false,
      ),
    );
    expect(emptyDate.id, 'e7');
  });

  test('timeText cobre dia todo, intervalo e só início', () {
    expect(_model(allDay: true).timeText, 'Dia todo');
    expect(
      _model(endTime: DateTime(2026, 1, 10, 9, 0)).timeText,
      '08:30 - 09:00',
    );
    expect(_model().timeText, '08:30');
  });

  test('localizedType e getTypeColor cobrem os aliases', () {
    const types = {
      'manutenção': 'Manutenção',
      'manutencao': 'Manutenção',
      'maintenance': 'Manutenção',
      'vistoria': 'Vistoria',
      'inspeção': 'Vistoria',
      'inspecao': 'Vistoria',
      'inspection': 'Vistoria',
      'reunião': 'Reunião',
      'reuniao': 'Reunião',
      'meeting': 'Reunião',
      'emergência': 'Emergência',
      'emergencia': 'Emergência',
      'emergency': 'Emergência',
      'limpeza': 'Limpeza',
      'cleaning': 'Limpeza',
      'segurança': 'Segurança',
      'seguranca': 'Segurança',
      'security': 'Segurança',
      'outro': 'outro',
    };
    for (final entry in types.entries) {
      expect(_model(type: entry.key).localizedType, entry.value);
      expect(_model(type: entry.key).getTypeColor(), isA<Color>());
    }
  });

  testWidgets('localizedStatus e getStatusColor cobrem os aliases',
      (tester) async {
    final theme = LelloTheme.light;
    const statuses = {
      'concluído': 'Concluído',
      'concluido': 'Concluído',
      'completed': 'Concluído',
      'done': 'Concluído',
      'pendente': 'Pendente',
      'pending': 'Pendente',
      'aguardando': 'Pendente',
      'em andamento': 'Em andamento',
      'em_andamento': 'Em andamento',
      'in_progress': 'Em andamento',
      'progress': 'Em andamento',
      'cancelado': 'Cancelado',
      'cancelled': 'Cancelado',
      'canceled': 'Cancelado',
      'outro': 'outro',
    };
    for (final entry in statuses.entries) {
      final model = _model(status: entry.key);
      expect(model.localizedStatus, entry.value);
      expect(model.getStatusColor(theme), isA<Color>());
    }
  });
}
