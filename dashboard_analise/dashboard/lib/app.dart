import 'package:flutter/material.dart';

import 'models/analysis_data.dart';
import 'screens/overview_screen.dart';
import 'services/analysis_loader.dart';
import 'theme/app_theme.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projetos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const _AnalysisBootstrap(),
    );
  }
}

/// Widget que carrega o JSON de análise e entrega o [AnalysisReport] para a
/// tela inicial. Estado bem simples: loading, erro ou pronto.
class _AnalysisBootstrap extends StatefulWidget {
  const _AnalysisBootstrap();

  @override
  State<_AnalysisBootstrap> createState() => _AnalysisBootstrapState();
}

class _AnalysisBootstrapState extends State<_AnalysisBootstrap> {
  final _loader = AnalysisLoader();
  late Future<AnalysisReport> _future;

  @override
  void initState() {
    super.initState();
    _future = _loader.load();
  }

  void _reload() {
    setState(() {
      _future = _loader.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnalysisReport>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppTheme.danger, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Falha ao carregar o relatório.',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Rode `dart run tool/analyze_projects.dart` para (re)gerar '
                      'o arquivo assets/analysis.json.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return OverviewScreen(report: snapshot.data!);
      },
    );
  }
}
