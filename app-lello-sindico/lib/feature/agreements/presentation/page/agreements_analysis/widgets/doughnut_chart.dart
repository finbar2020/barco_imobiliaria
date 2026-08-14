import 'dart:math' as math;

import 'package:essentials/essentials.dart';
import 'package:fl_chart/fl_chart.dart' as chart;
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';

class DoughnutChart extends StatefulWidget {
  final List<AgreementsAnalysisElement> data;
  const DoughnutChart({Key? key, required this.data}) : super(key: key);

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  int touchedIndex = -1;
  List<Color> colors = List.generate(
      20,
      (index) => Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0));
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: SizedBox(
        height: 250.0,
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: chart.PieChart(
                    chart.PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      sections: showingSections(widget.data, theme),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimens.spacing),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...List.generate(
                      widget.data.length,
                      (index) => Column(
                            children: [
                              Indicator(
                                color: colors[index],
                                text: '${widget.data[index].legend}',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: Dimens.spacingSmall,
                              ),
                            ],
                          )),
                ],
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<AgreementsAnalysisElement> data, ThemeData theme) {
    return List.generate(data.length, (i) {
      final fontSize = 12.0;
      final radius = 10.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final color = colors[i];
      final title = "${data[i].percentage.toInt().toString()}%";
      return PieChartSectionData(
        color: color,
        titlePositionPercentageOffset: -1.5,
        value: data[i].percentage,
        title: title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 12,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.0,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Container(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
