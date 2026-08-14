import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';

class SubUserServiceOffPage extends StatefulWidget {
  const SubUserServiceOffPage({Key? key}) : super(key: key);

  @override
  State<SubUserServiceOffPage> createState() => _SubUserServiceOffPageState();
}

class _SubUserServiceOffPageState extends State<SubUserServiceOffPage> {
  @override
  Widget build(BuildContext context) {
    final SubUserController controller =
        ApplicationContainer.instance().resolve<SubUserController>();
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: SizedBox(height: 100.0)),
                SvgPicture.asset("assets/ic_blocked_info.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, "residents_service_off_title"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Expanded(
                  child: Text(
                    getString(context, "residents_service_off_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                getString(context, "ok", defaultText: "OK"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                controller.getSubUsers();
                // args.controller.editSubUser(args.subUser);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
