import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlAttentionPage extends StatefulWidget {
  const AccessControlAttentionPage({Key? key}) : super(key: key);

  @override
  _AccessControlAttentionPageState createState() =>
      _AccessControlAttentionPageState();
}

class _AccessControlAttentionPageState
    extends State<AccessControlAttentionPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    String title = arguments as String;
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
                  getString(context, title),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Expanded(
                  child: Text(
                    '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
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
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.accessControl);
              },
            ),
          ),
        ),
      ),
    );
  }
}
