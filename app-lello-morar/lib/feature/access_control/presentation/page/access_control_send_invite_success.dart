import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlSendInviteSuccessPage extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final bool isVisitant;
  final bool useFacialBiometric;
  final bool isGeneric;
  const AccessControlSendInviteSuccessPage({
    Key? key,
    required this.accessControlStore,
    required this.isGeneric,
    this.isVisitant = false,
    this.useFacialBiometric = false,
  }) : super(key: key);

  @override
  State<AccessControlSendInviteSuccessPage> createState() =>
      _AccessControlSendInviteSuccessPageState();
}

class _AccessControlSendInviteSuccessPageState
    extends State<AccessControlSendInviteSuccessPage> {
  SessionBloc sessionBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          ApplicationRoute.accessControl,
          arguments: AcessControlPageArgs(
            tabIndex: widget.isVisitant ? 0 : 1,
            isGeneric: widget.isGeneric,
          ),
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
                          ? getString(context,
                              "access_control_invite_visitant_success_title")
                          : getString(context,
                              "access_control_invite_provider_success_title"),
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
                  if (widget.useFacialBiometric)
                    Text(
                      widget.isVisitant
                          ? getString(context,
                              "access_control_invite_visitant_success_subtitle")
                          : getString(context,
                              "access_control_invite_provider_success_subtitle"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor()),
                    ),
                  Column(
                    children: [
                      if (widget.useFacialBiometric)
                        Container(
                          height: 54.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  LelloTheme.palleteOf(theme).customColor(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              getString(context, "accesss_control_copy_link"),
                              style: LelloTextStyles.button(theme)!.copyWith(
                                  color: LelloTheme.palleteOf(theme).text()),
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: (widget.accessControlStore.bloc
                                                      .state
                                                  as SaveVisitantLoadedState)
                                              .link ??
                                          ""))
                                  .then((value) {
                                return Flushbar(
                                  duration: Duration(seconds: 1),
                                  message: getString(
                                      context, "accesss_control_copied_link"),
                                )..show(context)
                                    .then((value) => Navigator.pop(context));
                              });
                            },
                          ),
                        ),
                      if (widget.useFacialBiometric)
                        SizedBox(height: Dimens.spacing),
                      if (widget.useFacialBiometric)
                        Container(
                          height: 54.0,
                          width: double.infinity,
                          child: Builder(
                            builder: (buttonContext) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    LelloTheme.palleteOf(theme).customColor(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                getString(context, "accesss_control_share_link"),
                                style: LelloTextStyles.button(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme).text()),
                              ),
                              onPressed: () {
                                final box = buttonContext.findRenderObject() as RenderBox?;
                                final rect = box != null
                                    ? box.localToGlobal(Offset.zero) & box.size
                                    : null;
                                shareText((widget.accessControlStore.bloc.state
                                        as SaveVisitantLoadedState)
                                    .link!, sharePositionOrigin: rect);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      SizedBox(height: Dimens.spacing),
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
                                tabIndex: widget.isVisitant ? 0 : 1,
                                isGeneric: widget.isGeneric,
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
