import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_sucess_page.dart';

class StaffAccessManagementFailedPage extends StatefulWidget {
  final StaffAccessManagementController controller;
  final VoidCallback tryAgainFunction;
  const StaffAccessManagementFailedPage(
      {Key? key, required this.controller, required this.tryAgainFunction})
      : super(key: key);

  @override
  State<StaffAccessManagementFailedPage> createState() =>
      _StaffAccessManagementFailedPageState();
}

class _StaffAccessManagementFailedPageState
    extends State<StaffAccessManagementFailedPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).warning(),
          body: BlocConsumer(
            bloc: widget.controller.bloc,
            listener: (context, state) {
              if (state is LoadedNonManagerUserState &&
                  state.addNonUserSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return StaffAccessManagementSuccessPage(
                        controller: widget.controller,
                        pageTitleText: 'staff_access_management_edit_success',
                      );
                    },
                  ),
                ).then(
                  (value) => widget.controller.getBuildingManagerUsers(
                      condoUserManageType: CondoUserManageType.otherUsers),
                );
              }
            },
            builder: (context, state) {
              bool isLoading = state is LoadingStaffAccessManagementState;
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingLarge),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        child: SizedBox(height: 100.0),
                      ),
                      SvgPicture.asset("assets/ic_blocked_info.svg",
                          width: 92, height: 92),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(
                        getString(
                            context, "staff_access_management_error_title"),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).customColor()),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Expanded(
                        child: Text(
                          getString(context,
                              "staff_access_management_error_subtitle"),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).customColor()),
                        ),
                      ),
                      SizedBox(
                        height: 54.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            disabledForegroundColor: LelloTheme.palleteOf(theme)
                                .customColor()
                                .withOpacity(1),
                            disabledBackgroundColor: LelloTheme.palleteOf(theme)
                                .customColor()
                                .withOpacity(1),
                            backgroundColor:
                                LelloTheme.palleteOf(theme).customColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  widget.tryAgainFunction();
                                },
                          child: isLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        LelloTheme.palleteOf(theme).primary(),
                                      ),
                                    ),
                                    SizedBox(width: Dimens.spacing),
                                    Text(
                                      getString(context, "resending"),
                                      style: TextStyle(
                                        color:
                                            LelloTheme.palleteOf(theme).text(),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  getString(context, "try_again"),
                                  style:
                                      LelloTextStyles.button(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme).text(),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      SizedBox(
                        height: 54.0,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                              color: LelloTheme.palleteOf(theme).customColor(),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  widget.controller.backToList();
                                  Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        ApplicationRoute.staffAccessManagement),
                                  );
                                },
                          child: Text(
                            getString(context, "cancel"),
                            style: LelloTextStyles.button(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).customColor(),
                            ),
                          ),
                        ),
                      ),
                    ],
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
