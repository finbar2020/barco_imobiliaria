import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Pie chart de distribuição com legenda ao lado.
class DistributionPie extends StatefulWidget {
  const DistributionPie({
    super.key,
    required this.data,
    this.height = 220,
    this.emptyLabel = 'Sem dados',
  });

  /// Mapa de rótulo → contagem.
  final Map<String, num> data;
  final double height;
  final String emptyLabel;

  @override
  State<DistributionPie> createState() => _DistributionPieState();
}

class _DistributionPieState extends State<DistributionPie> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final entries = widget.data.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (entries.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            widget.emptyLabel,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    final total = entries.fold<num>(0, (a, b) => a + b.value);

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 44,
                startDegreeOffset: -90,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = null;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: [
                  for (var i = 0; i < entries.length; i++)
                    _section(entries[i], total, i, i == _touchedIndex),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < entries.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppTheme.colorFor(i),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entries[i].key,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${entries[i].value.toInt()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(
    MapEntry<String, num> e,
    num total,
    int index,
    bool touched,
  ) {
    final pct = total == 0 ? 0 : (e.value * 100 / total);
    final color = AppTheme.colorFor(index);
    return PieChartSectionData(
      value: e.value.toDouble(),
      color: color,
      radius: touched ? 62 : 54,
      title: pct >= 6 ? '${pct.toStringAsFixed(0)}%' : '',
      titleStyle: const TextStyle(
        fontSize: 11,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
