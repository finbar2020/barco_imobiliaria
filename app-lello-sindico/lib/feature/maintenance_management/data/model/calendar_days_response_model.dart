import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/calendar_days_response_entity.dart';
import 'calendar_day_model.dart';
import 'package:intl/intl.dart';

part 'calendar_days_response_model.g.dart';

@JsonSerializable()
class CalendarDaysResponseModel {
  final int month;

  final int year;

  final List<CalendarDayModel> days;

  const CalendarDaysResponseModel({
    required this.month,
    required this.year,
    required this.days,
  });

  factory CalendarDaysResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarDaysResponseModelFromJson(json);

  factory CalendarDaysResponseModel.fromDaysArray(
    List<dynamic> daysArray,
    int month,
    int year,
  ) {
    final List<CalendarDayModel> days = [];

    for (final dayData in daysArray) {
      if (dayData is Map<String, dynamic>) {
        int? dayNumber;
        int taskCount = 0;

        if (dayData.containsKey('day') && dayData['day'] is int) {
          dayNumber = dayData['day'] as int;
        } else if (dayData.containsKey('date')) {
          final dateStr = dayData['date'].toString();
          final date = _parseDate(dateStr);
          if (date != null && date.month == month && date.year == year) {
            dayNumber = date.day;
          }
        }

        // Extrai a quantidade de tarefas
        if (dayData.containsKey('size') && dayData['size'] is int) {
          taskCount = dayData['size'] as int;
        } else if (dayData.containsKey('tasks') && dayData['tasks'] is List) {
          taskCount = (dayData['tasks'] as List).length;
        }

        if (dayNumber != null && taskCount > 0) {
          days.add(CalendarDayModel(
            day: dayNumber,
            hasEvents: true,
            taskCount: taskCount,
          ));
        }
      }
    }

    // Ordena por dia
    days.sort((a, b) => a.day.compareTo(b.day));

    return CalendarDaysResponseModel(
      month: month,
      year: year,
      days: days,
    );
  }

  factory CalendarDaysResponseModel.fromTasksArray(
    List<dynamic> tasksArray,
    int month,
    int year,
  ) {
    final Map<int, int> taskCountByDay = {};

    for (final task in tasksArray) {
      if (task is Map<String, dynamic>) {
        String? dateStr;
        if (task.containsKey('dtStart') && task['dtStart'] != null) {
          dateStr = task['dtStart'].toString();
        } else if (task.containsKey('date') && task['date'] != null) {
          dateStr = task['date'].toString();
        } else if (task.containsKey('until') && task['until'] != null) {
          dateStr = task['until'].toString();
        }

        if (dateStr != null && dateStr.isNotEmpty) {
          DateTime? date = _parseDate(dateStr);

          if (date != null) {
            if (date.month == month && date.year == year) {
              final day = date.day;
              taskCountByDay[day] = (taskCountByDay[day] ?? 0) + 1;
            } else {
              // Data não corresponde ao mês/ano filtrado
            }
          } else {
            // Falha ao parsear a data
          }
        } else {
          // Data não encontrada no task
        }
      }
    }

    // Converte para lista de CalendarDayModel
    final days = taskCountByDay.entries
        .map((entry) => CalendarDayModel(
              day: entry.key,
              hasEvents: true,
              taskCount: entry.value,
            ))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return CalendarDaysResponseModel(
      month: month,
      year: year,
      days: days,
    );
  }

  /// Helper para parsear diferentes formatos de data
  static DateTime? _parseDate(String dateStr) {
    // Remove espaços e caracteres especiais
    dateStr = dateStr.trim();

    // Formatos de data possíveis
    final dateFormats = [
      DateFormat('dd/MM/yyyy'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('dd/MM/yyyy HH:mm:ss'),
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-ddTHH:mm:ss'),
      DateFormat('yyyy-MM-ddTHH:mm:ssZ'),
    ];

    for (final format in dateFormats) {
      try {
        return format.parse(dateStr);
      } catch (e) {
        // Continua tentando outros formatos
      }
    }

    // Se nenhum formato funcionou, tenta extrair apenas os números
    try {
      final regex = RegExp(r'(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})');
      final match = regex.firstMatch(dateStr);
      if (match != null) {
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Ignore
    }

    return null;
  }

  Map<String, dynamic> toJson() => _$CalendarDaysResponseModelToJson(this);

  CalendarDaysResponseEntity toEntity() {
    return CalendarDaysResponseEntity(
      month: month,
      year: year,
      days: days.map((model) => model.toEntity()).toList(),
    );
  }

  factory CalendarDaysResponseModel.fromEntity(
      CalendarDaysResponseEntity entity) {
    return CalendarDaysResponseModel(
      month: entity.month,
      year: entity.year,
      days: entity.days
          .map((entity) => CalendarDayModel.fromEntity(entity))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDaysResponseModel &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year &&
          days == other.days;

  @override
  int get hashCode => month.hashCode ^ year.hashCode ^ days.hashCode;

  @override
  String toString() {
    return 'CalendarDaysResponseModel(month: $month, year: $year, days: ${days.length})';
  }
}
