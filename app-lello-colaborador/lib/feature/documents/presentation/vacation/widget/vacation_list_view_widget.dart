import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/presentation/document_file/page/document_file_page.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VacationListViewWidget extends StatefulWidget {
  final List<DocumentInfo> documentsInfo;
  const VacationListViewWidget({
    Key? key,
    required this.documentsInfo,
  }) : super(key: key);

  @override
  State<VacationListViewWidget> createState() => _VacationListViewWidgetState();
}

class _VacationListViewWidgetState extends State<VacationListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Accordion(
      children: List.generate(
        _years.length,
        (index) {
          return _getAccordionSection(_years[index]);
        },
      ),
    );
  }

  AccordionSection _getAccordionSection(int year) {
    ThemeData theme = Theme.of(context);
    List<DocumentInfo> documentInfoFiltered = _filterByYear(year);
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
            _getTileName(context, year),
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
                    SvgPicture.asset("assets/ic_vacation.svg"),
                    SizedBox(width: Dimens.spacing),
                    Text(
                      "${getString(context, "vacation_page_list_tile_name")} ${index + 1}",
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

  String _getTileName(BuildContext context, int year) {
    return year.toString();
  }

  List<int> get _years => widget.documentsInfo
      .map((e) => e.documentProcessingDate.year)
      .toSet()
      .toList();

  List<DocumentInfo> _filterByYear(int year) => widget.documentsInfo
      .where((element) => element.documentProcessingDate.year == year)
      .toList();
}
