import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ChangeOwnershipDropdown extends StatefulWidget {
  final String title;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String? selectTypePerson;
  final bool isRequired;
  const ChangeOwnershipDropdown({
    required this.title,
    required this.items,
    required this.onChanged,
    required this.selectTypePerson,
    required this.isRequired,
    this.value,
    this.validator,
    super.key,
  });

  @override
  State<ChangeOwnershipDropdown> createState() =>
      _ChangeOwnershipDropdownState();
}

class _ChangeOwnershipDropdownState extends State<ChangeOwnershipDropdown> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: _choicePersonType(),
      child: Opacity(
        opacity: _choicePersonType() ? 0.3 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRequired ? "${widget.title}*" : widget.title,
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: LelloTheme.palleteOf(theme).separator(),
                        width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: LelloTheme.palleteOf(theme).separator(),
                        width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: LelloTheme.palleteOf(theme).primary(), width: 1),
                  )),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              hint: Text(
                getString(context, "gdp_timesheet_select"),
                style: LelloTextStyles.body(theme),
              ),
              value: widget.value,
              items: widget.items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              onChanged: widget.onChanged,
              validator: widget.validator,
            ),
          ],
        ),
      ),
    );
  }

  bool _choicePersonType() {
    return widget.selectTypePerson == null;
  }
}
