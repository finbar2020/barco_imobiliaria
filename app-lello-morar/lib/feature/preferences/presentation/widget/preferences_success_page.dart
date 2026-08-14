import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class PreferencesSuccessPage extends StatelessWidget {
  final bool isEdit;
  final bool newVisit;
  final bool isDeleteVisit;
  final bool isVisitant;
  const PreferencesSuccessPage({
    Key? key,
    this.isEdit = false,
    this.newVisit = false,
    this.isDeleteVisit = false,
    this.isVisitant = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
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
                SizedBox(height: 100.0),
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "preferences_success"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
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
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(SharedApplicationRoute.home));
              },
            ),
          ),
        ),
      ),
    );
  }
}
