// ignore_for_file: must_be_immutable

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_dropdown.dart';

class ListDetailsCard extends StatelessWidget {
  final void Function(bool?)? selectCheckBox;
  final bool massAction;
  final bool indexCheckBox;
  final void Function(String?)? selectIndividualAction;
  final TimesheetOccurrenceEntity entity;
  String? selectedValue;
  final TimesheetOccurrenceTypeEnum type;
  ListDetailsCard({
    super.key,
    required this.selectCheckBox,
    required this.massAction,
    required this.indexCheckBox,
    required this.selectedValue,
    required this.selectIndividualAction,
    required this.entity,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isFoul = type == TimesheetOccurrenceTypeEnum.fouls;
    bool isDelay = type == TimesheetOccurrenceTypeEnum.delay;
    bool isExtraHour = type == TimesheetOccurrenceTypeEnum.extraHour;
    ThemeData theme = Theme.of(context);
    bool isDelayOrFoul = isDelay || isFoul;
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
            if (massAction && isDelayOrFoul)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${getString(context, "gdp_vacation_employee_name")}: ",
                          style: LelloTextStyles.bodyBold(theme)),
                      Flexible(
                        child: Text(entity.nameFormatted.trimRight(),
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.black)),
                      ),
                      if (!massAction && isDelayOrFoul)
                        ListDetailsDropdown(
                          width: 145.0,
                          hintText:
                              getString(context, "gdp_timesheet_detail_select"),
                          selectedValue: selectedValue,
                          onChanged: selectIndividualAction,
                        ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${getString(context, "accountability_history_date")}: ",
                          style: LelloTextStyles.subBody(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text(entity.convertDate(),
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.black)),
                      ),
                    ],
                  ),
                  if (isDelay) SizedBox(height: Dimens.spacingSmall),
                  if (isDelay)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(context, "gdp_timesheet_detail_marks"),
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.marks,
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  if (isDelay) SizedBox(height: Dimens.spacingSmall),
                  if (isDelay)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            getString(context,
                                "gdp_timesheet_detail_delays_in_hours"),
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.convertExtraHours(),
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  if (isFoul) SizedBox(height: Dimens.spacingSmall),
                  if (isFoul)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(context, "gdp_timesheet_detail_turn"),
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.turn,
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  if (isExtraHour) SizedBox(height: Dimens.spacingSmall),
                  if (isExtraHour)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(context, "gdp_timesheet_detail_marks"),
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.marks,
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  if (isExtraHour) SizedBox(height: Dimens.spacingSmall),
                  if (isExtraHour)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${getString(context, "gdp_timesheet_grid_extra_hours")}: ",
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.convertExtraHours(),
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  if (isExtraHour) SizedBox(height: Dimens.spacingSmall),
                  if (isExtraHour)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${getString(context, "gdp_payslip_selection_type")}: ",
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Flexible(
                          child: Text(entity.occurrenceName,
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
