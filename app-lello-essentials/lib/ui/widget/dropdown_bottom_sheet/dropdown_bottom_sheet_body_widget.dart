import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_localization.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../form_field/primary_text_form_field.dart';
import '../text/lello_text_styles.dart';
import 'dropdown_bottom_sheet_element.dart';

class DropdownBottomSheetBodyWidget<T> extends StatefulWidget {
  final String title;
  final List<DropdownBottomSheetElement<T>> dropDownElements;
  final void Function(DropdownBottomSheetElement<T> element) doneFunction;
  final bool showFilter;

  const DropdownBottomSheetBodyWidget({
    Key? key,
    required this.title,
    required this.dropDownElements,
    required this.doneFunction,
    required this.showFilter,
  }) : super(key: key);

  @override
  State<DropdownBottomSheetBodyWidget<T>> createState() =>
      _DropdownBottomSheetBodyWidgetState<T>();
}

class _DropdownBottomSheetBodyWidgetState<T>
    extends State<DropdownBottomSheetBodyWidget<T>> {
  List<DropdownBottomSheetElement<T>> visibleElements = [];
  DropdownBottomSheetElement<T>? selectedElement;
  String filter = "";
  final FixedExtentScrollController _pickerController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    visibleElements = widget.dropDownElements;
    selectedElement = visibleElements.isNotEmpty ? visibleElements.first : null;
  }

  @override
  void dispose() {
    _pickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 400 + MediaQuery.of(context).viewInsets.bottom,
      padding: MediaQuery.of(context).viewInsets,
      color: LelloTheme.palleteOf(theme).separator(),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, 0,
              Dimens.spacingMedium, Dimens.spacingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: Dimens.spacingMedium),
                  child: Text(
                    getString(context, "back", defaultText: "Voltar"),
                    textScaleFactor: 1.0,
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.spacingMedium),
                child: Text(
                  widget.title,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.titleSmall(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (selectedElement != null) {
                    widget.doneFunction(selectedElement!);
                  }
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: Dimens.spacingMedium),
                  child: Text(
                    getString(context, "done", defaultText: "Feito"),
                    textScaleFactor: 1.0,
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).primary(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.showFilter)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
            child: PrimaryTextFormField(
              textInputType: TextInputType.text,
              action: TextInputAction.done,
              hint: getString(context, "filter", defaultText: "Filtro"),
              onChanged: (value) {
                setState(() {
                  filter = value;
                  visibleElements = widget.dropDownElements
                      .where(
                        (element) => element.text
                            .toLowerCase()
                            .contains(value.toLowerCase()),
                      )
                      .toList();
                  // Ao filtrar, o picker volta ao primeiro item visível e o
                  // elemento selecionado acompanha o que está na tela.
                  selectedElement =
                      visibleElements.isNotEmpty ? visibleElements.first : null;
                  if (_pickerController.hasClients) {
                    _pickerController.jumpToItem(0);
                  }
                });
              },
            ),
          ),
        Expanded(
          child: CupertinoPicker(
            scrollController: _pickerController,
            itemExtent: 56,
            onSelectedItemChanged: (value) {
              selectedElement = visibleElements[value];
            },
            children: List.generate(
              visibleElements.length,
              (index) => Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                  child: Text(
                    visibleElements[index].text,
                    style: LelloTextStyles.titleSmall(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
