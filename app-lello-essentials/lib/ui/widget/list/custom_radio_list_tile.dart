// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  CustomRadioListTile(
      {this.title = '',
      required this.groupValue,
      required this.value,
      required this.onChanged,
      this.padding = const EdgeInsets.only(top: 8.0, bottom: 8.0)});

  CustomRadioListTile.custom(
      {required this.groupValue,
      required this.value,
      required this.onChanged,
      required this.titleWidget,
      this.padding = const EdgeInsets.only(top: 8.0, bottom: 8.0)});

  String title = "";
  Widget? titleWidget;
  final EdgeInsets padding;
  final T? groupValue;
  final T value;
  final Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged?.call(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 24,
              height: 24,
              child: Radio(
                groupValue: groupValue,
                value: value,
                onChanged: (T? newValue) {
                  onChanged?.call(newValue);
                },
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            titleWidget ?? Text(title, style: LelloTextStyles.body(theme)),
          ],
        ),
      ),
    );
  }
}
