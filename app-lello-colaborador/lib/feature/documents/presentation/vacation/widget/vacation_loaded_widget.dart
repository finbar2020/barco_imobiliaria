import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/presentation/vacation/widget/vacation_list_view_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VacationLoadedWidget extends StatefulWidget {
  final List<DocumentInfo> documentsInfo;
  const VacationLoadedWidget({
    Key? key,
    required this.documentsInfo,
  }) : super(key: key);

  @override
  State<VacationLoadedWidget> createState() => _VacationLoadedWidgetState();
}

class _VacationLoadedWidgetState extends State<VacationLoadedWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Text(
            getString(context, "vacation_page_description"),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
          ),
        ),
        if (widget.documentsInfo.isEmpty)
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
            child: Text(
              getString(context, "vacation_page_empty"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            ),
          )),
        if (widget.documentsInfo.isNotEmpty)
          VacationListViewWidget(
            documentsInfo: widget.documentsInfo,
          ),
        Container(),
      ],
    );
  }
}
