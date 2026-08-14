import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

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
        _accept();
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/img_logo_colab.svg")),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Center(
                child: SvgPicture.asset("assets/ic_notification_bg.svg"),
              ),
              SizedBox(height: Dimens.spacing),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Text(
                  getString(context, "notification_permission_title"),
                  style: LelloTextStyles.title(theme)!.copyWith(
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
  }

  Widget buttons(ThemeData theme) {
    if (Platform.isIOS) {
      return status == PermissionStatus.permanentlyDenied
          ? _goToConfigurationsButton(theme)
          : _acceptRecusedButtons(theme);
    } else {
      return status == PermissionStatus.permanentlyDenied ||
              status == PermissionStatus.denied
          ? _goToConfigurationsButton(theme)
          : _acceptRecusedButtons(theme);
    }
  }

  Column _acceptRecusedButtons(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryButton(
          buttonColor: LelloTheme.palleteOf(theme).primary(),
          onPressed: () {
            _accept();
          },
          text: getString(context, "notification_permission_btn_accept"),
        ),
        TextButton(
          onPressed: () {
            _showHome();
          },
          child: Center(
            child:
                Text(getString(context, "notification_permission_btn_recused"),
                    style: LelloTextStyles.button(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).primary(),
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
          buttonColor: LelloTheme.palleteOf(theme).primary(),
          onPressed: () async {
            await openAppSettings();
          },
          text: getString(context, "notification_permission_br_configurations"),
        ),
        TextButton(
          onPressed: () {
            _showHome();
          },
          child: Center(
            child: Text(getString(context, "close"),
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                )),
          ),
        )
      ],
    );
  }

  void _showHome() {
    Navigator.pop(context);
  }

  _checkPermission() async {
    status = await Permission.notification.status;
  }

  _accept() async {
    var permission = await Permission.notification.status;
    if (permission != PermissionStatus.granted) {
      await Permission.notification.request();
    }
    _showHome();
  }
}
