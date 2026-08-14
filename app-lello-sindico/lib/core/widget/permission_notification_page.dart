import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart';

class PermissionNotificationPageArgs {
  final bool isGeneric;
  PermissionNotificationPageArgs({required this.isGeneric});
}

class PermissionNotificationPage extends StatefulWidget {
  const PermissionNotificationPage({Key? key}) : super(key: key);

  @override
  State<PermissionNotificationPage> createState() =>
      _PermissionNotificationPageState();
}

class _PermissionNotificationPageState extends State<PermissionNotificationPage>
    with WidgetsBindingObserver {
  PermissionStatus? status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _checkPermission();
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission().then((value) {
          if (status == PermissionStatus.granted) {
            _showHome(context);
          }
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as PermissionNotificationPageArgs;
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return BlocBuilder<SessionBloc, SessionState>(
      bloc: sessionBloc,
      builder: (context, state) {
        final session = state.session;
        final selectedCondominium = session?.selectedCondominium;
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).viewPadding.top),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: arguments.isGeneric
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: CachedNetworkImage(
                              height: 50.0,
                              width: 50.0,
                              imageUrl:
                                  selectedCondominium?.layout?.logoPath ?? "",
                              placeholder: (context, url) => Center(
                                  child: Padding(
                                padding: EdgeInsets.all(Dimens.spacingSmall),
                                child: const CircularProgressIndicator(),
                              )),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                "assets/logo-condominio_placeholder.svg",
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset("assets/img_logo_lello.png")),
                  ),
                  Center(
                    child: SvgPicture.asset("assets/ic_notification_bg.svg"),
                  ),
                  SizedBox(height: Dimens.spacing),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      getString(context, "notification_permission_title"),
                      style: LelloTextStyles.titleSmall(theme)!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, "notification_permission_subtitle"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).hubText(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: buttons(theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buttons(ThemeData theme) {
    if (Platform.isIOS) {
      return status == PermissionStatus.permanentlyDenied
          ? _goToConfigurationsButton(theme)
          : _acceptRecusedButtons(theme);
    } else {
      return status == PermissionStatus.permanentlyDenied
          ? _goToConfigurationsButton(theme)
          : _acceptRecusedButtons(theme);
    }
  }

  Column _acceptRecusedButtons(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryButton(
          onPressed: () {
            _accept();
          },
          text: getString(context, "notification_permission_btn_accept"),
        ),
        TextButton(
          onPressed: () {
            _showHome(context);
          },
          child: Center(
            child:
                Text(getString(context, "notification_permission_btn_recused"),
                    style: LelloTextStyles.button(theme)!.copyWith(
                      color: theme.primaryColor,
                    )),
          ),
        )
      ],
    );
  }

  Column _goToConfigurationsButton(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryButton(
          onPressed: () async {
            await openAppSettings();
          },
          text: getString(context, "notification_permission_br_configurations"),
        ),
        TextButton(
          onPressed: () {
            _showHome(context);
          },
          child: Center(
            child: Text(getString(context, "close"),
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: theme.primaryColor,
                )),
          ),
        )
      ],
    );
  }

  void _showHome(BuildContext context) {
    bool isRouteInStack = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == SharedApplicationRoute.home) {
        isRouteInStack = true;
        return true;
      }
      return false;
    });

    if (!isRouteInStack) {
      Navigator.pushNamed(context, SharedApplicationRoute.home);
    }
  }

  _checkPermission() async {
    status = await Permission.notification.status;
  }

  _accept() async {
    var permission = await Permission.notification.status;
    if (permission != PermissionStatus.granted) {
      await Permission.notification.request();
    }
    _showHome(context);
  }
}
