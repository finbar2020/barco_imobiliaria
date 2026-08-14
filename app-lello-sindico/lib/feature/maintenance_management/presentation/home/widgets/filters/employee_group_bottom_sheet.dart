import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/filter_options_entity.dart';

class EmployeeGroupBottomSheet extends StatefulWidget {
  final List<FilterEmployeeGroupEntity> options;
  final Set<FilterEmployeeGroupEntity> selectedItems;

  const EmployeeGroupBottomSheet({
    super.key,
    required this.options,
    required this.selectedItems,
  });

  @override
  State<EmployeeGroupBottomSheet> createState() =>
      _EmployeeGroupBottomSheetState();
}

class _EmployeeGroupBottomSheetState extends State<EmployeeGroupBottomSheet> {
  final Set<FilterEmployeeGroupEntity> _selectedItems = {};
  final TextEditingController _searchController = TextEditingController();
  List<FilterEmployeeGroupEntity> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.selectedItems);
    _filteredOptions = widget.options;
    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                'Por grupo de funcionários',
                style: LelloTextStyles.titleBold(theme),
              ),
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquise por um grupo',
                prefixIcon: Icon(Icons.search, color: palette.textLight()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: palette.separator()),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: palette.separator()),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final isSelected = _selectedItems.contains(option);

                return CheckboxListTile(
                  title: Text(option.name, style: LelloTextStyles.body(theme)),
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
