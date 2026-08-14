import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/task_by_month_response_entity.dart';

class ServiceOrderAnalysisChart extends StatefulWidget {
  final TaskByMonthResponseEntity taskByMonthData;

  const ServiceOrderAnalysisChart({
    super.key,
    required this.taskByMonthData,
  });

  @override
  State<ServiceOrderAnalysisChart> createState() =>
      _ServiceOrderAnalysisChartState();
}

class _ServiceOrderAnalysisChartState extends State<ServiceOrderAnalysisChart> {
  late List<ChartDataPoint> chartData;

  @override
  void initState() {
    super.initState();
    chartData = _prepareChartData();
  }

  @override
  void didUpdateWidget(ServiceOrderAnalysisChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskByMonthData != widget.taskByMonthData) {
      chartData = _prepareChartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quantidade mensal de ordens de serviço",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: chartData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 48,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Nenhum dado disponível para análise mensal",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : _buildBarChart(chartData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<ChartDataPoint> chartData) {
    if (chartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              "Nenhum dado disponível",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final maxValue = _getMaxValue(chartData);
    final chartMaxY = maxValue > 0 ? maxValue * 1.2 : 10.0;
    final interval = maxValue > 20 ? 5.0 : (maxValue > 10 ? 2.0 : 1.0);

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 0.5,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label = rodIndex == 0 ? 'Concluídas' : 'Pendentes';
              return BarTooltipItem(
                '$label: ${rod.toY.round()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= chartData.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    chartData[index].month,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(chartData.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: chartData[i].completed.toDouble(),
                color: const Color(0xFFe74c3c),
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: chartData[i].pending.toDouble(),
                color: const Color(0xFFe74c3c),
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            barsSpace: 4,
          );
        }),
        maxY: chartMaxY,
      ),
    );
  }

  List<ChartDataPoint> _prepareChartData() {
    print("📊 [CHART] Preparando dados do gráfico mensal...");
    print(
        "📊 [CHART] Total de séries: ${widget.taskByMonthData.formularyByMonthDto.length}");
    print("📊 [CHART] Total geral: ${widget.taskByMonthData.totalGeral}");
    print(
        "📊 [CHART] Total concluídos: ${widget.taskByMonthData.totalConcluidos}");

    final Map<String, ChartDataPoint> monthlyData = {};

    // Processa cada série de dados
    for (final taskByMonth in widget.taskByMonthData.formularyByMonthDto) {
      print("📊 [CHART] Processando série: ${taskByMonth.name}");
      print("📊 [CHART] Pontos de dados na série: ${taskByMonth.data.length}");

      for (final dataPoint in taskByMonth.data) {
        final monthKey = dataPoint.key;
        print("📊 [CHART] Ponto: ${dataPoint.key} = ${dataPoint.value}");

        // Inicializa o mês se não existir
        if (!monthlyData.containsKey(monthKey)) {
          monthlyData[monthKey] = ChartDataPoint(
            month: _formatMonthLabel(monthKey),
            completed: 0,
            pending: 0,
          );
        }

        monthlyData[monthKey] = ChartDataPoint(
          month: monthlyData[monthKey]!.month,
          completed: monthlyData[monthKey]!.completed,
          pending: monthlyData[monthKey]!.pending + dataPoint.value,
        );
      }
    }

    // Converte para lista e ordena por data
    final entries = monthlyData.entries.toList();
    entries.sort((a, b) => _compareDateKeys(a.key, b.key));

    // MUDANÇA: Usar todos os meses ao invés de limitar a 3 para garantir que os dados apareçam
    final result = entries.map((entry) => entry.value).toList();
    print("📊 [CHART] Dados finais preparados: ${result.length} pontos");
    for (int i = 0; i < result.length; i++) {
      print(
          "📊 [CHART] ${result[i].month}: ${result[i].completed} concluídos, ${result[i].pending} pendentes");
    }

    return result;
  }

  int _compareDateKeys(String dateKey1, String dateKey2) {
    try {
      final date1 = _parseMonthKey(dateKey1);
      final date2 = _parseMonthKey(dateKey2);

      if (date1 != null && date2 != null) {
        return date1.compareTo(date2);
      }
    } catch (e) {}

    try {
      final parts1 = dateKey1.split('/');
      final parts2 = dateKey2.split('/');

      if (parts1.length >= 2 && parts2.length >= 2) {
        final monthAbbr1 = parts1[0].toUpperCase();
        final monthAbbr2 = parts2[0].toUpperCase();
        final year1Str = parts1[1];
        final year2Str = parts2[1];

        // Mapear abreviações dos meses para números
        final monthMap = {
          'JAN': 1,
          'FEV': 2,
          'MAR': 3,
          'ABR': 4,
          'MAI': 5,
          'JUN': 6,
          'JUL': 7,
          'AGO': 8,
          'SET': 9,
          'OUT': 10,
          'NOV': 11,
          'DEZ': 12
        };

        final month1 = monthMap[monthAbbr1];
        final month2 = monthMap[monthAbbr2];

        if (month1 != null && month2 != null) {
          var year1 = int.parse(year1Str);
          var year2 = int.parse(year2Str);

          // Assumir que anos de 2 dígitos são 20XX se <= 50, senão 19XX
          if (year1 <= 50)
            year1 += 2000;
          else if (year1 < 100) year1 += 1900;
          if (year2 <= 50)
            year2 += 2000;
          else if (year2 < 100) year2 += 1900;

          if (year1 != year2) {
            return year1.compareTo(year2);
          } else {
            return month1.compareTo(month2);
          }
        }
      }
    } catch (e) {}

    return dateKey1.compareTo(dateKey2);
  }

  DateTime? _parseMonthKey(String monthKey) {
    try {
      if (monthKey.contains('/') && monthKey.length >= 6) {
        final parts = monthKey.split('/');
        if (parts.length >= 2) {
          final monthAbbr = parts[0].toUpperCase();
          final yearStr = parts[1];

          // Mapear abreviações dos meses para números
          final monthMap = {
            'JAN': 1,
            'FEV': 2,
            'MAR': 3,
            'ABR': 4,
            'MAI': 5,
            'JUN': 6,
            'JUL': 7,
            'AGO': 8,
            'SET': 9,
            'OUT': 10,
            'NOV': 11,
            'DEZ': 12
          };

          final month = monthMap[monthAbbr];
          if (month != null) {
            // Assumir que anos de 2 dígitos são 20XX se <= 50, senão 19XX
            var year = int.parse(yearStr);
            if (year <= 50) {
              year += 2000;
            } else if (year < 100) {
              year += 1900;
            }

            if (year >= 1900 && year <= 2100 && month >= 1 && month <= 12) {
              return DateTime(year, month);
            }
          }
        }
      }
    } catch (e) {}
    return null;
  }

  String _formatMonthLabel(String monthKey) {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    try {
      if (monthKey.contains('-')) {
        final parts = monthKey.split('-');
        if (parts.length >= 2) {
          final month = int.parse(parts[1]);
          if (month >= 1 && month <= 12) {
            return months[month - 1];
          }
        }
      }

      if (monthKey.length == 6 && RegExp(r'^\d{6}$').hasMatch(monthKey)) {
        final month = int.parse(monthKey.substring(4, 6));
        if (month >= 1 && month <= 12) {
          return months[month - 1];
        }
      }

      if (monthKey.contains('/')) {
        final parts = monthKey.split('/');
        if (parts.length == 2) {
          if (parts[0].length == 3 &&
              RegExp(r'^[A-Z]{3}$').hasMatch(parts[0])) {
            final monthName = parts[0];
            final monthNumber = _getMonthFromName(monthName);
            if (monthNumber != null) {
              return months[monthNumber - 1];
            }
          } else {
            final month = int.parse(parts[0]);
            if (month >= 1 && month <= 12) {
              return months[month - 1];
            }
          }
        }
      }
    } catch (e) {
      // Erro no parsing
    }

    return monthKey.length > 3 ? monthKey.substring(0, 3) : monthKey;
  }

  int? _getMonthFromName(String monthName) {
    const monthMap = {
      'JAN': 1,
      'FEV': 2,
      'MAR': 3,
      'ABR': 4,
      'MAI': 5,
      'JUN': 6,
      'JUL': 7,
      'AGO': 8,
      'SET': 9,
      'OUT': 10,
      'NOV': 11,
      'DEZ': 12
    };
    return monthMap[monthName.toUpperCase()];
  }

  double _getMaxValue(List<ChartDataPoint> chartData) {
    if (chartData.isEmpty) return 10.0;

    double maxValue = 0.0;
    for (final data in chartData) {
      final completedValue = data.completed.toDouble();
      final pendingValue = data.pending.toDouble();

      if (completedValue > maxValue) maxValue = completedValue;
      if (pendingValue > maxValue) maxValue = pendingValue;
    }

    // Garante um valor mínimo para o gráfico ficar visível
    return maxValue > 0 ? maxValue : 10.0;
  }
}

class ChartDataPoint {
  final String month;
  final int completed;
  final int pending;

  ChartDataPoint({
    required this.month,
    required this.completed,
    required this.pending,
  });
}
