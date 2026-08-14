import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_bloc.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_event.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_state.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_failed_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_success_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SyncDigitalPointsDialog {
  static Future<void> show(
    BuildContext context,
    List<DigitalPointEntity> digitalPoints,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SyncDigitalPointsDialogWidget(digitalPoints: digitalPoints);
        });
  }
}

class SyncDigitalPointsDialogWidget extends StatefulWidget {
  final List<DigitalPointEntity> digitalPoints;
  const SyncDigitalPointsDialogWidget({
    Key? key,
    required this.digitalPoints,
  }) : super(key: key);

  @override
  State<SyncDigitalPointsDialogWidget> createState() =>
      _SyncDigitalPointsDialogWidgetState();
}

class _SyncDigitalPointsDialogWidgetState
    extends State<SyncDigitalPointsDialogWidget> {
  @override
  Widget build(BuildContext context) {
    SyncDigitalPointsBloc syncDigitalPointsBloc =
        ApplicationContainer.instance().resolve();

    return BlocBuilder<SyncDigitalPointsBloc, SyncDigitalPointsState>(
      bloc: syncDigitalPointsBloc,
      builder: (context, state) {
        if (state is SyncDigitalPointsLoadingState) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: const LoadingWidget(),
            ),
          );
        }
        if (state is SyncDigitalPointsSuccessState) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: const SyncSuccessWidget(),
            ),
          );
        }
        if (state is SyncDigitalPointsBlockedState) {
          return DeviceTypeDialog(
            onlyTablet: state.onlyTablet,
            onlyPhone: state.onlyPhone,
          );
        }
        if (state is SyncDigitalPointsFailedState) {
          if (state.code ==
              DigitalPointRegisterFailure.onWorkLeaveNotAccepted) {
            return AfastamentoDialog(workLeaveDescription: state.message!);
          }
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: SyncFailedWidget(
                digitalPoints: state.failedDigitalPoints,
                syncFunction: (digitalPoints) => syncDigitalPointsBloc.add(
                  SyncPointsEvent(
                    digitalPoints: digitalPoints,
                  ),
                ),
              ),
            ),
          );
        }
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: SyncWidget(
              digitalPoints: widget.digitalPoints,
              syncFunction: (digitalPoints) => syncDigitalPointsBloc.add(
                SyncPointsEvent(
                  digitalPoints: digitalPoints,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
