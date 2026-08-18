import 'package:flutter/material.dart';

import '../models/analysis_data.dart';
import '../theme/app_theme.dart';

/// Card resumido do projeto usado na grade da tela geral.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.index,
  });

  final ProjectAnalysis project;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.colorFor(index);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _initials(project.folderName),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.folderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${project.name} • v${project.version}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _typePill(project.type),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                project.description.isEmpty
                    ? 'Sem descrição no pubspec.yaml.'
                    : project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _tag(project.architecture.pattern, Icons.account_tree),
                  _tag(project.stateManagement.primary, Icons.hub),
                  if (project.blocMetrics.hasBlocs) ...[
                    _gradeTag(
                      'Hig. ${project.blocMetrics.totals.grade}',
                      project.blocMetrics.totals.grade,
                    ),
                    _gradeTag(
                      'Padr. ${project.blocMetrics.totals.standardization.grade}',
                      project.blocMetrics.totals.standardization.grade,
                    ),
                  ],
                  if (project.git.hasCurrent)
                    _tag(project.git.currentBranch, Icons.call_split),
                ],
              ),
              const Spacer(),
              const Divider(height: 24),
              Row(
                children: [
                  _stat(
                    'Features',
                    project.architecture.featureCount.toString(),
                  ),
                  const SizedBox(width: 12),
                  _stat(
                    'Cobertura',
                    project.coverage.available
                        ? '${project.coverage.percent.toStringAsFixed(1)}%'
                        : '—',
                    color: project.coverage.available
                        ? _coverageColor(project.coverage.percent)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  _stat(
                    'Flutter',
                    project.toolchain.hasFvm
                        ? project.toolchain.fvmFlutter
                        : '—',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typePill(String type) {
    final label = switch (type) {
      'app' => 'APP',
      'package' => 'PACKAGE',
      _ => 'LIB',
    };
    final color = switch (type) {
      'app' => AppTheme.accent,
      'package' => AppTheme.primary,
      _ => AppTheme.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _tag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradeTag(String label, int grade) {
    final color = grade >= 85
        ? AppTheme.accent
        : grade >= 60
            ? AppTheme.warning
            : AppTheme.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
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

  String _initials(String folder) {
    final clean = folder.replaceAll('app-lello-', '');
    final parts = clean.split(RegExp(r'[-_ ]')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      return s.substring(0, s.length.clamp(0, 2)).toUpperCase();
    }
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }
}
