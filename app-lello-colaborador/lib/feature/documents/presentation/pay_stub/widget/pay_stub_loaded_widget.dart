import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_list_view_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PayStubLoadedWidget extends StatefulWidget {
  final List<DocumentInfo> documentsInfo;
  const PayStubLoadedWidget({
    Key? key,
    required this.documentsInfo,
  }) : super(key: key);

  @override
  State<PayStubLoadedWidget> createState() => _PayStubLoadedWidgetState();
}

class _PayStubLoadedWidgetState extends State<PayStubLoadedWidget> {
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    if (widget.documentsInfo.isNotEmpty) {
      selectedYear =
          widget.documentsInfo.first.documentProcessingDate.year.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Text(
            getString(context, "pay_stub_page_description"),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
          ),
        ),
        if (widget.documentsInfo.isEmpty)
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
            child: Text(
              getString(context, "pay_stub_page_empty"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            ),
          )),
        if (widget.documentsInfo.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                  child: Text(
                    getString(context, "pay_stub_page_select_year"),
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).hubText()),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                  width: 160.0,
                  child: DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return getString(context, "validation_required");
                      }
                      return null;
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    value: selectedYear,
                    items: _dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedYear = value;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Expanded(
                  child: PayStubListViewWidget(
                    documentsInfo: widget.documentsInfo
                        .where((element) =>
                            element.documentProcessingDate.year.toString() ==
                            selectedYear)
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        Container(),
      ],
    );
  }

  List<DropdownMenuItem<String>> get _dropdownMenuItems {
    ThemeData theme = Theme.of(context);
    return _years
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
                textScaleFactor: 1.0,
              ),
            ))
        .toList();
  }

  List<String> get _years => widget.documentsInfo
      .map((e) => e.documentProcessingDate.year.toString())
      .toSet()
      .toList();
}
