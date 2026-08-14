import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AgreementsSuccessPage extends StatelessWidget {
  const AgreementsSuccessPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    late AgreementsBloc bloc;
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    return WillPopScope(
      onWillPop: () async {
        bloc.goToAgreements(AgreementCreated());
        Navigator.popUntil(
            context, ModalRoute.withName(ApplicationRoute.agreements));
        return true;
      },
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      child: Icon(
                        Icons.check_circle,
                        color: LelloTheme.palleteOf(theme).customColor(),
                        size: 150,
                      )),
                ),
                SizedBox(height: Dimens.spacing),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      getString(context, "agreements_send_proposal"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: LelloTheme.palleteOf(theme).customColor(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${sessionBloc.state.session?.condominium?.name ?? ""} - ${sessionBloc.state.session?.unity?.title ?? ""}',
                      style: TextStyle(
                        fontSize: 15,
                        color: LelloTheme.palleteOf(theme).separator(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      getString(context, "agreements_description_success"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: LelloTheme.palleteOf(theme).customColor(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.homeBalanceHeightCollapsed),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          LelloTheme.palleteOf(theme).customColor(),
                    ),
                    child: Container(
                      height: 52.0,
                      child: Center(
                          child: Text(
                        getString(context, "conclude"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      )),
                    ),
                    onPressed: () {
                      bloc.goToAgreements(AgreementCreated());
                      AppReview.call(context: context);
                      Navigator.popUntil(context,
                          ModalRoute.withName(ApplicationRoute.agreements));
                    })
              ]),
        ),
      ),
    );
  }
}
