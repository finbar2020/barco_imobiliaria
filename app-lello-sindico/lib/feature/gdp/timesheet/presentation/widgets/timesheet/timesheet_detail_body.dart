import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_detail_card.dart';

class TimesheetEmployeeDetailBody extends StatelessWidget {
  final TimesheetController controller;
  final TimesheetEmployeeDetailEntity entity;
  final TimesheetEmployee employee;
  const TimesheetEmployeeDetailBody({
    super.key,
    required this.controller,
    required this.entity,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Expanded(
      child: entity.markings.isEmpty
          ? Center(
              child: Text(
                  getString(context, "gdp_timesheet_mark_day_dont_find_anyone"),
                  style: LelloTextStyles.subBody(theme)))
          : Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      entity.markings.length,
                      (index) => TimesheetDetailCard(
                        controller: controller,
                        employee: employee,
                        entity: entity.markings[index],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
