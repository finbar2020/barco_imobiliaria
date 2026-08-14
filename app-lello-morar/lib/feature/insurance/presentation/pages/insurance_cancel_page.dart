import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class InsuranceCancelPage extends StatefulWidget {
  const InsuranceCancelPage({Key? key}) : super(key: key);

  @override
  _InsuranceCancelPageState createState() => _InsuranceCancelPageState();
}

class _InsuranceCancelPageState extends State<InsuranceCancelPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, "insurance_thanks_service"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).customColor()),
              ),
              SizedBox(height: Dimens.spacingMedium),
              SvgPicture.asset("assets/ic_blocked_info.svg",
                  width: 92, height: 92),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, "insurance_hiring_been_cancelled"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.headline(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).customColor()),
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
              SizedBox(height: Dimens.spacingMedium),
              Text(getString(context, "insurance_home_care_cancelled"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor())),
              SizedBox(height: Dimens.spacingMedium),
              Text(getString(context, "insurance_more_details_cancelled"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.caption(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor())),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
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
                getString(context, "finish"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.insurance);
              },
            ),
          ),
        ),
      ),
    );
  }
}
