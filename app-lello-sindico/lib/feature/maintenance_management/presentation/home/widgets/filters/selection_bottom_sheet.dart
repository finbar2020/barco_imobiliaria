import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> selectedItems;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedItems,
  });

  @override
  State<SelectionBottomSheet> createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<SelectionBottomSheet> {
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: LelloTextStyles.titleBold(theme),
              ),
            ),
          ),

          // Options list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = _selectedItems.contains(option);

                return CheckboxListTile(
                  title: Text(option, style: LelloTextStyles.body(theme)),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedItems.add(option);
                      } else {
                        _selectedItems.remove(option);
                      }
                    });
                  },
                  activeColor: palette.primary(),
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              },
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Selecionar',
                onPressed: () => Navigator.of(context).pop(_selectedItems),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
