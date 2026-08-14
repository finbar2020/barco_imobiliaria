import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/analysis_data.dart';

/// Carrega o relatório de análise a partir do bundle de assets.
class AnalysisLoader {
  static const String _assetPath = 'assets/analysis.json';

  Future<AnalysisReport> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AnalysisReport.fromJson(json);
  }
}
