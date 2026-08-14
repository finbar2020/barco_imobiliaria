import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_add_appointment.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_add_appointment_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_add_appointment_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/add_appointment/add_appointment_schedule_listing.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/employee_header_card/employee_header_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_pending_appontments/list_pending_appointments.dart';

class TimesheetAddAppointmentPage extends StatefulWidget {
  final TimesheetOccurrenceEntity ocorrence;
  const TimesheetAddAppointmentPage({
    super.key,
    required this.ocorrence,
  });

  @override
  State<TimesheetAddAppointmentPage> createState() =>
      _TimesheetAddAppointmentPageState();
}

class _TimesheetAddAppointmentPageState
    extends State<TimesheetAddAppointmentPage> {
  TimesheetAddAppointmentController controller = ApplicationContainer.instance()
      .resolve<TimesheetAddAppointmentController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.setOcurrence(widget.ocorrence);
  }

  @override
  void dispose() {
    controller.dispose();
    //controller.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        iconColor: theme.primaryColor,
        theme: theme,
        title: getString(context, "gdp_timesheet_appBar"),
      ),
      body: BlocConsumer<TimesheetAddAppointmentBloc,
          TimesheetAddAppointmentState>(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is TimesheetAddAppointmentSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const TimesheetAddAppointmentSuccessPage(),
              ),
            );
          } else if (state is TimesheetAddAppointmentFailedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TimesheetAddAppointmentFailedPage(message: (state).message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TimesheetAddAppointmentLoadingState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Dimens.spacingMedium),
                const Center(child: CircularProgressIndicator()),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(context, "please_wait",
                      defaultText: "Por favor, aguarde"),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ],
            );
          } else if (state is TimesheetAddAppointmentSuccessState) {
            return Text(
              getString(context, "sended"),
              style: LelloTextStyles.body(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        getString(
                            context, "gdp_timesheet_add_appointment_title"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    TimesheetEmployeeHeaderCard(
                      theme: theme,
                      pictureLink: controller.occurrence.photo,
                      name: controller.occurrence.name,
                      jobPosition: controller.occurrence.jobPosition,
                      date: controller.occurrence.convertDate(),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    AddAppointmentScheduleListing(controller: controller),
                    SizedBox(height: Dimens.spacing),
                    ListPendingAppointments(ocorrence: controller.occurrence),
                    _buildAction(theme),
                    SizedBox(height: Dimens.spacingMedium),
                    Row(
                      children: [
                        const Icon(Icons.notes_outlined),
                        SizedBox(width: Dimens.spacing),
                        Text(
                          "Justificativa",
                          style: LelloTextStyles.subtitle(theme),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacing),
                    _buildDropdonwJustification(context, theme),
                    SizedBox(height: Dimens.spacing),
                    PrimaryButton(
                        onPressed: validForm() ? saveForm : null,
                        text: getString(context, "save")),
                    SizedBox(height: Dimens.spacing),
                    SecondaryButton(
                        text: getString(context, "cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void saveForm() {
    {
      if (_formKey.currentState?.validate() == false) {
        return;
      }
      if (controller.showAddMarkingMessage) {
        Fluttertoast.showToast(
            msg: getString(
                context, "gdp_timesheet_add_appointment_schedules_no_markins"),
            toastLength: Toast.LENGTH_SHORT);
        return;
      }
      controller.send();
    }
  }

  Widget _buildDropdonwJustification(BuildContext context, ThemeData theme) {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null) {
          return getString(context, "validation_required");
        }
        return null;
      },
      icon: const Icon(Icons.keyboard_arrow_down),
      value: controller.selectedJustification,
      hint: const Text("Selecionar"),
      items: [
        DropdownMenuItem<String>(
          value: "Esquecimento",
          child: Text(
            getString(context,
                "gdp_timesheet_add_appointment_schedules_justification_forgot"),
            style: LelloTextStyles.subtitle(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            textScaleFactor: 1.0,
          ),
        ),
        DropdownMenuItem<String>(
          value: "Falha",
          child: Text(
            getString(context,
                "gdp_timesheet_add_appointment_schedules_justification_failed"),
            style: LelloTextStyles.subtitle(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            textScaleFactor: 1.0,
          ),
        )
      ],
      onChanged: (value) {
        setState(() {
          if (value != null) {
            controller.selectedJustification = value;
          }
        });
      },
    );
  }

  Widget _buildAction(ThemeData theme) {
    if (controller.onlymanual) return Container();
    var padding = EdgeInsets.only(top: Dimens.spacingSmall);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomRadioListTile(
          title: getString(
              context, "gdp_timesheet_add_appointment_schedules_action_manual"),
          value: TimesheetAddManualEnum.casual_schedule,
          groupValue: controller.selectedActionType,
          padding: padding,
          onChanged: (TimesheetAddManualEnum? value) {
            if (value == null) return;
            setState(() {
              controller.selectedActionType = value;
            });
          },
        ),
        CustomRadioListTile(
          title: getString(context,
              "gdp_timesheet_add_appointment_schedules_action_preselected"),
          value: TimesheetAddManualEnum.standard_schedule,
          groupValue: controller.selectedActionType,
          padding: padding,
          onChanged: (TimesheetAddManualEnum? value) {
            if (value == null) return;
            setState(() {
              controller.selectedActionType = value;
              controller.initalList();
            });
          },
        ),
        CustomRadioListTile(
          title: getString(
              context, "gdp_timesheet_add_appointment_schedules_action_lunch"),
          value: TimesheetAddManualEnum.lunch_schedule,
          groupValue: controller.selectedActionType,
          padding: padding,
          onChanged: (TimesheetAddManualEnum? value) {
            if (value == null) return;
            setState(() {
              controller.selectedActionType = value;
              controller.initalList();
            });
          },
        ),
      ],
    );
  }

  bool validForm() {
    if (controller.selectedActionType == null) return false;
    return true;
  }
}
