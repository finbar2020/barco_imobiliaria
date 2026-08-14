import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class StaffAccessManagementDropdown extends StatefulWidget {
  final String title;
  final bool? isNotRequired;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  const StaffAccessManagementDropdown({
    required this.title,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.isNotRequired,
    super.key,
  });

  @override
  State<StaffAccessManagementDropdown> createState() =>
      _StaffAccessManagementDropdownState();
}

class _StaffAccessManagementDropdownState
    extends State<StaffAccessManagementDropdown> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isNotRequired == null)
          Text(
            "${widget.title}*",
            style: LelloTextStyles.bodyBold(theme),
          ),
        SizedBox(height: Dimens.spacingSmall),
        DropdownButtonFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: LelloTheme.palleteOf(theme).separator(), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: LelloTheme.palleteOf(theme).separator(), width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: LelloTheme.palleteOf(theme).primary(), width: 1),
              )),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          hint: Text(
            getString(context, "gdp_timesheet_select"),
            style: LelloTextStyles.body(theme),
          ),
          value: widget.value,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                getString(context, item),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
