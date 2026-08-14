// ignore_for_file: must_be_immutable

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/add_appointment/add_appointment_buttom.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_dropdown.dart';

class TimesheetOccurrenceCard extends StatefulWidget {
  final void Function(bool?)? selectCheckBox;
  final bool massAction;
  final bool indexCheckBox;
  final void Function(String?)? selectIndividualAction;
  final TimesheetOccurrenceEntity entity;
  String? selectedValue;
  TimesheetOccurrenceCard({
    super.key,
    required this.selectCheckBox,
    required this.massAction,
    required this.indexCheckBox,
    required this.selectedValue,
    required this.selectIndividualAction,
    required this.entity,
  });

  @override
  State<TimesheetOccurrenceCard> createState() =>
      _TimesheetOccurrenceCardState();
}

class _TimesheetOccurrenceCardState extends State<TimesheetOccurrenceCard>
    with TickerProviderStateMixin {
  final ExpansionTileController expansionController = ExpansionTileController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                border: Border.all(color: LelloTheme.palleteOf(theme).grey())),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (value) {
                  if (expansionController.isExpanded) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                tilePadding: const EdgeInsets.all(0),
                controller: expansionController,
                trailing: const SizedBox(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.massAction)
                      Row(
                        children: [
                          SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Checkbox(
                                value: widget.indexCheckBox,
                                onChanged: widget.selectCheckBox),
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
                                child: Text(
                                    capitalizeFirstLetter(widget.entity.name)
                                        .trimRight(),
                                    style: LelloTextStyles.subBody(theme)!
                                        .copyWith(color: Colors.black)),
                              ),
                              if (widget.entity.canTreat && !widget.massAction)
                                ListDetailsDropdown(
                                  width: 145.0,
                                  hintText: getString(
                                      context, "gdp_timesheet_detail_select"),
                                  selectedValue: widget.selectedValue,
                                  onChanged: widget.selectIndividualAction,
                                ),
                            ],
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${getString(context, "accountability_history_date")}: ",
                                            style:
                                                LelloTextStyles.subBody(theme)!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                        Text(widget.entity.convertDate(),
                                            style:
                                                LelloTextStyles.subBody(theme)!
                                                    .copyWith(
                                                        color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: Dimens.spacingSmall),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${getString(context, "reports_report")}: ",
                                            style:
                                                LelloTextStyles.subBody(theme)!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                        Flexible(
                                          child: Text(
                                              widget.entity.occurrenceName,
                                              style: LelloTextStyles.subBody(
                                                      theme)!
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AddAppointmentButtom(
                                ocorrence: widget.entity,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: <Widget>[
                  Padding(
                    padding: widget.massAction
                        ? const EdgeInsets.only(left: 28.0)
                        : const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        SizedBox(height: Dimens.spacingSmall),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                getString(
                                    context, "gdp_timesheet_detail_marks"),
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Flexible(
                              child: Text(widget.entity.marks,
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
                                    "gdp_timesheet_occurrence_details"),
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Flexible(
                              child: Text(widget.entity.convertExtraHours(),
                                  style: LelloTextStyles.subBody(theme)!
                                      .copyWith(color: Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (expansionController.isExpanded) {
                expansionController.collapse();
                _animationController.reverse();
              } else {
                expansionController.expand();
                _animationController.forward();
              }
            },
            child: Container(
              height: 30,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 2, right: 2, left: 2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0)
                        .animate(_animationController),
                    child: const Icon(Icons.expand_more),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  capitalizeFirstLetter(String name) {
    String capitalizedString =
        name.trimRight().split(' ').map((word) => word.capitalize).join(' ');
    return capitalizedString;
  }
}
