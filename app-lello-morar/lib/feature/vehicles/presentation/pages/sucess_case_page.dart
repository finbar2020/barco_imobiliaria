import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

class VehicleSucessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: LelloTheme.palleteOf(theme).success(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 140.0),
              child: Center(
                child: Container(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.check_circle,
                      color: LelloTheme.palleteOf(theme).customColor(),
                      size: 150,
                    )),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  getString(context, "me_vehicles_add_success"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: LelloTheme.palleteOf(theme).customColor(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            BlocBuilder<SessionBloc, SessionState>(
              bloc: sessionBloc,
              builder: (context, state) {
                return Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${sessionBloc.state.session?.condominium?.name ?? ""} - ${sessionBloc.state.session?.unity?.title ?? ""}',
                      style: TextStyle(
                        fontSize: 15,
                        color: LelloTheme.palleteOf(theme).customColor(),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: Dimens.spacingLarge,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                ),
                child: Container(
                  width: 312,
                  height: 60,
                  child: Center(
                      child: Text(
                    getString(context, "conclude"),
                    style: TextStyle(
                      fontSize: 20,
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  )),
                ),
                onPressed: () async {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    AppReview.call(context: context);
                    Navigator.pushReplacementNamed(
                        context, ApplicationRoute.vehiclePage);
                  });
                })
          ]),
    );
  }
}
