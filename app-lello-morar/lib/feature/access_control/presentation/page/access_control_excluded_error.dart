import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';

class AccessControlExcludedErrorPage extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final AccessControl accessControl;
  final AccessControlAuthorizations model;
  final bool isVisitant;
  final bool isGeneric;
  const AccessControlExcludedErrorPage({
    Key? key,
    required this.accessControlStore,
    required this.accessControl,
    required this.model,
    required this.isVisitant,
    required this.isGeneric,
  }) : super(key: key);

  @override
  State<AccessControlExcludedErrorPage> createState() =>
      _AccessControlExcludedErrorPageState();
}

class _AccessControlExcludedErrorPageState
    extends State<AccessControlExcludedErrorPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          ApplicationRoute.accessControl,
          arguments: AcessControlPageArgs(isGeneric: widget.isGeneric),
        );
        return true;
      },
      child: Theme(
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
                    widget.isVisitant
                        ? getString(
                            context, "access_control_failed_excluded_visitor")
                        : getString(
                            context, "access_control_failed_excluded_provider"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Expanded(
                    child: Text(
                      getString(context, "error_unknown"),
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
                  getString(context, "try_again"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  widget.accessControlStore.editVisitant(
                      visitant: widget.accessControl,
                      authorizations: widget.model);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessControlAppointmentsPage(
                            accessControlStore: widget.accessControlStore,
                            isGeneric: widget.isGeneric,
                            accessControl: widget.accessControl),
                      ));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
