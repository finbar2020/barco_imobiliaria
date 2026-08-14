import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_list_view_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class BenefitsLoadedWidget extends StatefulWidget {
  final List<DocumentInfo> documentsInfo;
  const BenefitsLoadedWidget({
    Key? key,
    required this.documentsInfo,
  }) : super(key: key);

  @override
  State<BenefitsLoadedWidget> createState() => _BenefitsLoadedWidgetState();
}

class _BenefitsLoadedWidgetState extends State<BenefitsLoadedWidget> {
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
            getString(context, "benefits_page_description"),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
          ),
        ),
        if (widget.documentsInfo.isEmpty)
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
            child: Text(
              getString(context, "benefits_page_empty"),
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
                    getString(context, "benefits_page_select_year"),
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
                  child: BenefitsListViewWidget(
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
