import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_add_appointment_page.dart';

class AddAppointmentButtom extends StatefulWidget {
  final TimesheetOccurrenceEntity ocorrence;

  const AddAppointmentButtom({
    super.key,
    required this.ocorrence,
  });

  @override
  State<AddAppointmentButtom> createState() => _AddAppointmentButtomState();
}

class _AddAppointmentButtomState extends State<AddAppointmentButtom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.ocorrence.enableButton
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimesheetAddAppointmentPage(
                        ocorrence: widget.ocorrence),
                  ),
                );
              }
            : null,
        child: SvgPicture.asset(
          "assets/ic_add_mark.svg",
          color: widget.ocorrence.enableButton ? null : Colors.grey,
        ));
  }
}
