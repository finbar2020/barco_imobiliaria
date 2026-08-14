import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

// Spacing tokens — mirrors the values from MaintenanceManagementPage.
const double _kPadding = 16.0;
const double _kSpacing = 8.0;

/// A 2-column info grid for condominium summary data.
///
/// Items whose value is `null`, empty, or the string `"null"` are
/// automatically hidden. The remaining items are laid out left-to-right
/// in pairs, with a [Divider] between each row except the last.
///
/// Usage:
/// ```dart
/// CondominiumInfoGrid(
///   items: [
///     (label1, value1),
///     (label2, value2),
///   ],
/// )
/// ```
class CondominiumInfoGrid extends StatelessWidget {
  const CondominiumInfoGrid({super.key, required this.items});

  /// Each pair is (label, value). Null / empty values are hidden.
  final List<(String label, Object? value)> items;

  static bool _isBlank(Object? v) {
    if (v == null) return true;
    final s = v.toString();
    return s.isEmpty || s == 'null';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = items.where((e) => !_isBlank(e.$2)).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (int i = 0; i < visible.length; i += 2) ...[
          Row(
            children: [
              Expanded(
                child: _CondominiumInfoCell(
                  theme: theme,
                  label: visible[i].$1,
                  value: visible[i].$2!,
                  showDivider: i + 2 < visible.length,
                ),
              ),
              const SizedBox(width: _kPadding),
              Expanded(
                child: i + 1 < visible.length
                    ? _CondominiumInfoCell(
                        theme: theme,
                        label: visible[i + 1].$1,
                        value: visible[i + 1].$2!,
                        showDivider: i + 2 < visible.length,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (i + 2 < visible.length) const SizedBox(height: _kSpacing),
        ],
      ],
    );
  }
}

class _CondominiumInfoCell extends StatelessWidget {
  const _CondominiumInfoCell({
    required this.theme,
    required this.label,
    required this.value,
    required this.showDivider,
  });

  final ThemeData theme;
  final String label;
  final Object value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: LelloTextStyles.subtitle(theme)),
            Text(value.toString(), style: LelloTextStyles.subtitleBold(theme)),
          ],
        ),
        if (showDivider)
          const Divider(color: Colors.grey, height: _kSpacing, thickness: 1),
      ],
    );
  }
}
