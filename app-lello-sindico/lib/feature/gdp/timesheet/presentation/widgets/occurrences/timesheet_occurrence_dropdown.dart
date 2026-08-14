// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';

class TimesheetOccurrenceDropdown extends StatefulWidget {
  final String hintText;
  String? selectedValue;
  final double width;
  final void Function(String?)? onChanged;
  final List<String> items;
  TimesheetOccurrenceDropdown({
    super.key,
    required this.hintText,
    required this.selectedValue,
    required this.width,
    required this.onChanged,
    required this.items,
  });

  @override
  State<TimesheetOccurrenceDropdown> createState() =>
      _TimesheetOccurrenceDropdownState();
}

class _TimesheetOccurrenceDropdownState
    extends State<TimesheetOccurrenceDropdown> {
  late final ValueNotifier<String?> _valueListenable;

  @override
  void initState() {
    super.initState();
    _valueListenable = ValueNotifier(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant TimesheetOccurrenceDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != _valueListenable.value) {
      _valueListenable.value = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: widget.width,
      height: 20.0,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          alignment: AlignmentDirectional.centerEnd,
          hint: Text(
            widget.hintText,
            style:
                LelloTextStyles.subBody(theme)!.copyWith(color: Colors.black),
          ),
          items: widget.items
              .map((String item) => DropdownItem<String>(
                    value: item,
                    height: 40,
                    child: Text(
                      item,
                      style: LelloTextStyles.subBody(theme)!
                          .copyWith(color: Colors.black),
                    ),
                  ))
              .toList(),
          valueListenable: _valueListenable,
          onChanged: (value) {
            _valueListenable.value = value;
            widget.onChanged?.call(value);
          },
          buttonStyleData: ButtonStyleData(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: widget.selectedValue != null
                ? widget.selectedValue == 'Abonar'
                    ? EdgeInsets.only(left: 60.0)
                    : EdgeInsets.only(left: 40.0)
                : EdgeInsets.only(left: 20.0),
            height: 40,
            width: 170,
          ),
        ),
      ),
    );
  }
}
