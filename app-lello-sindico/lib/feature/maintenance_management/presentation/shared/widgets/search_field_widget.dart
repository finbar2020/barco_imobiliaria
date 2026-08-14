import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const SearchFieldWidget({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: palette.background(),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.grey()),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.search, color: palette.grey()),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              onChanged: onChanged,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: LelloTextStyles.body(theme)
                    ?.copyWith(color: palette.grey()),
              ),
              style: LelloTextStyles.body(theme),
            ),
          ),
        ],
      ),
    );
  }
}
