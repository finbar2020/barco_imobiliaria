import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Bar chart horizontal com labels à esquerda e valor à direita.
///
/// Prefere-se a implementação nativa (Row/Container) para evitar rótulos
/// truncados em muitas categorias — cada barra vira uma linha da lista.
class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({
    super.key,
    required this.data,
    this.valueFormatter,
    this.colorForIndex,
    this.emptyLabel = 'Sem dados',
    this.maxItems,
  });

  /// Mapa rótulo → valor. Ordenado por valor decrescente na renderização.
  final Map<String, num> data;
  final String Function(num value)? valueFormatter;
  final Color Function(int index)? colorForIndex;
  final String emptyLabel;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    var entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (maxItems != null && entries.length > maxItems!) {
      entries = entries.take(maxItems!).toList();
    }
    if (entries.isEmpty || entries.every((e) => e.value == 0)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          emptyLabel,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }
    final maxValue = entries.first.value.toDouble();
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _row(
              entries[i].key,
              entries[i].value,
              maxValue,
              colorForIndex?.call(i) ?? AppTheme.colorFor(i),
            ),
          ),
      ],
    );
  }

  Widget _row(String label, num value, double maxValue, Color color) {
    final ratio = maxValue == 0 ? 0.0 : (value / maxValue).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.9), color],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            valueFormatter?.call(value) ?? value.toInt().toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bar chart vertical (fl_chart) opcional, útil para pequenas séries.
class VerticalBarChart extends StatelessWidget {
  const VerticalBarChart({
    super.key,
    required this.data,
    this.height = 220,
    this.color,
  });

  final Map<String, num> data;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.values.every((v) => v == 0)) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('Sem dados',
              style: TextStyle(color: AppTheme.textSecondary)),
        ),
      );
    }
    final entries = data.entries.toList();
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxY * 1.15).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).clamp(1, double.infinity).toDouble(),
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppTheme.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval:
                    (maxY / 4).clamp(1, double.infinity).toDouble(),
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= entries.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      entries[i].key,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < entries.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: entries[i].value.toDouble(),
                    color: color ?? AppTheme.colorFor(i),
                    width: 22,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
