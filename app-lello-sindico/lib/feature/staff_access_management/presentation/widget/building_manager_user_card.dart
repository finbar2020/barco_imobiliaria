import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class BuildingManagerUserCardWidget extends StatelessWidget {
  final BuildingManagerUser buildingManagerUser;
  final StaffAccessManagementController controller;
  final VoidCallback updateUserFunction;
  final VoidCallback deleteUserFunction;

  const BuildingManagerUserCardWidget({
    Key? key,
    required this.buildingManagerUser,
    required this.controller,
    required this.updateUserFunction,
    required this.deleteUserFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: Dimens.homeBalanceHeightCollapsed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: SvgPicture.asset("assets/user_placeholder.svg", width: 32),
          ),
          SizedBox(width: Dimens.spacing),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.getDisplayName(name: buildingManagerUser.name!),
                  softWrap: true,
                  maxLines: 2,
                  style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
                Text(
                  getString(
                    context,
                    controller.getAccessTypeText(
                        accessType: buildingManagerUser.accessType),
                  ),
                  softWrap: true,
                  maxLines: 2,
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircuitBreakerWidget(
                  reference:
                      sessionBloc.state.session?.selectedCondominium?.id ?? "",
                  appContainer: ApplicationContainer.instance(),
                  applicationRbac: ApplicationRbac.sindicoGestaoBiometria,
                  rbacEnabled: sessionBloc
                      .checkRback(ApplicationRbac.sindicoGestaoBiometria),
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    color: LelloTheme.palleteOf(theme).primary(),
                    onPressed: () {
                      updateUserFunction();
                    },
                  ),
                ),
                CircuitBreakerWidget(
                  reference: sessionBloc
                          .state.session?.selectedCondominium?.reference ??
                      "",
                  appContainer: ApplicationContainer.instance(),
                  applicationRbac: ApplicationRbac.sindicoGestaoBiometria,
                  rbacEnabled: sessionBloc
                      .checkRback(ApplicationRbac.sindicoGestaoBiometria),
                  child: IconButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    color: LelloTheme.palleteOf(theme).primary(),
                    onPressed: () {
                      deleteUserFunction();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
