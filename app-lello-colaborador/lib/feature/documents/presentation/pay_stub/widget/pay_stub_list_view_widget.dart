import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/presentation/document_file/page/document_file_page.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PayStubListViewWidget extends StatefulWidget {
  final List<DocumentInfo> documentsInfo;
  const PayStubListViewWidget({
    Key? key,
    required this.documentsInfo,
  }) : super(key: key);

  @override
  State<PayStubListViewWidget> createState() => _PayStubListViewWidgetState();
}

class _PayStubListViewWidgetState extends State<PayStubListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Accordion(
      children: List.generate(
        _months.length,
        (index) {
          return _getAccordionSection(_months[index]);
        },
      ),
    );
  }

  AccordionSection _getAccordionSection(int month) {
    ThemeData theme = Theme.of(context);
    List<DocumentInfo> documentInfoFiltered = _filterByMonth(month);
    return AccordionSection(
      rightIcon: Icon(
        Icons.keyboard_arrow_down,
        size: 32.0,
        color: LelloTheme.palleteOf(theme).hubText(),
      ),
      headerBackgroundColor: LelloTheme.palleteOf(theme).background(),
      headerBackgroundColorOpened: LelloTheme.palleteOf(theme).background(),
      contentBorderColor: LelloTheme.palleteOf(theme).background(),
      contentHorizontalPadding: Dimens.spacingMedium,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            _getTileName(context, month),
            style: LelloTextStyles.subtitle(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          documentInfoFiltered.length,
          (index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, ApplicationRoute.documentFilePage,
                      arguments: DocumentFilePageArgs(
                          documentInfoFiltered[index].name));
                },
                child: Row(
                  children: [
                    SvgPicture.asset("assets/ic_pay_stub.svg"),
                    SizedBox(width: Dimens.spacing),
                    Text(
                      "${getString(context, "pay_stub_page_list_tile_name")} ${index + 1}",
                      style: LelloTextStyles.subtitle(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).hubText(),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getTileName(BuildContext context, int month) {
    DateTime date = DateTime(2000, month);
    String monthString = DateFormat("MMMM").format(date);
    if (monthString.isNotEmpty) {
      monthString = monthString.substring(0, 1).toUpperCase() +
          monthString.substring(1).toLowerCase();
    }
    return monthString;
  }

  List<int> get _months => widget.documentsInfo
      .map((e) => e.documentProcessingDate.month)
      .toSet()
      .toList();

  List<DocumentInfo> _filterByMonth(int month) => widget.documentsInfo
      .where((element) => element.documentProcessingDate.month == month)
      .toList();
}
