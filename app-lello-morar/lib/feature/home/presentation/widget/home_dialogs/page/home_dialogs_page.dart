import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';

class HomeDialogsWidget extends StatefulWidget {
  const HomeDialogsWidget({Key? key}) : super(key: key);

  @override
  State<HomeDialogsWidget> createState() => _HomeDialogsWidgetState();
}

class _HomeDialogsWidgetState extends State<HomeDialogsWidget> {
  final dialogBloc = ApplicationContainer.instance().resolve<HomeDialogBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: dialogBloc,
      listener: (context, state) {
        if (state is NeedsUpdateState) {
          AppUpdateConfig.showDialogUpDate(
              context: context,
              appOriginEnum: state.appOriginEnum,
              continueSplashAction: () {},
              criticalUpdateRequired:
                  state.needsUpdate == NeedsUpdate.mandatory,
              dismissAction: () {
                dialogBloc.initialState();
              });
        }
      },
    );
  }
}
