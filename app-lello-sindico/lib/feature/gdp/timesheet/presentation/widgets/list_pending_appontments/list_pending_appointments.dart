import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/list_pending_appointments_controller.dart';

class ListPendingAppointments extends StatefulWidget {
  final TimesheetOccurrenceEntity ocorrence;

  const ListPendingAppointments({
    super.key,
    required this.ocorrence,
  });

  @override
  State<ListPendingAppointments> createState() =>
      _ListPendingAppointmentsState();
}

class _ListPendingAppointmentsState extends State<ListPendingAppointments> {
  ListPendingAppointmentsController controller = ApplicationContainer.instance()
      .resolve<ListPendingAppointmentsController>();

  @override
  void initState() {
    super.initState();
    controller.setOcurrence(widget.ocorrence);
    controller.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<TimesheetListPendingAppointmentsBloc,
        TimesheetListPendingAppointmentState>(
      bloc: controller.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TimesheetListPendingAppointmentFailedState) {
          return Column(
            children: [
              _buildHeadder(context),
              SizedBox(height: Dimens.spacingSmall),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getString(context,
                          "gdp_timesheet_add_appointment_pending_error"),
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(context,
                          "gdp_timesheet_add_appointment_pending_retry"),
                      style: LelloTextStyles.button(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).accent()),
                    ),
                  ],
                ),
                onTap: () => controller.getAppointments(),
              ),
              SizedBox(height: Dimens.spacing),
            ],
          );
        } else if (state is TimesheetListPendingAppointmentLoadedState) {
          if (state.appointments.isEmpty) return Container();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadder(context),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                state.appointments.join(" | "),
                textAlign: TextAlign.left,
                style: LelloTextStyles.bodyBold(theme)!.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: Dimens.spacing),
            ],
          );
        } else if (state is TimesheetListPendingAppointmentLoadingState) {
          double containerWidth = 220.0;
          double containerHeight = 10.0;
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5.0),
                Container(
                  height: containerHeight,
                  width: containerWidth * 0.75,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Row _buildHeadder(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${getString(context, "gdp_timesheet_add_appointment_pending_title")}:",
          style: LelloTextStyles.body(theme)!.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 4),
          message: getString(
              context, "gdp_timesheet_add_appointment_pending_tooltip"),
          child: const Icon(
            Icons.info_outline,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double containerWidth = 220.0;
    double containerHeight = 10.0;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 80.0,
                  color: Colors.grey,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
