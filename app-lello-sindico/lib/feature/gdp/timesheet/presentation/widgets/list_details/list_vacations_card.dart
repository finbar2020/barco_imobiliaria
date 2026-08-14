// ignore_for_file: must_be_immutable

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';

class ListVacationCard extends StatelessWidget {
  final TimesheetOccurrenceVacationEntity entity;
  final VoidCallback onTap;
  ListVacationCard({
    super.key,
    required this.entity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getString(
                              context, "gdp_timesheet_detail_vacation_init"),
                          style: LelloTextStyles.subBody(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text(convertDate(entity.initDate),
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getString(
                              context, "gdp_timesheet_detail_vacation_end"),
                          style: LelloTextStyles.subBody(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Flexible(
                        child: Text(convertDate(entity.endDate),
                            style: LelloTextStyles.subBody(theme)!
                                .copyWith(color: Colors.grey)),
                      ),
                    ],
                  ),
                  if (entity.archiveName.isNotEmpty)
                    SizedBox(height: Dimens.spacingSmall),
                  if (entity.archiveName.isNotEmpty)
                    InkWell(
                      onTap: onTap,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              getString(context,
                                  "gdp_timesheet_detail_vacation_receipt"),
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const Icon(
                            Icons.sim_card_download_outlined,
                            size: 20.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convertDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatted = DateFormat.yMd();
    return formatted.format(dateTime);
  }
}
