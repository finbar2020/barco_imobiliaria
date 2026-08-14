import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_failed_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_sucess_page.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_dropdown.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_info_button.dart';

class StaffAccessManagementEditPageArgs {
  final StaffAccessManagementController controller;
  final BuildingManagerUser buildingManagerUser;
  StaffAccessManagementEditPageArgs({
    required this.controller,
    required this.buildingManagerUser,
  });
}

class StaffAccessManagementEditPage extends StatefulWidget {
  const StaffAccessManagementEditPage({
    Key? key,
  }) : super(key: key);

  @override
  StaffAccessManagementEditPageState createState() =>
      StaffAccessManagementEditPageState();
}

class StaffAccessManagementEditPageState
    extends State<StaffAccessManagementEditPage> {
  late BuildingManagerUser buildingManagerUser;
  String? _selectAccessProfiles;
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as StaffAccessManagementEditPageArgs;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        title: getString(context, "staff_access_management_edit_appbar"),
        theme: theme,
      ),
      body: BlocConsumer(
        bloc: arguments.controller.bloc,
        listener: (context, state) {
          if (state is LoadedNonManagerUserState && state.addNonUserSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StaffAccessManagementSuccessPage(
                    controller: arguments.controller,
                    pageTitleText: 'staff_access_management_edit_success',
                  );
                },
              ),
            ).then((value) => arguments.controller.getBuildingManagerUsers(
                condoUserManageType: CondoUserManageType.otherUsers));
          }
          if (state is FailureNonManagerUserState && state.addNonUserError) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StaffAccessManagementFailedPage(
                    tryAgainFunction: () async {
                      await arguments.controller.putBuildingManagerUser();
                    },
                    controller: arguments.controller,
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingStaffAccessManagementState) {
            return const Center(
              child: LoadingWidget(),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(right: Dimens.spacingLarge),
                                child: SizedBox(
                                  width: 56.0,
                                  height: 56.0,
                                  child: SvgPicture.asset(
                                    "assets/user_placeholder.svg",
                                    width: 32,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  arguments.controller.getDisplayName(
                                      name:
                                          arguments.buildingManagerUser.name ??
                                              ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                  style: LelloTextStyles.subtitleBold(theme)!
                                      .copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(context, "cpf"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Text(
                            arguments.controller.formatCpf(
                                cpf: arguments.buildingManagerUser.cpf ?? ""),
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "e_mail"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Text(
                            arguments.buildingManagerUser.email ??
                                getString(context, "not_informed"),
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "cell_phone"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Text(
                            arguments.controller.formatCellPhoneNumber(
                                number:
                                    arguments.buildingManagerUser.phone ?? ""),
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Row(
                            children: [
                              Text(
                                getString(context,
                                    "staff_access_management_add_access_profile"),
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(width: Dimens.spacing),
                              Text(
                                getString(context,
                                    'staff_access_management_acess_type_required'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              )
                            ],
                          ),
                          StaffAccessManagementDropdown(
                            isNotRequired: true,
                            title: "",
                            value: _selectAccessProfiles ??
                                arguments.controller.getAccessTypeText(
                                    accessType: arguments
                                        .buildingManagerUser.accessType),
                            items: arguments.controller.accessProfiles,
                            onChanged: (value) {
                              setState(() {
                                _selectAccessProfiles = value;
                              });
                              reassemble();
                            },
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          StaffAccessManagementInfoButton(
                            title: getString(context,
                                "staff_access_management_add_info_access_profile"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AccessProfilesInfoDialog();
                                },
                              );
                            },
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                        ],
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: getString(context, "save"),
                    onPressed: _selectAccessProfiles != null
                        ? () async {
                            arguments.controller.editUser.accessType =
                                arguments.controller.setAccessType(
                                    accessType: _selectAccessProfiles!);
                            arguments.controller.editUser.id =
                                arguments.buildingManagerUser.id;
                            await arguments.controller.putBuildingManagerUser();
                          }
                        : null,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
