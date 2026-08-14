import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';

import '../../domain/entity/report_filters_types_enum.dart';
import '../controller/report_controller.dart';

class SelectedFiltersWidget extends StatefulWidget {
  final List<ReportFilterTypes> filters;
  final ReportFilter filter;
  final void Function(ReportFilterTypes) onFilterRemoved;

  const SelectedFiltersWidget({
    Key? key,
    required this.filters,
    required this.onFilterRemoved,
    required this.filter,
  }) : super(key: key);

  @override
  SelectedFiltersWidgetState createState() => SelectedFiltersWidgetState();
}

class SelectedFiltersWidgetState extends State<SelectedFiltersWidget> {
  final ReportController controller =
      ApplicationContainer.instance().resolve<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.filters.isEmpty,
      child: Padding(
        padding: const EdgeInsets.all(20.00),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(
                  width: Dimens.spacingSmall,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: widget.filters.length,
                itemBuilder: (context, index) {
                  return FilterItem(
                      title: controller.getTypeReportText(
                        type: widget.filters[index],
                      ),
                      content: (widget.filters[index] ==
                                  ReportFilterTypes.period ||
                              widget.filters[index] == ReportFilterTypes.unit)
                          ? controller.getTypeReportSelected(
                              type: widget.filters[index],
                              filter: widget.filter,
                            )
                          : controller.getTypeReportSelected(
                              type: widget.filters[index],
                              filter: widget.filter,
                            ),
                      onTap: () =>
                          widget.onFilterRemoved(widget.filters[index]));
                },
              ),
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
