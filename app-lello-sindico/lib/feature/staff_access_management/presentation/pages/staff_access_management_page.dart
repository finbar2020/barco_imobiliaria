import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_add_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_edit_page.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/building_manager_user_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/exclude_profile_dialog.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_add_new_user_bottom.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class StaffAccessManagementPage extends StatefulWidget {
  const StaffAccessManagementPage({super.key});

  @override
  State<StaffAccessManagementPage> createState() =>
      _StaffAccessManagementPageState();
}

class _StaffAccessManagementPageState extends State<StaffAccessManagementPage> {
  final StaffAccessManagementController controller =
      ApplicationContainer.instance()
          .resolve<StaffAccessManagementController>();

  @override
  void initState() {
    controller.getBuildingManagerUsers(
        condoUserManageType: CondoUserManageType.otherUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "staff_access_management_page_title"),
          theme: theme,
        ),
        body: BlocBuilder(
          bloc: controller.bloc,
          builder: (context, state) {
            if (state is LoadingStaffAccessManagementState) {
              return const Center(
                child: LoadingWidget(),
              );
            }
            if (state is FailureNonManagerUserState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: ErrorHandlingWidget(
                  reTryFunction: () {
                    controller.getBuildingManagerUsers(
                        condoUserManageType: CondoUserManageType.otherUsers);
                  },
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: controller.env.isProduction,
                  error: state.failure?.error.toString() ?? "",
                  errorCode: state.failure?.code.toString() ?? "",
                ),
              );
            }
            if (state is LoadedNonManagerUserState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Column(
                  children: [
                    Text(
                      getString(
                          context, "staff_access_management_page_sub_title"),
                      style: LelloTextStyles.body(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Expanded(
                      child: state.buildingManagerUsers.isEmpty
                          ? Center(
                              child: Text(
                                getString(context,
                                    "staff_access_management_users_empty"),
                                style: TextStyle(
                                    color: LelloTheme.palleteOf(theme).text(),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.buildingManagerUsers.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(height: 1),
                              itemBuilder: (BuildContext context, int index) {
                                final user = state.buildingManagerUsers[index];
                                return BuildingManagerUserCardWidget(
                                  buildingManagerUser: user,
                                  controller: controller,
                                  updateUserFunction: () {
                                    Navigator.pushNamed(
                                      context,
                                      ApplicationRoute
                                          .staffAccessManagementEdit,
                                      arguments:
                                          StaffAccessManagementEditPageArgs(
                                              controller: controller,
                                              buildingManagerUser: state
                                                  .buildingManagerUsers[index]),
                                    );
                                  },
                                  deleteUserFunction: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ExcludeProfileDialog(user: user),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: SizedBox(
          height: Dimens.homeBalanceHeightCollapsed,
          width: double.infinity,
          child: BlocBuilder(
            bloc: controller.bloc,
            builder: (context, state) {
              if (state is LoadingStaffAccessManagementState) {
                return Container();
              }
              return Center(
                child: CircuitBreakerWidget(
                  reference: controller.sessionBloc.state.session
                          ?.selectedCondominium?.reference ??
                      "",
                  appContainer: ApplicationContainer.instance(),
                  applicationRbac: ApplicationRbac.sindicoGestaoAcessos,
                  rbacEnabled: controller.sessionBloc
                      .checkRback(ApplicationRbac.sindicoGestaoAcessos),
                  child: StaffAccessManagementAddNewUserBottom(
                    title: getString(context, "add_user"),
                    onTap: () {
                      Navigator.pushNamed(
                          context, ApplicationRoute.staffAccessManagementAdd,
                          arguments: StaffAccessManagementAddPageArgs(
                              controller: controller));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
