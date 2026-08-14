import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class ChangeOwnershipSuccessPage extends StatefulWidget {
  const ChangeOwnershipSuccessPage({Key? key}) : super(key: key);

  @override
  State<ChangeOwnershipSuccessPage> createState() =>
      _ChangeOwnershipSuccessPageState();
}

class _ChangeOwnershipSuccessPageState
    extends State<ChangeOwnershipSuccessPage> {
  @override
  Widget build(BuildContext context) {
    SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "change_ownership_success_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, "change_ownership_success_subtitle"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: LelloTheme.palleteOf(theme).customColor()),
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
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(SharedApplicationRoute.home));
              },
            ),
          ),
        ),
      ),
    );
  }
}
