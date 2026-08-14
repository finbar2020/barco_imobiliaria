import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';
import 'dropdown_bottom_sheet.dart';
import 'dropdown_bottom_sheet_element.dart';

class DropdownBottomSheetButton<T> extends StatelessWidget {
  final List<DropdownBottomSheetElement<T>> dropDownElements;
  final void Function(DropdownBottomSheetElement<T> element) doneFunction;
  final String? title;
  final String? valueText;
  final String? hintText;
  final bool showFilter;
  final int? maxLines;

  const DropdownBottomSheetButton({
    Key? key,
    required this.dropDownElements,
    required this.doneFunction,
    this.title,
    this.valueText,
    this.hintText,
    this.showFilter = true,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        DropdownBottomSheet.show<T>(
          dropDownElements: dropDownElements,
          doneFunction: doneFunction,
          context: context,
          title: title ?? "",
          showFilter: showFilter,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: LelloTheme.palleteOf(theme).grey()),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacing, vertical: Dimens.spacingMedium),
        child: Row(
          children: [
            Expanded(
              child: Text(
                valueText ?? hintText ?? title ?? "",
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: valueText != null
                    ? LelloTextStyles.subtitle(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).text())
                    : LelloTextStyles.subtitle(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).textOpaque()),
              ),
            ),
            Container(
                child: Icon(
              Icons.arrow_drop_down,
              color: LelloTheme.palleteOf(theme).textOpaque(),
            )),
          ],
        ),
      ),
    );
  }
}
