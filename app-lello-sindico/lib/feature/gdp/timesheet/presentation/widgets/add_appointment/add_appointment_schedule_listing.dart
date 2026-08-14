import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_add_appointment.dart';

class AddAppointmentScheduleListing extends StatefulWidget {
  final TimesheetAddAppointmentController controller;

  const AddAppointmentScheduleListing({
    super.key,
    required this.controller,
  });

  @override
  State<AddAppointmentScheduleListing> createState() =>
      _AddAppointmentScheduleListingState();
}

class _AddAppointmentScheduleListingState
    extends State<AddAppointmentScheduleListing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool canAdd =
        widget.controller.canAddNew && widget.controller.timeList.length < 6;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.schedule,
              color: Colors.grey,
            ),
            SizedBox(width: Dimens.spacingSmall),
            Text(
              "${getString(context, "gdp_timesheet_add_appointment_schedules")}:",
              style: LelloTextStyles.body(theme),
            )
          ],
        ),
        SizedBox(height: Dimens.spacingSmall),
        widget.controller.timeList.isEmpty &&
                widget.controller.canAddNew == false
            ? Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      getString(context, "gdp_timesheet_event_time_unmarked")),
                ))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: widget.controller.timeList.length + (canAdd ? 1 : 0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (canAdd && index == widget.controller.timeList.length) {
                    return InkWell(
                      child: const Center(child: Icon(Icons.add)),
                      onTap: () {
                        setState(() {
                          var now = TimeOfDay.now();
                          widget.controller.timeList.add(TimeItem(
                              timeOfDay: now,
                              controller: TextEditingController(
                                  text: widget.controller
                                      .timeOfDayToString(now))));
                          selectTime(context, index);
                        });
                      },
                    );
                  }
                  return Center(
                    child: widget.controller.timeList[index].controller != null
                        ? TextField(
                            onTap: () => selectTime(context, index),
                            controller:
                                widget.controller.timeList[index].controller,
                            readOnly: true,
                            style: LelloTextStyles.body(theme)
                                ?.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              suffixIconConstraints: const BoxConstraints(
                                  maxHeight: 23, maxWidth: 23),
                              suffixIcon: IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.delete,
                                    color: Colors.grey),
                                iconSize: 23,
                                padding: EdgeInsets.only(
                                    bottom: Dimens.spacingSmall),
                                onPressed: () => {
                                  setState(() {
                                    widget.controller.timeList.removeAt(index);
                                  })
                                },
                              ),
                            ),
                          )
                        : Text(
                            widget.controller.timeOfDayToString(
                                widget.controller.timeList[index].timeOfDay),
                            style: TextStyle(fontSize: Dimens.spacing),
                          ),
                  );
                },
              ),
      ],
    );
  }

  Future<void> selectTime(BuildContext context, int index) async {
    {
      var theme = Theme.of(context);
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: theme.copyWith(
                  colorScheme: ColorScheme.light(
                primary: theme.primaryColor,
              )),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ));
        },
      );
      if (pickedTime != null &&
          pickedTime != widget.controller.timeList[index].timeOfDay) {
        setState(() {
          widget.controller.timeList[index] = TimeItem(
              timeOfDay: pickedTime,
              controller: widget.controller.timeList[index].controller);
          widget.controller.timeList[index].controller!.text = widget.controller
              .timeOfDayToString(widget.controller.timeList[index].timeOfDay);
        });
      }
    }
  }
}
