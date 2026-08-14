// ignore_for_file: must_be_immutable

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_dropdown.dart';

class TimesheetPointMirrorCard extends StatelessWidget {
  final void Function(bool?)? selectCheckBox;
  final bool massAction;
  final bool indexCheckBox;
  final void Function(String?)? selectIndividualAction;
  final TimesheetEntity entity;
  String? selectedValue;
  final bool isNotify;
  TimesheetPointMirrorCard({
    super.key,
    required this.selectCheckBox,
    required this.massAction,
    required this.indexCheckBox,
    required this.selectedValue,
    required this.selectIndividualAction,
    required this.entity,
    required this.isNotify,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var hasAction = (!massAction && entity.action != TimesheetActionEnum.none);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: LelloTheme.palleteOf(theme).grey())),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (massAction)
              Row(
                children: [
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: Checkbox(
                        value: indexCheckBox, onChanged: selectCheckBox),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                ],
              ),
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "${getString(context, "gdp_vacation_employee_name")}: ",
                                style: LelloTextStyles.bodyBold(theme)),
                            Flexible(
                              child: Text(entity.nameFormatted.trimRight(),
                                  style: LelloTextStyles.subBody(theme)!
                                      .copyWith(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: hasAction ? 145.0 : 0,
                          child: hasAction
                              ? TimesheetPointMirrorDropdown(
                                  isNotify: isNotify,
                                  hintText: getString(
                                      context, "gdp_timesheet_detail_select"),
                                  selectedValue: selectedValue,
                                  onChanged: selectIndividualAction,
                                )
                              : Container())
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(context, "gdp_timesheet_point_mirror_job"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text(entity.jobPosition ?? "",
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getString(
                              context, "gdp_timesheet_point_mirror_signature"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text(
                            entity.signatureEmployee == true
                                ? getString(context,
                                    "gdp_timesheet_point_mirror_signatured")
                                : getString(context,
                                    "gdp_timesheet_point_mirror_pending"),
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getString(context,
                              "gdp_timesheet_point_mirror_ocurrence_pending"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text("${entity.occurrences ?? 0}",
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
