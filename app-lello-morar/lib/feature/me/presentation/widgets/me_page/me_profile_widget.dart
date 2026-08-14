import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/app_version_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_buttons_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';

class MeProfileWidget extends StatefulWidget {
  final bool isGeneric;
  final Function(ThemeData)? changeTheme;
  const MeProfileWidget({
    Key? key,
    this.isGeneric = false,
    this.changeTheme,
  }) : super(key: key);

  @override
  _MeProfileWidgetState createState() => _MeProfileWidgetState();
}

class _MeProfileWidgetState extends State<MeProfileWidget> {
  final MeController controller =
      ApplicationContainer.instance().resolve<MeController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    MeBloc meBloc = BlocProvider.of(context);
    Me? me = meBloc.state.me;

    Column(
      children: [
        Expanded(
            child: Center(
          child: Text(
            getString(context, "unable_to_load"),
            style: LelloTextStyles.body(theme),
          ),
        )),
        Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: TertiaryButton(
              style: TextStyle(
                color: theme.primaryColor,
              ),
              text: getString(context, "logout"),
              onPressed: () {
                _logout();
              }),
        )
      ],
    );

    if (me.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  controller.meLoad();
                },
                backFunction: () => Navigator.pop(context, true),
                isProduction: env.isProduction,
                error: "",
                errorCode: "",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
            child: TertiaryButton(
                style: TextStyle(
                  color: theme.primaryColor,
                ),
                text: getString(context, "logout"),
                onPressed: () {
                  _logout();
                }),
          )
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: AppVersionWidget(),
            ),
            MeProfilePictureWidget(
              controller: controller,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Center(
              child: Text(
                me.name ?? "",
                style: LelloTextStyles.headline(theme),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: TertiaryButton(
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                  text: getString(context, "logout"),
                  onPressed: () {
                    _logout();
                  }),
            ),
            SizedBox(height: Dimens.spacingMedium),
            MeProfileInfoWidget(
              me: me,
              isGeneric: widget.isGeneric,
              changeTheme: widget.changeTheme,
            ),
            SizedBox(height: Dimens.spacingMedium),
            MeProfileButtonsWidget(
              beginEditFunction: () => controller.beginEdit(),
              deleteFunction: () => controller.deleteMe(me),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _setDate() async {
    final _key = "AGREEMENTS_DIALOG_DATE_CHECK";
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  void _logout() {
    _setDate();
    controller.logOutEvent();
  }
}
