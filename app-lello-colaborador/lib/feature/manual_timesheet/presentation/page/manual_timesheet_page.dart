import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_bloc.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_state.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/widgets/manual_timesheet_document_form.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ManualTimeSheetPage extends StatefulWidget {
  const ManualTimeSheetPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ManualTimeSheetPage> createState() => _ManualTimeSheetPageState();
}

class _ManualTimeSheetPageState extends State<ManualTimeSheetPage> {
  late ManualTimeSheetBloc bloc;

  ManualTimeSheetEntity manualTimeSheet = ManualTimeSheetEntity();

  @override
  void initState() {
    super.initState();
    bloc = ApplicationContainer.instance().resolve();
  }

  @override
  Widget build(BuildContext context) {
    var fileMaxSizePermitted = _getFileMaxSizePermitted(context);
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<ManualTimeSheetBloc, ManualTimeSheetState>(
        listener: (context, state) {
          if (state is ManualTimeSheetRegisterFailedState) {
            Navigator.pushNamed(
              context,
              ApplicationRoute.manualTimesheetRegisterError,
            );
          } else if (state is ManualTimeSheetRegisterLoadedState) {
            Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.manualTimesheetRegisterSuccess,
            );
          }
        },
        builder: (context, state) {
          if (state is ManualTimeSheetLoadingState) {
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: Theme(
              data: theme,
              child: Scaffold(
                appBar: const CustomAppBar(title: "manual_timesheet_title"),
                body: _manualTimeSheetPageBody(
                    fileMaxSizePermitted: fileMaxSizePermitted),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _manualTimeSheetPageBody({required int fileMaxSizePermitted}) {
    return ManualTimeSheetWidget(
      manualTimeSheet: manualTimeSheet,
      sendManualTimeSheetFunction: () {
        bloc.sendManualTimeSheet(
            date: manualTimeSheet.date!, file: manualTimeSheet.file!);
      },
      maxFileSizePermitted: fileMaxSizePermitted,
      availableDates: bloc.listOfMonths,
    );
  }

  static _getFileMaxSizePermitted(BuildContext context) {
    SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
    int defaultValue = 10485760;
    try {
      if (remoteConfig != null) {
        var fileMaxSizePermitted = jsonDecode(remoteConfig
            .getString(CustomFirebaseRemoteConfig.fileMaxSizePermitted));
        return fileMaxSizePermitted ?? defaultValue;
      }
    } catch (err) {
      return defaultValue;
    }
    return defaultValue;
  }
}
