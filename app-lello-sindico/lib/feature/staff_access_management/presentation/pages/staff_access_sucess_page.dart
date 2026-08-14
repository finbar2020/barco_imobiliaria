import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';

class StaffAccessManagementSuccessPage extends StatefulWidget {
  final StaffAccessManagementController controller;
  final String pageTitleText;
  const StaffAccessManagementSuccessPage(
      {Key? key, required this.controller, required this.pageTitleText})
      : super(key: key);

  @override
  State<StaffAccessManagementSuccessPage> createState() =>
      _StaffAccessManagementSuccessPageState();
}

class _StaffAccessManagementSuccessPageState
    extends State<StaffAccessManagementSuccessPage> {
  @override
  Widget build(BuildContext context) {
    SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, widget.pageTitleText),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.headline(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).customColor(),
                  ),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${sessionBloc.state.session?.selectedCondominium?.name ?? ''} - ${sessionBloc.state.session?.selectedCondominium?.reference ?? ''}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SizedBox(
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                widget.controller.getBuildingManagerUsers(
                    condoUserManageType: CondoUserManageType.otherUsers);
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        ApplicationRoute.staffAccessManagement));
              },
            ),
          ),
        ),
      ),
    );
  }
}
