import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/filter_options_entity.dart';

class ResponsibleBottomSheet extends StatefulWidget {
  final List<FilterResponsibleEntity> options;
  final Set<FilterResponsibleEntity> selectedItems;

  const ResponsibleBottomSheet({
    super.key,
    required this.options,
    required this.selectedItems,
  });

  @override
  State<ResponsibleBottomSheet> createState() =>
      _ResponsibleBottomSheetState();
}

class _ResponsibleBottomSheetState extends State<ResponsibleBottomSheet> {
  final Set<FilterResponsibleEntity> _selectedItems = {};
  final TextEditingController _searchController = TextEditingController();
  List<FilterResponsibleEntity> _filteredOptions = [];

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
                'Por Responsável',
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
                hintText: 'Pesquise por um responsável',
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

          // Options list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final person = _filteredOptions[index];
                final isSelected = _selectedItems.contains(person);

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Text(
                      person.name.split(' ').map((e) => e[0]).join(''),
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title:
                      Text(person.name, style: LelloTextStyles.bodyBold(theme)),
                  subtitle: Text(
                    'Responsável',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.textLight(),
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.remove(person);
                        } else {
                          _selectedItems.add(person);
                        }
                      });
                    },
                    icon: Icon(
                      isSelected ? Icons.close : Icons.add,
                      color: isSelected ? palette.error() : palette.textLight(),
                    ),
                  ),
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
