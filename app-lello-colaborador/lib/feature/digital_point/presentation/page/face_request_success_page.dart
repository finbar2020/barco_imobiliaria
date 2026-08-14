import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class FaceRequestSuccessPage extends StatelessWidget {
  const FaceRequestSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "face_request_success_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    )),
                SizedBox(height: Dimens.spacing),
                Text(getString(context, "face_request_success_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    )),
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
                getString(context, "ok"),
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              onPressed: () {
                sessionBloc.beginLoadSession();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
