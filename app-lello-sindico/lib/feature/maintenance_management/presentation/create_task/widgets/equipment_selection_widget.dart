import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/filter_options_entity.dart';

class EquipmentSelectionWidget extends StatelessWidget {
  final FilterAssetEntity? selectedEquipment;
  final List<FilterAssetEntity> availableEquipments;
  final Function(FilterAssetEntity?) onEquipmentSelected;
  final ThemeData theme;
  final ColorPallete palette;

  const EquipmentSelectionWidget({
    super.key,
    required this.selectedEquipment,
    required this.availableEquipments,
    required this.onEquipmentSelected,
    required this.theme,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEquipmentBottomSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: palette.separator()),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedEquipment?.name ?? 'Selecione',
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: selectedEquipment != null
                      ? palette.text()
                      : palette.textLight(),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: palette.textLight(),
            ),
          ],
        ),
      ),
    );
  }

  void _showEquipmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => _EquipmentBottomSheet(
        availableEquipments: availableEquipments,
        selectedEquipment: selectedEquipment,
        onEquipmentSelected: onEquipmentSelected,
        theme: theme,
        palette: palette,
      ),
    );
  }
}

class _EquipmentBottomSheet extends StatefulWidget {
  final List<FilterAssetEntity> availableEquipments;
  final FilterAssetEntity? selectedEquipment;
  final Function(FilterAssetEntity?) onEquipmentSelected;
  final ThemeData theme;
  final ColorPallete palette;

  const _EquipmentBottomSheet({
    required this.availableEquipments,
    required this.selectedEquipment,
    required this.onEquipmentSelected,
    required this.theme,
    required this.palette,
  });

  @override
  State<_EquipmentBottomSheet> createState() => _EquipmentBottomSheetState();
}

class _EquipmentBottomSheetState extends State<_EquipmentBottomSheet> {
  List<FilterAssetEntity> _filteredEquipments = [];

  @override
  void initState() {
    super.initState();
    _filteredEquipments = widget.availableEquipments;
  }

  void _filterEquipments(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEquipments = widget.availableEquipments;
      } else {
        _filteredEquipments = widget.availableEquipments
            .where((equipment) =>
                equipment.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: widget.palette.text()),
              ),
              Expanded(
                child: Text(
                  'Por equipamentos',
                  style: LelloTextStyles.title(widget.theme)?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the close button
            ],
          ),

          const SizedBox(height: 16),

          // Search field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: widget.palette.separator()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: widget.palette.textLight(),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: _filterEquipments,
                    decoration: InputDecoration(
                      hintText: 'Pesquise por um ambiente',
                      hintStyle: LelloTextStyles.body(widget.theme)?.copyWith(
                        color: widget.palette.textLight(),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: LelloTextStyles.body(widget.theme),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Equipment list
          Expanded(
            child: ListView.separated(
              itemCount: _filteredEquipments.length,
              separatorBuilder: (context, index) => Divider(
                color: widget.palette.separator(),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final equipment = _filteredEquipments[index];
                final isSelected = widget.selectedEquipment?.id == equipment.id;

                return ListTile(
                  title: Text(
                    equipment.name,
                    style: LelloTextStyles.body(widget.theme)?.copyWith(
                      color: widget.palette.text(),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: widget.palette.primary(),
                        )
                      : null,
                  onTap: () {
                    widget.onEquipmentSelected(equipment);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
