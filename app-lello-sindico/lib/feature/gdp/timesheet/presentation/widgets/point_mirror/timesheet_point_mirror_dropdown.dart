// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';

class TimesheetPointMirrorDropdown extends StatefulWidget {
  final String hintText;
  String? selectedValue;
  final void Function(String?)? onChanged;
  final bool isNotify;
  TimesheetPointMirrorDropdown({
    super.key,
    required this.hintText,
    required this.selectedValue,
    required this.onChanged,
    required this.isNotify,
  });

  @override
  State<TimesheetPointMirrorDropdown> createState() =>
      _TimesheetPointMirrorDropdownState();
}

class _TimesheetPointMirrorDropdownState
    extends State<TimesheetPointMirrorDropdown> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
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
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                widget.hintText,
                style: LelloTextStyles.subBody(theme)!
                    .copyWith(color: Colors.black),
              ),
            ),
            DropdownMenuItem<String>(
              value: widget.isNotify ? "Notificar" : "Assinar",
              child: Text(
                widget.isNotify ? "Notificar" : "Assinar",
                style: LelloTextStyles.subBody(theme)!
                    .copyWith(color: Colors.black),
              ),
            )
          ],
          value: widget.selectedValue,
          onChanged: widget.onChanged,
          buttonStyleData: ButtonStyleData(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: const EdgeInsets.only(left: 40.0),
            height: 40,
            width: 170,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }
}
