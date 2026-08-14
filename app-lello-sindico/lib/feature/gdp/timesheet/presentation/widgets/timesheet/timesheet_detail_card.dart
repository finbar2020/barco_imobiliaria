import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_marks_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/add_appointment/add_appointment_buttom.dart';

class TimesheetDetailCard extends StatefulWidget {
  final TimesheetController controller;
  final TimesheetEmployeeMarksEntity entity;
  final TimesheetEmployee employee;
  const TimesheetDetailCard({
    super.key,
    required this.controller,
    required this.entity,
    required this.employee,
  });

  @override
  State<TimesheetDetailCard> createState() => _TimesheetDetailCardState();
}

class _TimesheetDetailCardState extends State<TimesheetDetailCard>
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
                    Flexible(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${widget.entity.convertAbrevDay} - ${widget.entity.convertDate}",
                                  style: LelloTextStyles.bodyBold(theme)!
                                      .copyWith(
                                          color: LelloTheme.palleteOf(theme)
                                              .textLight())),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: Dimens.spacingSmall),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${getString(context, "gdp_timesheet_mark")}: ",
                                                      style: LelloTextStyles
                                                              .bodyBold(theme)!
                                                          .copyWith(
                                                              color: LelloTheme
                                                                      .palleteOf(
                                                                          theme)
                                                                  .textLight())),
                                                  Flexible(
                                                    child: Text(
                                                        widget.entity.marks,
                                                        style: LelloTextStyles
                                                                .body(theme)!
                                                            .copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .textLight())),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimens.spacingSmall),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${getString(context, "reports_report")}: ",
                                                      style: LelloTextStyles
                                                              .bodyBold(theme)!
                                                          .copyWith(
                                                              color: LelloTheme
                                                                      .palleteOf(
                                                                          theme)
                                                                  .textLight())),
                                                  Flexible(
                                                    child: Text(
                                                        widget.entity.type,
                                                        style: LelloTextStyles
                                                                .body(theme)!
                                                            .copyWith(
                                                                color: LelloTheme
                                                                        .palleteOf(
                                                                            theme)
                                                                    .textLight())),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        AddAppointmentButtom(
                                          ocorrence: TimesheetOccurrenceEntity(
                                              canTreat: false,
                                              hourRange: '',
                                              jobPosition:
                                                  widget.employee.role ?? '',
                                              name: widget.employee.name ?? '',
                                              numCra: widget.entity.craNumber,
                                              occurenceDuration: widget
                                                  .entity.occurrenceDuration,
                                              occurrenceName:
                                                  widget.entity.type,
                                              occurrenceType:
                                                  widget.entity.type,
                                              photo: widget.controller.photoUrl(
                                                  widget.employee.imageHash ??
                                                      ''),
                                              receivedMark:
                                                  widget.entity.receivedMarking,
                                              referenceDate: widget
                                                  .entity.referenceDate
                                                  .toIso8601String()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(height: Dimens.spacingSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${getString(context, "gdp_timesheet_detail_occurrence")}: ",
                              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).textLight())),
                          Flexible(
                            child: Text(widget.entity.convertExtraHours(),
                                style: LelloTextStyles.body(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .textLight())),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${getString(context, "gdp_timesheet_register_out")}: ",
                              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).textLight())),
                          Flexible(
                            child: Text(
                                widget.entity.outOfRadius ? "Sim" : "Não",
                                style: LelloTextStyles.body(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .textLight())),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                    ],
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
}
