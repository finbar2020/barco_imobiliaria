import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:essentials/essentials.dart';
import '../../../domain/entity/maintenance_task_event_entity.dart';
import '../../../domain/entity/schedule_event_task_entity.dart';

class AgendaTaskModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final DateTime startTime;
  final DateTime? endTime;
  final String location;
  final String responsible;
  final bool isAllDay;

  AgendaTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.responsible,
    required this.isAllDay,
  });

  factory AgendaTaskModel.fromEntity(MaintenanceTaskEventEntity entity) {
    return AgendaTaskModel(
      id: entity.idTask ?? '',
      title: entity.name,
      description: entity.fullDescription,
      type: entity.typeTask,
      status: entity.status,
      startTime: DateTime.parse(entity.dtstart),
      endTime: entity.dtend.isNotEmpty ? DateTime.parse(entity.dtend) : null,
      location: _extractLocation(entity.fullDescription),
      responsible: entity.responsibleUserable,
      isAllDay: entity.allDay,
    );
  }

  factory AgendaTaskModel.fromScheduleEventTaskEntity(
      ScheduleEventTaskEntity entity) {
    return AgendaTaskModel(
      id: entity.idTask ?? entity.idScheduleEvent,
      title: entity.name,
      description: entity.fullDescription,
      type: entity.typeTask,
      status: entity.status,
      startTime: _parseDateTime(entity.dtStart),
      location: _extractLocation(entity.fullDescription),
      responsible: entity.responsibleUserable.isNotEmpty
          ? entity.responsibleUserable
          : 'Não atribuído',
      isAllDay: entity.allDay,
    );
  }

  static DateTime _parseDateTime(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();

    try {
      if (dateStr.contains('T')) {
        return DateTime.parse(dateStr);
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split(' ');
        final datePart = parts[0];
        final timePart = parts.length > 1 ? parts[1] : '00:00:00';

        final dateComponents = datePart.split('/');
        final timeComponents = timePart.split(':');

        return DateTime(
          int.parse(dateComponents[2]), // year
          int.parse(dateComponents[1]), // month
          int.parse(dateComponents[0]), // day
          int.parse(timeComponents[0]), // hour
          timeComponents.length > 1
              ? int.parse(timeComponents[1])
              : 0, // minute
          timeComponents.length > 2
              ? int.parse(timeComponents[2])
              : 0, // second
        );
      } else {
        return DateTime.parse(dateStr);
      }
    } catch (e) {
      return DateTime.now();
    }
  }

  String get timeText {
    if (isAllDay) {
      return 'Dia todo';
    }

    final startFormatted = DateFormat('HH:mm').format(startTime);

    if (endTime != null) {
      final endFormatted = DateFormat('HH:mm').format(endTime!);
      return '$startFormatted - $endFormatted';
    }

    return startFormatted;
  }

  Color getTypeColor() {
    switch (type.toLowerCase()) {
      case 'manutenção':
      case 'manutencao':
      case 'maintenance':
        return Colors.blue;
      case 'vistoria':
      case 'inspeção':
      case 'inspecao':
      case 'inspection':
        return Colors.green;
      case 'reunião':
      case 'reuniao':
      case 'meeting':
        return Colors.orange;
      case 'emergência':
      case 'emergencia':
      case 'emergency':
        return Colors.red;
      case 'limpeza':
      case 'cleaning':
        return Colors.teal;
      case 'segurança':
      case 'seguranca':
      case 'security':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color getStatusColor(ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
      case 'completed':
      case 'done':
        return LelloTheme.palleteOf(theme).success();
      case 'pendente':
      case 'pending':
      case 'aguardando':
        return LelloTheme.palleteOf(theme).warning();
      case 'em andamento':
      case 'em_andamento':
      case 'in_progress':
      case 'progress':
        return LelloTheme.palleteOf(theme).raffle();
      case 'cancelado':
      case 'cancelled':
      case 'canceled':
        return LelloTheme.palleteOf(theme).error();
      default:
        return LelloTheme.palleteOf(theme).grey();
    }
  }

  String get localizedType {
    switch (type.toLowerCase()) {
      case 'manutenção':
      case 'manutencao':
      case 'maintenance':
        return 'Manutenção';
      case 'vistoria':
      case 'inspeção':
      case 'inspecao':
      case 'inspection':
        return 'Vistoria';
      case 'reunião':
      case 'reuniao':
      case 'meeting':
        return 'Reunião';
      case 'emergência':
      case 'emergencia':
      case 'emergency':
        return 'Emergência';
      case 'limpeza':
      case 'cleaning':
        return 'Limpeza';
      case 'segurança':
      case 'seguranca':
      case 'security':
        return 'Segurança';
      default:
        return type;
    }
  }

  String get localizedStatus {
    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
      case 'completed':
      case 'done':
        return 'Concluído';
      case 'pendente':
      case 'pending':
      case 'aguardando':
        return 'Pendente';
      case 'em andamento':
      case 'em_andamento':
      case 'in_progress':
      case 'progress':
        return 'Em andamento';
      case 'cancelado':
      case 'cancelled':
      case 'canceled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  static String _extractLocation(String description) {
    final locationKeywords = [
      'bloco',
      'apartamento',
      'apto',
      'andar',
      'sala',
      'área',
      'elevador',
      'portaria',
      'garagem',
      'piscina',
      'academia',
      'salão',
      'playground',
    ];

    final lowerDescription = description.toLowerCase();

    for (final keyword in locationKeywords) {
      if (lowerDescription.contains(keyword)) {
        final sentences = description.split(RegExp(r'[.!?]'));
        for (final sentence in sentences) {
          if (sentence.toLowerCase().contains(keyword)) {
            return sentence.trim();
          }
        }
      }
    }

    if (description.length > 50) {
      return '${description.substring(0, 50)}...';
    }

    return description.isNotEmpty ? description : 'Local não especificado';
  }
}
