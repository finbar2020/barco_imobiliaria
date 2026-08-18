import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/analysis_data.dart';
import '../theme/app_theme.dart';
import '../widgets/charts/distribution_pie.dart';
import '../widgets/charts/horizontal_bar_chart.dart';
import '../widgets/labeled_progress.dart';
import '../widgets/metric_tile.dart';
import '../widgets/project_card.dart';
import '../widgets/section_card.dart';
import 'project_detail_screen.dart';

/// Tela geral com métricas consolidadas de todos os projetos.
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    final numberFmt = NumberFormat.decimalPattern('pt_BR');
    final projects = report.projects;

    final totalLoc = projects.fold<int>(0, (a, p) => a + p.stats.codeLines);
    final totalFiles =
        projects.fold<int>(0, (a, p) => a + p.stats.dartFiles);
    final totalFeatures =
        projects.fold<int>(0, (a, p) => a + p.architecture.featureCount);

    final flutterVersions = <String, int>{};
    for (final p in projects) {
      final v = p.toolchain.fvmFlutter.isEmpty
          ? 'não pinado'
          : p.toolchain.fvmFlutter;
      flutterVersions[v] = (flutterVersions[v] ?? 0) + 1;
    }
    final primaryFlutter = flutterVersions.entries.isEmpty
        ? '—'
        : (flutterVersions.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key;
    final withCoverage = projects.where((p) => p.coverage.available).toList();
    final avgCoverage = withCoverage.isEmpty
        ? 0.0
        : withCoverage.fold<double>(0, (a, p) => a + p.coverage.percent) /
            withCoverage.length;
    final totalDirectLibs =
        projects.fold<int>(0, (a, p) => a + p.dependencies.length);

    // Distribuições
    final archDist = _countBy(projects, (p) => p.architecture.pattern);
    final stateDist = _countBy(projects, (p) => p.stateManagement.primary);

    // LOC por projeto
    final locByProject = {
      for (final p in projects) p.folderName: p.stats.codeLines,
    };
    // Features por projeto
    final featuresByProject = {
      for (final p in projects) p.folderName: p.architecture.featureCount,
    };
    // Cobertura clean (%) por projeto
    final cleanCoverage = <String, num>{
      for (final p in projects
          .where((p) => p.architecture.featureCount > 0))
        p.folderName: p.architecture.cleanCoverage,
    };

    // Ranking de dependências por número de projetos que a usam
    final depPopularity = <String, int>{};
    for (final p in projects) {
      for (final d in p.dependencies) {
        depPopularity[d.name] = (depPopularity[d.name] ?? 0) + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
        titleSpacing: 24,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.schedule,
                    size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Gerado em ${DateFormat('dd/MM/yyyy HH:mm').format(report.generatedAt)}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final crossAxisCount = maxWidth >= 1400
              ? 4
              : maxWidth >= 1000
                  ? 3
                  : maxWidth >= 640
                      ? 2
                      : 1;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KpiRow(
                  metrics: [
                    _KpiData(
                      label: 'Projetos analisados',
                      value: projects.length.toString(),
                      icon: Icons.folder_special,
                    ),
                    _KpiData(
                      label: 'Linhas de código (lib)',
                      value: numberFmt.format(totalLoc),
                      icon: Icons.code,
                      color: AppTheme.accent,
                    ),
                    _KpiData(
                      label: 'Arquivos Dart',
                      value: numberFmt.format(totalFiles),
                      icon: Icons.description,
                      color: AppTheme.primaryLight,
                    ),
                    _KpiData(
                      label: 'Features mapeadas',
                      value: totalFeatures.toString(),
                      icon: Icons.dashboard_customize,
                      color: const Color(0xFFF59E0B),
                    ),
                    _KpiData(
                      label: 'Flutter (FVM)',
                      value: primaryFlutter,
                      icon: Icons.flutter_dash,
                      color: const Color(0xFF06B6D4),
                    ),
                    _KpiData(
                      label: withCoverage.isEmpty
                          ? 'Cobertura de testes'
                          : 'Cobertura média (${withCoverage.length} apps)',
                      value: withCoverage.isEmpty
                          ? '—'
                          : '${avgCoverage.toStringAsFixed(1)}%',
                      icon: Icons.verified,
                      color: withCoverage.isEmpty
                          ? AppTheme.textSecondary
                          : _coverageColor(avgCoverage),
                    ),
                    _KpiData(
                      label: 'Pacotes diretos',
                      value: totalDirectLibs.toString(),
                      icon: Icons.inventory_2,
                      color: AppTheme.primaryLight,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Branches deste trabalho',
                  subtitle:
                      'As três branches que criamos nos apps Lello — testes, '
                      'upgrade de libs (versões pinadas) e higiene de BLoC.',
                  icon: Icons.call_split,
                  child: _WorkBranchesOverview(report: report),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Cobertura de testes por projeto',
                  subtitle:
                      'Percentual de linhas cobertas (lcov.info). Projetos sem relatório aparecem como sem dados.',
                  icon: Icons.verified,
                  child: _CoverageOverview(projects: projects),
                ),
                const SizedBox(height: 20),
                _twoColumn(
                  maxWidth,
                  SectionCard(
                    title: 'Versão Flutter (FVM)',
                    subtitle:
                        'Versão pinada no .fvmrc — a que o time atualizou em cada app',
                    icon: Icons.flutter_dash,
                    child: flutterVersions.isEmpty
                        ? const Text(
                            'Nenhum .fvmrc encontrado.',
                            style: TextStyle(color: AppTheme.textSecondary),
                          )
                        : Column(
                            children: [
                              DistributionPie(
                                data: flutterVersions
                                    .map((k, v) => MapEntry(k, v)),
                              ),
                              const SizedBox(height: 12),
                              for (final p in projects)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          p.folderName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        p.toolchain.hasFvm
                                            ? p.toolchain.fvmFlutter
                                            : 'não pinado',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryLight,
                                          fontFeatures: [
                                            FontFeature.tabularFigures()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                  SectionCard(
                    title: 'Bibliotecas em uso',
                    subtitle:
                        'Versões pinadas de propósito — atualizar pode quebrar o app',
                    icon: Icons.lock,
                    child: _PinnedLibsOverview(projects: projects),
                  ),
                ),
                const SizedBox(height: 20),
                // Linha: arquitetura + state management (2 colunas em telas largas)
                _twoColumn(
                  maxWidth,
                  SectionCard(
                    title: 'Padrões arquiteturais',
                    subtitle:
                        'Como o código é organizado dentro do lib/ de cada projeto',
                    icon: Icons.account_tree,
                    child: DistributionPie(data: archDist),
                  ),
                  SectionCard(
                    title: 'Gerenciamento de estado',
                    subtitle:
                        'Abordagem primária detectada por scan do código (não apenas do pubspec)',
                    icon: Icons.hub,
                    child: DistributionPie(data: stateDist),
                  ),
                ),
                const SizedBox(height: 20),
                _twoColumn(
                  maxWidth,
                  SectionCard(
                    title: 'Linhas de código por projeto',
                    subtitle: 'Somente arquivos .dart em lib/',
                    icon: Icons.stacked_bar_chart,
                    child: HorizontalBarChart(
                      data: locByProject.map((k, v) => MapEntry(k, v)),
                      valueFormatter: (v) => numberFmt.format(v.toInt()),
                    ),
                  ),
                  SectionCard(
                    title: 'Features por projeto',
                    subtitle:
                        'Módulos encontrados em lib/feature/ ou equivalente',
                    icon: Icons.view_module,
                    child: HorizontalBarChart(data: featuresByProject),
                  ),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Higiene de blocs/cubits por projeto',
                  subtitle:
                      'Padrão do Síndico: abstract+impl, events/states em arquivos '
                      'próprios, sem print. 100 = alinhado à higienização.',
                  icon: Icons.cleaning_services_outlined,
                  child: _BlocHygieneOverview(
                    projects: projects,
                    useStandardization: false,
                  ),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Padronização canônica por projeto',
                  subtitle:
                      'Sufixos State/Event e Initial (não Idle). Equatable/const '
                      'não entram — não fazem parte do padrão higienizado.',
                  icon: Icons.rule_folder,
                  child: _BlocHygieneOverview(
                    projects: projects,
                    useStandardization: true,
                  ),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Cobertura Clean Architecture nas features',
                  subtitle:
                      '% de features com as três camadas presentes (data / domain / presentation)',
                  icon: Icons.layers,
                  child: cleanCoverage.isEmpty
                      ? const Text(
                          'Nenhum projeto com estrutura de features detectada.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        )
                      : Column(
                          children: [
                            for (final e in (cleanCoverage.entries.toList()
                                  ..sort((a, b) =>
                                      b.value.compareTo(a.value))))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: LabeledProgress(
                                  label: e.key,
                                  value: e.value,
                                  max: 100,
                                  color: _coverageColor(e.value),
                                  valueLabel: '${e.value.toInt()}%',
                                ),
                              ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Grafo de dependências internas (path:)',
                  subtitle:
                      'Pacotes locais que cada projeto consome — dá a estrutura do monorepo',
                  icon: Icons.share,
                  child: _MonorepoGraph(projects: projects),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Top pacotes por número de projetos que usam',
                  subtitle:
                      'Considera apenas dependencies (não dev). Path deps aparecem porque referenciam pacotes locais.',
                  icon: Icons.trending_up,
                  child: HorizontalBarChart(
                    data: depPopularity.map((k, v) => MapEntry(k, v)),
                    maxItems: 15,
                    valueFormatter: (v) => '${v.toInt()} projs',
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeader(
                  title: 'Projetos',
                  subtitle:
                      'Clique em um card para abrir a análise detalhada',
                  icon: Icons.folder_open,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 268,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final p = projects[index];
                    return ProjectCard(
                      project: p,
                      index: index,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProjectDetailScreen(project: p, index: index),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _twoColumn(double maxWidth, Widget left, Widget right) {
    if (maxWidth < 900) {
      return Column(
        children: [left, const SizedBox(height: 20), right],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }

  Color _coverageColor(num pct) {
    if (pct >= 80) return AppTheme.accent;
    if (pct >= 50) return AppTheme.warning;
    return AppTheme.danger;
  }

  Map<String, num> _countBy(
      List<ProjectAnalysis> list, String Function(ProjectAnalysis) key) {
    final map = <String, num>{};
    for (final p in list) {
      final k = key(p);
      map[k] = (map[k] ?? 0) + 1;
    }
    return map;
  }
}

// ---------------------------------------------------------------------------
// KPI row
// ---------------------------------------------------------------------------

class _KpiData {
  _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.metrics});

  final List<_KpiData> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1400
            ? 4
            : width >= 1000
                ? 3
                : width >= 720
                    ? 2
                    : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 108,
          ),
          itemBuilder: (context, i) {
            final m = metrics[i];
            return MetricTile(
              label: m.label,
              value: m.value,
              icon: m.icon,
              color: m.color,
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Section header (sem card, para blocos como "Projetos")
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryLight),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Grafo simples do monorepo (lista de dependências path por projeto)
// ---------------------------------------------------------------------------

class _MonorepoGraph extends StatelessWidget {
  const _MonorepoGraph({required this.projects});

  final List<ProjectAnalysis> projects;

  @override
  Widget build(BuildContext context) {
    final pathDeps = <ProjectAnalysis, List<Dependency>>{
      for (final p in projects)
        p: p.dependencies.where((d) => d.isPathDependency).toList(),
    };
    final anyDeps = pathDeps.values.any((l) => l.isNotEmpty);
    if (!anyDeps) {
      return const Text(
        'Nenhum projeto declara dependências locais (path:).',
        style: TextStyle(color: AppTheme.textSecondary),
      );
    }
    return Column(
      children: [
        for (final entry in pathDeps.entries)
          if (entry.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Text(
                      entry.key.folderName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final d in entry.value)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceAlt,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.divider),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.folder_special,
                                    size: 11,
                                    color: AppTheme.primaryLight),
                                const SizedBox(width: 4),
                                Text(
                                  d.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bloc hygiene overview (média por projeto)
// ---------------------------------------------------------------------------

class _BlocHygieneOverview extends StatelessWidget {
  const _BlocHygieneOverview({
    required this.projects,
    this.useStandardization = false,
  });

  final List<ProjectAnalysis> projects;
  final bool useStandardization;

  @override
  Widget build(BuildContext context) {
    final numberFmt = NumberFormat.decimalPattern('pt_BR');
    // Considera só projetos com blocs.
    final withBlocs =
        projects.where((p) => p.blocMetrics.hasBlocs).toList();
    if (withBlocs.isEmpty) {
      return const Text(
        'Nenhum projeto com blocs/cubits detectado.',
        style: TextStyle(color: AppTheme.textSecondary),
      );
    }

    // Média ponderada por unidades (bloc+cubit). Prefere totals.grade do JSON
    // quando disponível (higiene); padronização usa totals.standardization.grade.
    final entries = withBlocs.map((p) {
      final totals = p.blocMetrics.totals;
      final avg = useStandardization
          ? totals.standardization.grade
          : totals.grade;
      return _BlocHygieneEntry(project: p, average: avg);
    }).toList()
      ..sort((a, b) => a.average.compareTo(b.average));

    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: LabeledProgress(
              label:
                  '${e.project.folderName}  •  ${e.project.blocMetrics.totals.totalUnits} blocs  '
                  '•  ${numberFmt.format(e.project.blocMetrics.totals.loc)} LOC',
              value: e.average.toDouble(),
              max: 100,
              color: _gradeColor(e.average),
              valueLabel: '${e.average}',
            ),
          ),
      ],
    );
  }

  Color _gradeColor(int grade) {
    if (grade >= 85) return AppTheme.accent;
    if (grade >= 60) return AppTheme.warning;
    return AppTheme.danger;
  }
}

class _BlocHygieneEntry {
  _BlocHygieneEntry({required this.project, required this.average});
  final ProjectAnalysis project;
  final int average;
}

// ---------------------------------------------------------------------------
// Branches deste trabalho
// ---------------------------------------------------------------------------

class _WorkBranchesOverview extends StatelessWidget {
  const _WorkBranchesOverview({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    if (report.workBranches.isEmpty) {
      return const Text(
        'Nenhuma branch de trabalho registrada no relatório.',
        style: TextStyle(color: AppTheme.textSecondary),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < report.workBranches.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _WorkBranchCard(branch: report.workBranches[i], index: i),
        ],
      ],
    );
  }
}

class _WorkBranchCard extends StatelessWidget {
  const _WorkBranchCard({required this.branch, required this.index});

  final WorkBranchSummary branch;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colorFor(index);
    final currentLabel = branch.currentOn.isEmpty
        ? 'nenhum app nesta branch agora'
        : 'ativa em: ${branch.currentOn.join(', ')}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.call_split, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  branch.name,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Text(
                '${branch.presentIn.length} apps',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            branch.purpose,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentLabel,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          if (branch.presentIn.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final app in branch.presentIn)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: branch.currentOn.contains(app)
                            ? color
                            : AppTheme.divider,
                      ),
                    ),
                    child: Text(
                      app.replaceFirst('app-lello-', ''),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: branch.currentOn.contains(app)
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: branch.currentOn.contains(app)
                            ? color
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cobertura de testes por projeto
// ---------------------------------------------------------------------------

class _CoverageOverview extends StatelessWidget {
  const _CoverageOverview({required this.projects});

  final List<ProjectAnalysis> projects;

  @override
  Widget build(BuildContext context) {
    final numberFmt = NumberFormat.decimalPattern('pt_BR');
    final sorted = List<ProjectAnalysis>.from(projects)
      ..sort((a, b) {
        if (a.coverage.available != b.coverage.available) {
          return a.coverage.available ? -1 : 1;
        }
        return b.coverage.percent.compareTo(a.coverage.percent);
      });

    return Column(
      children: [
        for (final p in sorted)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: p.coverage.available
                ? LabeledProgress(
                    label:
                        '${p.folderName}  •  ${numberFmt.format(p.coverage.hit)}/${numberFmt.format(p.coverage.found)} linhas'
                        '${p.coverage.goldenImages > 0 ? '  •  ${p.coverage.goldenImages} goldens' : ''}'
                        '${p.coverage.testFiles > 0 ? '  •  ${p.coverage.testFiles} testes' : ''}',
                    value: p.coverage.percent,
                    max: 100,
                    color: _color(p.coverage.percent),
                    valueLabel: '${p.coverage.percent.toStringAsFixed(1)}%',
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${p.folderName}  •  ${p.coverage.testFiles} arquivos de teste'
                          '${p.coverage.goldenImages > 0 ? '  •  ${p.coverage.goldenImages} goldens' : ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(
                        'sem lcov',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
      ],
    );
  }

  Color _color(num pct) {
    if (pct >= 80) return AppTheme.accent;
    if (pct >= 50) return AppTheme.warning;
    return AppTheme.danger;
  }
}

// ---------------------------------------------------------------------------
// Bibliotecas pinadas por projeto
// ---------------------------------------------------------------------------

class _PinnedLibsOverview extends StatelessWidget {
  const _PinnedLibsOverview({required this.projects});

  final List<ProjectAnalysis> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final p in projects)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.folderName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${p.dependencies.length} diretas'
                  '${p.pathDependencies.isNotEmpty ? '  •  ${p.pathDependencies.length} path' : ''}'
                  '${p.devDependencies.isNotEmpty ? '  •  ${p.devDependencies.length} dev' : ''}',
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
    );
  }
}
