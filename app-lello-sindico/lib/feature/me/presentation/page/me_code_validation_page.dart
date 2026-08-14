import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/dependency/application_container.dart';
import '../bloc/me_state.dart';

enum MeCodeValidationPageResult { success, failure, cancel, restart }

class MeCodeValidationPage extends StatelessWidget {
  const MeCodeValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ApplicationContainer.instance().resolve<MeController>();

    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(MeCodeValidationPageResult.cancel);
        return false;
      },
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "profile_title"),
          theme: theme,
          actions: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: Dimens.spacing),
                child: Text(
                  "${controller.lastGetMeUpdateDifference}${controller.lastSwitchRolesUpdateDifference}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: LelloTheme.palleteOf(theme).grey(), fontSize: 10),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: BlocBuilder(
            bloc: controller.meBloc,
            builder: (context, state) {
              if (state is MeEditLoadingState) {
                return const Center(
                  child: LoadingWidget(),
                );
              }
              return CodeValidationPage(
                appContainer: ApplicationContainer.instance(),
                codeRequest: controller.codeRequest!,
                digits: (controller.codeRequest?.token.isEmpty ?? false) ? 6 : 4,
                onRestart: () {
                  Navigator.of(context).pop(MeCodeValidationPageResult.restart);
                },
                onSuccess: (validation) {
                  Navigator.of(context).pop(MeCodeValidationPageResult.success);
                  controller.saveAccount(codeValidation: validation);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
