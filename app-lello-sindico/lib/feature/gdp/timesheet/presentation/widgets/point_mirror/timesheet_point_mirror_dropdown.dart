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
  late final ValueNotifier<String?> _valueListenable;

  @override
  void initState() {
    super.initState();
    _valueListenable = ValueNotifier(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant TimesheetPointMirrorDropdown oldWidget) {
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
    final actionLabel = widget.isNotify ? "Notificar" : "Assinar";
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
            DropdownItem<String>(
              value: null,
              height: 40,
              child: Text(
                widget.hintText,
                style: LelloTextStyles.subBody(theme)!
                    .copyWith(color: Colors.black),
              ),
            ),
            DropdownItem<String>(
              value: actionLabel,
              height: 40,
              child: Text(
                actionLabel,
                style: LelloTextStyles.subBody(theme)!
                    .copyWith(color: Colors.black),
              ),
            )
          ],
          valueListenable: _valueListenable,
          onChanged: (value) {
            _valueListenable.value = value;
            widget.onChanged?.call(value);
          },
          buttonStyleData: ButtonStyleData(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: const EdgeInsets.only(left: 40.0),
            height: 40,
            width: 170,
          ),
        ),
      ),
    );
  }
}
