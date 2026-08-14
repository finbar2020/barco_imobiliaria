import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_failed_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_sucess_page.dart';

class ExcludeProfileDialog extends StatefulWidget {
  final BuildingManagerUser user;
  const ExcludeProfileDialog({super.key, required this.user});

  @override
  State<ExcludeProfileDialog> createState() => _ExcludeProfileDialogState();
}

class _ExcludeProfileDialogState extends State<ExcludeProfileDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = ApplicationContainer.instance()
        .resolve<StaffAccessManagementController>();

    final theme = Theme.of(context);
    return BlocListener(
      bloc: controller.bloc,
      listener: (context, state) {
        if (state is SuccessNonManagerUserState) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StaffAccessManagementSuccessPage(
                  controller: controller,
                  pageTitleText: 'staff_access_management_remove_success',
                );
              },
            ),
          );
        }
        if (state is FailureNonManagerUserState) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StaffAccessManagementFailedPage(
                  tryAgainFunction: () => controller.deactivateUser(
                    condominiumId: controller.condominiumId!,
                    userId: widget.user.id!,
                    isActive: false,
                  ),
                  controller: controller,
                );
              },
            ),
          );
        }
      },
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing,
          vertical: Dimens.spacingMedium,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingLarge,
            vertical: Dimens.spacingLarge,
          ),
          child: Builder(builder: (context) {
            if (isLoading) {
              return const LoadingWidget();
            }
            return Column(
              children: [
                SvgPicture.asset(
                  "assets/ic_exclamation.svg",
                  //color: LelloTheme.palleteOf(theme).textOpaque(),
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(
                    context,
                    "advance_request_warning_title",
                  ),
                  style: LelloTextStyles.titleSmallBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(
                    context,
                    "staff_access_exclude_profile_message",
                  ),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textOpaque(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    TextSpan(
                      text: getString(
                        context,
                        "staff_access_exclude_profile_confirmation",
                      ),
                      style: LelloTextStyles.subtitle(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                    ),
                    TextSpan(
                      text: " ${widget.user.name}",
                      style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          getString(context, "no"),
                          style:
                              LelloTextStyles.titleSmallBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).textOpaque(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await controller.deactivateUser(
                            condominiumId: controller.condominiumId!,
                            userId: widget.user.id!,
                            isActive: false,
                          );
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text(
                          getString(context, "yes"),
                          style:
                              LelloTextStyles.titleSmallBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
