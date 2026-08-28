import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlExcludedSuccessPage extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final bool isVisitant;
  final bool isGeneric;
  const AccessControlExcludedSuccessPage({
    Key? key,
    required this.accessControlStore,
    required this.isGeneric,
    this.isVisitant = false,
  }) : super(key: key);

  @override
  State<AccessControlExcludedSuccessPage> createState() =>
      _AccessControlExcludedSuccessPageState();
}

class _AccessControlExcludedSuccessPageState
    extends State<AccessControlExcludedSuccessPage> {
  SessionBloc sessionBloc = ApplicationContainer.instance().resolve();
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
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SvgPicture.asset("assets/ic_success.svg",
                        width: 92, height: 92),
                  ),
                  Text(
                      widget.isVisitant
                          ? getString(context, "access_control_deleted_visitor")
                          : getString(
                              context, "access_control_deleted_service"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                  Text(
                    '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.condominium?.reference ?? ''}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 54.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            getString(context, "conclude"),
                            style: LelloTextStyles.button(theme)!
                                .copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              ApplicationRoute.accessControl,
                              arguments: AcessControlPageArgs(
                                isGeneric: widget.isGeneric,
                                tabIndex: widget.isVisitant ? 0 : 1,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
