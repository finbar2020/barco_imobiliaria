import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/formulary_by_month_response_entity.dart';

class RoutineAnalysisChart extends StatelessWidget {
  final FormularyByMonthResponseEntity formularyData;

  const RoutineAnalysisChart({
    super.key,
    required this.formularyData,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _prepareChartData();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Análise de rotinas concluídas e pendentes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: _buildBarChart(chartData),
            ),
            const SizedBox(height: 20),
            _buildSummaryRow(chartData),
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

    double maxValue = 0;
    for (final data in chartData) {
      maxValue = [
        maxValue,
        data.concluidos.toDouble(),
        data.pendentes.toDouble()
      ].reduce((a, b) => a > b ? a : b);
    }

    double interval = maxValue > 20 ? 5 : (maxValue > 10 ? 2 : 1);

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
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label = rodIndex == 0 ? 'Concluídos' : 'Pendentes';
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
                int index = value.toInt();
                if (index < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      chartData[index].monthLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        barGroups: List.generate(chartData.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: chartData[i].concluidos.toDouble(),
                color: Colors.green,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: chartData[i].pendentes.toDouble(),
                color: Colors.orange,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            barsSpace: 4,
          );
        }),
        maxY: _getMaxValue(chartData) * 1.2,
      ),
    );
  }

  double _getMaxValue(List<ChartDataPoint> chartData) {
    if (chartData.isEmpty) return 0;

    double maxValue = 0;
    for (final data in chartData) {
      final maxConcluidos = data.concluidos.toDouble();
      final maxPendentes = data.pendentes.toDouble();
      final maxIndividual =
          maxConcluidos > maxPendentes ? maxConcluidos : maxPendentes;

      if (maxIndividual > maxValue) maxValue = maxIndividual;
    }
    return maxValue;
  }

  Widget _buildSummaryRow(List<ChartDataPoint> chartData) {
    final totalConcluidos =
        chartData.fold<int>(0, (sum, data) => sum + data.concluidos);
    final totalPendentes =
        chartData.fold<int>(0, (sum, data) => sum + data.pendentes);
    final totalGeral = totalConcluidos + totalPendentes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryItem(
          totalConcluidos.toString(),
          "Concluídos",
          Colors.green,
        ),
        _buildSummaryItem(
          totalPendentes.toString(),
          "Pendentes",
          Colors.orange,
        ),
        _buildSummaryItem(
          totalGeral.toString(),
          "Total",
          Colors.grey[600]!,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<ChartDataPoint> _prepareChartData() {
    final Map<String, ChartDataPoint> monthlyData = {};

    for (final formularyByMonth in formularyData.formularyByMonthDto) {
      for (final dataPoint in formularyByMonth.data) {
        final monthKey = dataPoint.key;

        if (!monthlyData.containsKey(monthKey)) {
          monthlyData[monthKey] = ChartDataPoint(
            monthLabel: _formatMonthLabel(monthKey),
            concluidos: 0,
            pendentes: 0,
            sortKey: monthKey,
          );
        }

        final seriesName = formularyByMonth.name.toLowerCase();

        if (seriesName.contains('concluído') ||
            seriesName.contains('concluido') ||
            seriesName.contains('finalizado') ||
            seriesName.contains('completo')) {
          monthlyData[monthKey] = monthlyData[monthKey]!.copyWith(
            concluidos: monthlyData[monthKey]!.concluidos + dataPoint.value,
          );
        } else if (seriesName.contains('pendente') ||
            seriesName.contains('aberto') ||
            seriesName.contains('em andamento') ||
            seriesName.contains('não concluído') ||
            seriesName.contains('nao concluido')) {
          monthlyData[monthKey] = monthlyData[monthKey]!.copyWith(
            pendentes: monthlyData[monthKey]!.pendentes + dataPoint.value,
          );
        } else {
          final totalApi = formularyData.totalGeral;
          final concluidosApi = formularyData.totalConcluidos;

          if (totalApi > 0) {
            final proporcaoConcluidos = concluidosApi / totalApi;
            final valorConcluidos =
                (dataPoint.value * proporcaoConcluidos).round();
            final valorPendentes = dataPoint.value - valorConcluidos;

            monthlyData[monthKey] = monthlyData[monthKey]!.copyWith(
              concluidos: monthlyData[monthKey]!.concluidos + valorConcluidos,
              pendentes: monthlyData[monthKey]!.pendentes + valorPendentes,
            );
          } else {
            monthlyData[monthKey] = monthlyData[monthKey]!.copyWith(
              concluidos: monthlyData[monthKey]!.concluidos + dataPoint.value,
            );
          }
        }
      }
    }

    final hasPendentes = monthlyData.values.any((data) => data.pendentes > 0);
    if (!hasPendentes && formularyData.totalNaoConcluidos > 0) {
      final totalConcluidos = formularyData.totalConcluidos;
      final totalPendentes = formularyData.totalNaoConcluidos;
      final totalGeral = formularyData.totalGeral;

      if (totalGeral > 0) {
        final newMonthlyData = <String, ChartDataPoint>{};
        final proporcaoConcluidos = totalConcluidos / totalGeral;

        int totalConcluidosDistribuidos = 0;
        int totalPendentesDistribuidos = 0;

        final entries = monthlyData.entries.toList();

        for (int i = 0; i < entries.length; i++) {
          final entry = entries[i];
          final data = entry.value;
          final totalMes = data.concluidos;

          int concluidosMes;
          int pendentesMes;

          if (i == entries.length - 1) {
            concluidosMes = totalConcluidos - totalConcluidosDistribuidos;
            pendentesMes = totalPendentes - totalPendentesDistribuidos;
          } else {
            concluidosMes = (totalMes * proporcaoConcluidos).round();
            pendentesMes = totalMes - concluidosMes;

            totalConcluidosDistribuidos += concluidosMes;
            totalPendentesDistribuidos += pendentesMes;
          }

          newMonthlyData[entry.key] = ChartDataPoint(
            monthLabel: data.monthLabel,
            concluidos: concluidosMes,
            pendentes: pendentesMes,
            sortKey: data.sortKey,
          );
        }

        monthlyData.clear();
        monthlyData.addAll(newMonthlyData);
      }
    }

    final sortedData = monthlyData.entries.toList()
      ..sort((a, b) => _compareDateKeys(a.key, b.key));

    final recentData = sortedData.length > 3
        ? sortedData.sublist(sortedData.length - 3)
        : sortedData;

    return recentData.map((entry) => entry.value).toList();
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
      final parts1 = dateKey1.split('-');
      final parts2 = dateKey2.split('-');

      if (parts1.length >= 2 && parts2.length >= 2) {
        final year1 = int.parse(parts1[0]);
        final month1 = int.parse(parts1[1]);
        final year2 = int.parse(parts2[0]);
        final month2 = int.parse(parts2[1]);

        if (year1 != year2) {
          return year1.compareTo(year2);
        } else {
          return month1.compareTo(month2);
        }
      }
    } catch (e) {}

    return dateKey1.compareTo(dateKey2);
  }

  DateTime? _parseMonthKey(String monthKey) {
    try {
      if (monthKey.contains('-') && monthKey.length >= 7) {
        final parts = monthKey.split('-');
        if (parts.length >= 2) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          if (year >= 1900 && year <= 2100 && month >= 1 && month <= 12) {
            return DateTime(year, month);
          }
        }
      }

      if (monthKey.length == 6 && RegExp(r'^\d{6}$').hasMatch(monthKey)) {
        final year = int.parse(monthKey.substring(0, 4));
        final month = int.parse(monthKey.substring(4, 6));
        if (year >= 1900 && year <= 2100 && month >= 1 && month <= 12) {
          return DateTime(year, month);
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
              final year = int.parse('20${parts[1]}');
              return DateTime(year, monthNumber);
            }
          } else {
            final month = int.parse(parts[0]);
            final year = int.parse(parts[1]);
            if (year >= 1900 && year <= 2100 && month >= 1 && month <= 12) {
              return DateTime(year, month);
            }
          }
        }
      }
    } catch (e) {
      // Erro no parsing
    }

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
}

class ChartDataPoint {
  final String monthLabel;
  final int concluidos;
  final int pendentes;
  final String sortKey;

  const ChartDataPoint({
    required this.monthLabel,
    required this.concluidos,
    required this.pendentes,
    required this.sortKey,
  });

  ChartDataPoint copyWith({
    String? monthLabel,
    int? concluidos,
    int? pendentes,
    String? sortKey,
  }) {
    return ChartDataPoint(
      monthLabel: monthLabel ?? this.monthLabel,
      concluidos: concluidos ?? this.concluidos,
      pendentes: pendentes ?? this.pendentes,
      sortKey: sortKey ?? this.sortKey,
    );
  }
}
