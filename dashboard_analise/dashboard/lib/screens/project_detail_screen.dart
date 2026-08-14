import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/analysis_data.dart';
import '../theme/app_theme.dart';
import '../widgets/charts/horizontal_bar_chart.dart';
import '../widgets/labeled_progress.dart';
import '../widgets/metric_tile.dart';
import '../widgets/section_card.dart';

/// Tela de análise detalhada de um projeto específico.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.index,
  });

  final ProjectAnalysis project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final numberFmt = NumberFormat.decimalPattern('pt_BR');
    final accent = AppTheme.colorFor(index);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.folder_open, size: 16, color: accent),
            ),
            const SizedBox(width: 12),
            Text(project.folderName),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(project: project, accent: accent),
                const SizedBox(height: 20),
                _KpiGrid(project: project, numberFmt: numberFmt),
                const SizedBox(height: 20),
                _twoColumn(
                  maxWidth,
                  _ArchitectureCard(project: project),
                  _StateManagementCard(project: project),
                ),
                const SizedBox(height: 20),
                if (project.features.isNotEmpty) ...[
                  _FeaturesCard(project: project),
                  const SizedBox(height: 20),
                ],
                if (project.blocMetrics.hasBlocs) ...[
                  _BlocMetricsCard(project: project),
                  const SizedBox(height: 20),
                ],
                _twoColumn(
                  maxWidth,
                  _DependenciesCard(project: project),
                  _TopFoldersCard(project: project),
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
    if (maxWidth < 1000) {
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
}

// ---------------------------------------------------------------------------
// Header do projeto
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.project, required this.accent});

  final ProjectAnalysis project;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.apps, size: 28, color: accent),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: accent.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          project.type.toUpperCase(),
                          style: TextStyle(
                            color: accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (project.version.isNotEmpty)
                        Text(
                          'v${project.version}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description.isEmpty
                        ? 'Sem descrição no pubspec.yaml.'
                        : project.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final p in project.platforms)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceAlt,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Text(
                            p,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    project.path,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// KPIs do projeto
// ---------------------------------------------------------------------------

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.project, required this.numberFmt});

  final ProjectAnalysis project;
  final NumberFormat numberFmt;

  @override
  Widget build(BuildContext context) {
    final s = project.stats;
    final tiles = [
      MetricTile(
        label: 'Arquivos Dart (lib)',
        value: numberFmt.format(s.dartFiles),
        icon: Icons.description,
      ),
      MetricTile(
        label: 'Linhas de código',
        value: numberFmt.format(s.codeLines),
        icon: Icons.code,
        color: AppTheme.accent,
      ),
      MetricTile(
        label: 'Arquivos gerados',
        value: numberFmt.format(s.generatedFiles),
        icon: Icons.auto_awesome,
        color: AppTheme.primaryLight,
        suffix: '.g/.freezed/etc',
      ),
      MetricTile(
        label: 'Features',
        value: project.architecture.featureCount.toString(),
        icon: Icons.view_module,
        color: const Color(0xFFF59E0B),
      ),
      MetricTile(
        label: 'Cobertura Clean',
        value: '${project.architecture.cleanCoverage}%',
        icon: Icons.layers,
        color: _coverageColor(project.architecture.cleanCoverage),
      ),
      MetricTile(
        label: 'Arquivos de teste',
        value: numberFmt.format(s.testFiles),
        icon: Icons.science,
        color: s.testFiles == 0 ? AppTheme.danger : AppTheme.accent,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1200
            ? 6
            : w >= 900
                ? 3
                : w >= 600
                    ? 2
                    : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 108,
          ),
          itemBuilder: (context, i) => tiles[i],
        );
      },
    );
  }

  Color _coverageColor(num pct) {
    if (pct >= 80) return AppTheme.accent;
    if (pct >= 50) return AppTheme.warning;
    return AppTheme.danger;
  }
}

// ---------------------------------------------------------------------------
// Card: Arquitetura
// ---------------------------------------------------------------------------

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final arch = project.architecture;
    return SectionCard(
      title: 'Arquitetura',
      subtitle: 'Padrão detectado + composição das features',
      icon: Icons.account_tree,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kv('Padrão', arch.pattern),
          _kv('Total de features', arch.featureCount.toString()),
          _kv('Features com data + domain + presentation',
              '${arch.cleanFeatures} / ${arch.featureCount}'),
          const SizedBox(height: 12),
          LabeledProgress(
            label: 'Cobertura Clean Architecture nas features',
            value: arch.cleanCoverage,
            max: 100,
            color: _coverageColor(arch.cleanCoverage),
            valueLabel: '${arch.cleanCoverage}%',
          ),
          const SizedBox(height: 20),
          const Text(
            'Uso das camadas de "presentation" (agregado sobre as features)',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          HorizontalBarChart(
            data: _canonicalPresentation(arch.presentationSubUsage)
                .map((k, v) => MapEntry(k, v)),
            valueFormatter: (v) => '${v.toInt()} feat.',
            emptyLabel:
                'Sem subpastas em presentation ou projeto sem features.',
          ),
        ],
      ),
    );
  }

  /// Filtra o mapa para manter apenas subpastas "canônicas" (bloc, cubit,
  /// controllers, page, pages, widget, widgets, provider, view, views).
  /// Isso evita ruído de features que colocam páginas ad-hoc dentro de
  /// presentation com nomes específicos.
  Map<String, int> _canonicalPresentation(Map<String, int> raw) {
    const canonical = {
      'bloc',
      'cubit',
      'blocs',
      'cubits',
      'controllers',
      'controller',
      'provider',
      'providers',
      'notifier',
      'notifiers',
      'store',
      'stores',
      'viewmodel',
      'viewmodels',
      'page',
      'pages',
      'view',
      'views',
      'screen',
      'screens',
      'widget',
      'widgets',
      'components',
      'ui',
    };
    final filtered = <String, int>{};
    raw.forEach((k, v) {
      if (canonical.contains(k)) filtered[k] = v;
    });
    return filtered.isEmpty ? raw : filtered;
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              k,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _coverageColor(num pct) {
    if (pct >= 80) return AppTheme.accent;
    if (pct >= 50) return AppTheme.warning;
    return AppTheme.danger;
  }
}

// ---------------------------------------------------------------------------
// Card: State Management
// ---------------------------------------------------------------------------

class _StateManagementCard extends StatelessWidget {
  const _StateManagementCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final sm = project.stateManagement;
    final labels = <String, String>{
      'bloc': 'Blocs (extends Bloc<>)',
      'cubit': 'Cubits',
      'changeNotifier': 'ChangeNotifier',
      'providerConsumer': 'Provider.of / Consumer / context.watch',
      'consumerWidget': 'ConsumerWidget (Riverpod)',
      'getxController': 'GetxController',
      'mobxStore': 'Stores MobX',
      'streamBuilder': 'StreamBuilder',
      'setState': 'setState()',
    };
    final counts = <String, num>{};
    for (final e in labels.entries) {
      final v = sm.counts[e.key] ?? 0;
      if (v > 0) counts[e.value] = v;
    }

    // Agrupa versões resolvidas por família para o header.
    final blocFamily = sm.resolvedForFamily(
        ['bloc', 'flutter_bloc', 'hydrated_bloc', 'replay_bloc']);
    final providerFamily = sm.resolvedForFamily(['provider']);
    final riverpodFamily = sm.resolvedForFamily(
        ['riverpod', 'flutter_riverpod', 'hooks_riverpod']);
    final getxFamily = sm.resolvedForFamily(['get']);
    final mobxFamily = sm.resolvedForFamily(['mobx', 'flutter_mobx']);
    final reduxFamily = sm.resolvedForFamily(['redux', 'flutter_redux']);
    final diFamily = sm.resolvedForFamily(['get_it', 'injectable']);

    final families = <String, List<ResolvedPackage>>{
      'BLoC': blocFamily,
      'Provider': providerFamily,
      'Riverpod': riverpodFamily,
      'GetX': getxFamily,
      'MobX': mobxFamily,
      'Redux': reduxFamily,
      'Injeção de dependência': diFamily,
    }..removeWhere((_, v) => v.isEmpty);

    return SectionCard(
      title: 'Gerenciamento de estado',
      subtitle:
          'Padrão primário por scan de código + versões resolvidas via pubspec.lock',
      icon: Icons.hub,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        size: 14, color: AppTheme.primaryLight),
                    const SizedBox(width: 6),
                    Text(
                      'Primário: ${sm.primary}',
                      style: const TextStyle(
                        color: AppTheme.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (blocFamily.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _versionBadge(blocFamily),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (families.isNotEmpty) ...[
            const Text(
              'Versões resolvidas (pubspec.lock)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in families.entries) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final pkg in e.value) _packageChip(pkg),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ] else ...[
            const Text(
              'Nenhum pacote conhecido de gerenciamento de estado encontrado '
              'no pubspec.lock deste projeto.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
          ],
          const Text(
            'Ocorrências no código',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          HorizontalBarChart(
            data: counts,
            valueFormatter: (v) => v.toInt().toString(),
            emptyLabel:
                'Nenhum padrão conhecido de gerenciamento de estado foi detectado.',
          ),
        ],
      ),
    );
  }

  /// Badge compacto usado ao lado do "Primário: BLoC" mostrando a versão do
  /// pacote principal da família.
  Widget _versionBadge(List<ResolvedPackage> family) {
    // Prefere flutter_bloc > bloc > primeiro da lista.
    final ordered = List<ResolvedPackage>.from(family);
    ordered.sort((a, b) {
      int weight(String n) {
        switch (n) {
          case 'flutter_bloc':
          case 'flutter_riverpod':
          case 'flutter_mobx':
          case 'flutter_redux':
            return 0;
          default:
            return 1;
        }
      }

      return weight(a.name).compareTo(weight(b.name));
    });
    final head = ordered.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        '${head.name} v${head.version}',
        style: const TextStyle(
          color: AppTheme.accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _packageChip(ResolvedPackage pkg) {
    final originColor = pkg.isDirect ? AppTheme.primaryLight : AppTheme.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pkg.name,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'v${pkg.version}',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (pkg.originLabel.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: originColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border:
                    Border.all(color: originColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                pkg.originLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: originColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card: Features
// ---------------------------------------------------------------------------

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final features = project.features;
    return SectionCard(
      title: 'Features',
      subtitle:
          'Uma linha por feature, mostrando presença de cada camada e tamanho',
      icon: Icons.dashboard_customize,
      trailing: Text(
        '${features.length} features',
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: const [
                SizedBox(width: 200, child: Text('Feature', style: _hdr)),
                SizedBox(width: 220, child: Text('Camadas', style: _hdr)),
                Expanded(child: Text('Arquivos', style: _hdr)),
                SizedBox(width: 100, child: Text('Linhas', style: _hdr)),
              ],
            ),
          ),
          const Divider(height: 8),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      f.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Row(
                      children: [
                        _layerChip('data', f.hasData),
                        const SizedBox(width: 4),
                        _layerChip('domain', f.hasDomain),
                        const SizedBox(width: 4),
                        _layerChip('presentation', f.hasPresentation),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _miniBar(f.fileCount, _maxFileCount(features)),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      NumberFormat.decimalPattern('pt_BR')
                          .format(f.lineCount),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  int _maxFileCount(List<FeatureInfo> features) {
    return features
        .map((f) => f.fileCount)
        .fold<int>(0, (a, b) => a > b ? a : b);
  }

  Widget _miniBar(int value, int max) {
    final ratio = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }

  Widget _layerChip(String label, bool has) {
    final color = has ? AppTheme.accent : AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: has
            ? AppTheme.accent.withValues(alpha: 0.12)
            : AppTheme.surfaceAlt,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            has ? Icons.check_circle : Icons.remove_circle_outline,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}

const _hdr = TextStyle(
  color: AppTheme.textSecondary,
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.4,
);

// ---------------------------------------------------------------------------
// Card: Dependências categorizadas
// ---------------------------------------------------------------------------

class _DependenciesCard extends StatelessWidget {
  const _DependenciesCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final categories = project.dependencyCategories;
    final pathDeps = project.pathDependencies.toList();
    return SectionCard(
      title: 'Dependências',
      subtitle: '${project.dependencies.length} pacotes diretos '
          '(${project.devDependencies.length} dev)',
      icon: Icons.inventory_2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pathDeps.isNotEmpty) ...[
            const Text(
              'Dependências locais (monorepo)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final d in pathDeps)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color:
                              AppTheme.primary.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link,
                            size: 11, color: AppTheme.primaryLight),
                        const SizedBox(width: 4),
                        Text(
                          d.name,
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.primaryLight),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (categories.isEmpty)
            const Text(
              'Sem categorização adicional. Este projeto pode ser um '
              'app do monorepo que reutiliza tudo via path dep.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          for (final entry in categories.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final pkg in entry.value)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceAlt,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Text(
                            pkg,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card: Top folders de lib/
// ---------------------------------------------------------------------------

class _TopFoldersCard extends StatelessWidget {
  const _TopFoldersCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final data = project.architecture.topLevelFolders
        .map((k, v) => MapEntry(k, v as num));
    return SectionCard(
      title: 'Distribuição de arquivos em lib/',
      subtitle: 'Quantos arquivos .dart existem dentro de cada pasta raiz',
      icon: Icons.folder_copy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalBarChart(
            data: data,
            valueFormatter: (v) => '${v.toInt()} arq.',
            maxItems: 10,
          ),
          if (project.architecture.topLevelFiles.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Arquivos .dart na raiz de lib/',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in project.architecture.topLevelFiles)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Text(
                      f,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textPrimary,
                        fontFamily: 'monospace',
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
// Card: Bloc/Cubit hygiene metrics
// ---------------------------------------------------------------------------

class _BlocMetricsCard extends StatelessWidget {
  const _BlocMetricsCard({required this.project});

  final ProjectAnalysis project;

  @override
  Widget build(BuildContext context) {
    final metrics = project.blocMetrics;
    final totals = metrics.totals;
    final numberFmt = NumberFormat.decimalPattern('pt_BR');

    // Ordenação: features com mais fricção primeiro (grade asc), depois maior
    final features = List.of(metrics.perFeature)
      ..sort((a, b) {
        final byGrade = a.grade.compareTo(b.grade);
        if (byGrade != 0) return byGrade;
        return b.totalUnits.compareTo(a.totalUnits);
      });

    return SectionCard(
      title: 'Higiene e padronização de blocs/cubits',
      subtitle:
          'Detectado pela varredura de presentation/**/bloc/ — o quanto cada '
          'feature aderiu ao padrão (Equatable, events/states separados, '
          'sem print, migração bloc 9 completa, sem abstract+impl)',
      icon: Icons.rule_folder,
      trailing: Text(
        '${totals.totalUnits} unidades',
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BlocKpis(totals: totals, numberFmt: numberFmt),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Notas agregadas',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _GradePill(label: 'Higiene', grade: totals.grade),
              _GradePill(
                label: 'Padr.',
                grade: totals.standardization.grade,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Higiene = fricção técnica · Padronização = aderência ao padrão '
            'canônico (sufixos State/Event, InitialState, const; form single-class ok)',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _StdKpis(std: totals.standardization),
          const SizedBox(height: 20),
          const Text(
            'Por feature',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _BlocFeaturesTable(features: features, numberFmt: numberFmt),
        ],
      ),
    );
  }
}

/// Pequeno "pill" colorido com nota 0-100 (Higiene ou Padronização).
class _GradePill extends StatelessWidget {
  const _GradePill({required this.label, required this.grade});

  final String label;
  final int grade;

  @override
  Widget build(BuildContext context) {
    final color = grade >= 85
        ? AppTheme.accent
        : grade >= 60
            ? AppTheme.warning
            : AppTheme.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label $grade/100',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// Grade de KPIs específicos da padronização (desvios do padrão).
class _StdKpis extends StatelessWidget {
  const _StdKpis({required this.std});

  final StandardizationMetrics std;

  @override
  Widget build(BuildContext context) {
    Color okOrWarn(int v) => v == 0 ? AppTheme.accent : AppTheme.warning;

    final tiles = <Widget>[
      MetricTile(
        label: 'States sem sufixo',
        value: std.stateNoSuffix.toString(),
        icon: Icons.text_fields,
        color: okOrWarn(std.stateNoSuffix),
        suffix: 'esperado 0',
      ),
      MetricTile(
        label: 'Events sem sufixo',
        value: std.eventNoSuffix.toString(),
        icon: Icons.text_fields,
        color: okOrWarn(std.eventNoSuffix),
        suffix: 'esperado 0',
      ),
      MetricTile(
        label: 'Estado "Idle"',
        value: std.idleInitialStates.toString(),
        icon: Icons.bedtime,
        color: okOrWarn(std.idleInitialStates),
        suffix: 'usar Initial',
      ),
      MetricTile(
        label: 'Estado único (form)',
        value: std.singleClassStates.toString(),
        icon: Icons.crop_square,
        color: okOrWarn(std.singleClassStates),
        suffix: 'ok em forms',
      ),
      MetricTile(
        label: 'Erro via Outcome enum',
        value: std.outcomeEnumStates.toString(),
        icon: Icons.error_outline,
        color: okOrWarn(std.outcomeEnumStates),
        suffix: 'usar Status',
      ),
      MetricTile(
        label: 'Base sem const',
        value: std.nonConstBaseStates.toString(),
        icon: Icons.lock_open,
        color: okOrWarn(std.nonConstBaseStates),
        suffix: 'usar const',
      ),
      MetricTile(
        label: 'ErrorState dedicado',
        value: std.dedicatedErrorStates.toString(),
        icon: Icons.verified,
        color: AppTheme.primaryLight,
        suffix: 'padrão ok',
      ),
      MetricTile(
        label: 'Subclasses State/Event',
        value: '${std.stateClasses}/${std.eventClasses}',
        icon: Icons.account_tree,
        color: AppTheme.textSecondary,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1200
            ? 4
            : w >= 900
                ? 3
                : w >= 600
                    ? 2
                    : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 108,
          ),
          itemBuilder: (context, i) => tiles[i],
        );
      },
    );
  }
}

class _BlocKpis extends StatelessWidget {
  const _BlocKpis({required this.totals, required this.numberFmt});

  final BlocTotals totals;
  final NumberFormat numberFmt;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      MetricTile(
        label: 'Blocs + Cubits',
        value: numberFmt.format(totals.totalUnits),
        icon: Icons.hub,
        color: AppTheme.primaryLight,
        suffix: totals.cubits > 0
            ? '${totals.blocs} bloc / ${totals.cubits} cubit'
            : null,
      ),
      MetricTile(
        label: 'LOC nos blocs',
        value: numberFmt.format(totals.loc),
        icon: Icons.code,
        color: AppTheme.accent,
      ),
      MetricTile(
        label: 'Pares abstract+impl',
        value: totals.absImplPairs.toString(),
        icon: Icons.file_copy,
        color: totals.absImplPairs == 0 ? AppTheme.accent : AppTheme.warning,
      ),
      MetricTile(
        label: 'Events inline',
        value: totals.inlineEvents.toString(),
        icon: Icons.subject,
        color:
            totals.inlineEvents == 0 ? AppTheme.accent : AppTheme.warning,
      ),
      MetricTile(
        label: 'States inline',
        value: totals.inlineStates.toString(),
        icon: Icons.list_alt,
        color:
            totals.inlineStates == 0 ? AppTheme.accent : AppTheme.warning,
      ),
      MetricTile(
        label: 'print() em bloc',
        value: totals.filesWithPrint.toString(),
        icon: Icons.terminal,
        color:
            totals.filesWithPrint == 0 ? AppTheme.accent : AppTheme.warning,
      ),
      MetricTile(
        label: 'mapEventToState (bloc 7)',
        value: totals.filesWithMapEventToState.toString(),
        icon: Icons.update,
        color: totals.filesWithMapEventToState == 0
            ? AppTheme.accent
            : AppTheme.danger,
        suffix: totals.filesWithMapEventToState == 0
            ? 'bloc 9 ok'
            : 'pendente',
      ),
      MetricTile(
        label: 'Sem Equatable',
        value: totals.filesNoEquatable.toString(),
        icon: Icons.compare_arrows,
        color: AppTheme.textSecondary,
        suffix: 'heurística',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1200
            ? 4
            : w >= 900
                ? 3
                : w >= 600
                    ? 2
                    : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 108,
          ),
          itemBuilder: (context, i) => tiles[i],
        );
      },
    );
  }
}

class _BlocFeaturesTable extends StatelessWidget {
  const _BlocFeaturesTable({required this.features, required this.numberFmt});

  final List<FeatureBlocMetrics> features;
  final NumberFormat numberFmt;

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const Text(
        'Nenhuma feature com blocos detectada.',
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: const [
              SizedBox(width: 200, child: Text('Feature', style: _hdr)),
              SizedBox(width: 70, child: Text('Blocs', style: _hdr)),
              SizedBox(width: 60, child: Text('Cubits', style: _hdr)),
              SizedBox(width: 80, child: Text('LOC', style: _hdr)),
              SizedBox(width: 80, child: Text('Abs+Impl', style: _hdr)),
              SizedBox(width: 70, child: Text('Ev inl.', style: _hdr)),
              SizedBox(width: 70, child: Text('St inl.', style: _hdr)),
              SizedBox(width: 60, child: Text('print', style: _hdr)),
              SizedBox(width: 80, child: Text('mapEvt', style: _hdr)),
              SizedBox(width: 70, child: Text('Padr.', style: _hdr)),
              Expanded(child: Text('Higiene', style: _hdr)),
            ],
          ),
        ),
        const Divider(height: 8),
        for (final f in features)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(
                        f.isClean
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        size: 13,
                        color: f.isClean
                            ? AppTheme.accent
                            : AppTheme.warning,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          f.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 70, child: _numCell(f.blocs)),
                SizedBox(width: 60, child: _numCell(f.cubits)),
                SizedBox(
                    width: 80,
                    child: _numCell(f.loc, fmt: numberFmt)),
                SizedBox(
                  width: 80,
                  child: _numCell(
                    f.absImplPairs,
                    highlight: f.absImplPairs > 0
                        ? AppTheme.warning
                        : null,
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: _numCell(
                    f.inlineEvents,
                    highlight: f.inlineEvents > 0
                        ? AppTheme.warning
                        : null,
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: _numCell(
                    f.inlineStates,
                    highlight: f.inlineStates > 0
                        ? AppTheme.warning
                        : null,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: _numCell(
                    f.filesWithPrint,
                    highlight: f.filesWithPrint > 0
                        ? AppTheme.warning
                        : null,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: _numCell(
                    f.filesWithMapEventToState,
                    highlight: f.filesWithMapEventToState > 0
                        ? AppTheme.danger
                        : null,
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: _StdGradeCell(grade: f.standardization.grade),
                ),
                Expanded(
                  child: _GradeBar(grade: f.grade),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _numCell(int value, {Color? highlight, NumberFormat? fmt}) {
    return Text(
      fmt != null ? fmt.format(value) : value.toString(),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: highlight ?? AppTheme.textSecondary,
        fontSize: 12,
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: highlight != null ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

/// Célula compacta com a nota de padronização por feature (0-100).
class _StdGradeCell extends StatelessWidget {
  const _StdGradeCell({required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context) {
    final color = grade >= 85
        ? AppTheme.accent
        : grade >= 60
            ? AppTheme.warning
            : AppTheme.danger;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          '$grade',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

class _GradeBar extends StatelessWidget {
  const _GradeBar({required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(grade);
    final ratio = (grade / 100).clamp(0.0, 1.0);
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 44,
          child: Text(
            '$grade',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }

  Color _colorFor(int grade) {
    if (grade >= 85) return AppTheme.accent;
    if (grade >= 60) return AppTheme.warning;
    return AppTheme.danger;
  }
}
