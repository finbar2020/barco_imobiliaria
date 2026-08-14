import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';

class AgreementsAnalysisElement {
  String description;
  double value;
  double percentage;
  String legend;

  AgreementsAnalysisElement({
    required this.description,
    required this.value,
    required this.percentage,
    this.legend = "",
  }) {
    legend = description;
  }

  Color? getColor(ThemeData theme, String? type) {
    switch (type) {
      case AgreementAnalysisType.installmentQtd:
        return LelloTheme.palleteOf(theme).accent();
      case AgreementAnalysisType.dueDate:
        return LelloTheme.palleteOf(theme).success();
      default:
        return null;
    }
  }
}
