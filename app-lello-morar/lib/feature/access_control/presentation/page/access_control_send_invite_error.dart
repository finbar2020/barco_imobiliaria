import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';

class AccessControlSendInviteErrorPage extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final AccessControl accessControl;
  final AccessControlAuthorizations model;
  final bool isEdit;
  final bool isGeneric;
  const AccessControlSendInviteErrorPage({
    Key? key,
    required this.accessControlStore,
    required this.accessControl,
    required this.model,
    required this.isEdit,
    required this.isGeneric,
  }) : super(key: key);

  @override
  State<AccessControlSendInviteErrorPage> createState() =>
      _AccessControlSendInviteErrorPageState();
}

class _AccessControlSendInviteErrorPageState
    extends State<AccessControlSendInviteErrorPage> {
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
                    getString(context, "access_control_invite_error_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Expanded(
                    child: Text(
                      getString(
                          context, "access_control_invite_error_subtitle"),
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

                  Navigator.pushReplacementNamed(
                      context, ApplicationRoute.accessControlInsert,
                      arguments: AccessControlInsertPageArgs(
                        accessControlStore: widget.accessControlStore,
                        authorization: widget.model,
                        isEdit: widget.isEdit,
                        isGeneric: widget.isGeneric,
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
