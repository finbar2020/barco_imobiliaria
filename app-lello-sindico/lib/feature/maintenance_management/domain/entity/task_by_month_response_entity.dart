import 'task_by_month_data_entity.dart';

class TaskByMonthResponseEntity {
  final List<TaskByMonthDataEntity> formularyByMonthDto;
  final int totalConcluidos;
  final int totalNaoConcluidos;
  final int totalGeral;

  const TaskByMonthResponseEntity({
    required this.formularyByMonthDto,
    required this.totalConcluidos,
    required this.totalNaoConcluidos,
    required this.totalGeral,
  });
}