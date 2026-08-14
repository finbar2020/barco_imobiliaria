import 'package:flutter/material.dart';

import '../../../modal/modal.dart';
import 'dropdown_bottom_sheet_body_widget.dart';
import 'dropdown_bottom_sheet_element.dart';

class DropdownBottomSheet {
  static show<T>({
    required BuildContext context,
    required String title,
    required List<DropdownBottomSheetElement<T>> dropDownElements,
    required void Function(DropdownBottomSheetElement<T> element) doneFunction,
    bool showFilter = true,
  }) {
    Modal.showBottomSheet(
      context: context,
      builder: (context) {
        return DropdownBottomSheetBodyWidget<T>(
          title: title,
          dropDownElements: dropDownElements,
          showFilter: showFilter,
          doneFunction: doneFunction,
        );
      },
    );
  }
}
