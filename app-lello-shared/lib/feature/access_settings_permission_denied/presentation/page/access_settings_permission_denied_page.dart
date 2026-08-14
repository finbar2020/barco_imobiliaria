import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/shared_features.dart';

class AcessSettingsPermissionDeniedPageArgs {
  final AcessSettingsPermissionsDeniedItem acessSettingsPermissionsDeniedItem;
  AcessSettingsPermissionDeniedPageArgs(
      {required this.acessSettingsPermissionsDeniedItem});
}

class AcessSettingsPermissionDeniedPage extends StatefulWidget {
  const AcessSettingsPermissionDeniedPage({Key? key}) : super(key: key);

  @override
  State<AcessSettingsPermissionDeniedPage> createState() =>
      _AcessSettingsPermissionDeniedPageState();
}

class _AcessSettingsPermissionDeniedPageState
    extends State<AcessSettingsPermissionDeniedPage>
    with WidgetsBindingObserver {
  late AcessSettingsPermissionsDeniedItem _itemArgs;
  bool _shouldCheckPermissionsOnResume = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldCheckPermissionsOnResume) {
      _shouldCheckPermissionsOnResume = false;
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = LelloTheme.light;

    AcessSettingsPermissionDeniedPageArgs _args = ModalRoute.of(context)
        ?.settings
        .arguments as AcessSettingsPermissionDeniedPageArgs;
    _itemArgs = _args.acessSettingsPermissionsDeniedItem;

    // Usa tema apropriado baseado no tipo de app
    final appTheme =
        _itemArgs.isColaboradorApp ? LelloTheme.carimbeira : _theme;

    log(_itemArgs.item.toString());
    return Theme(
      data: appTheme,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  _itemArgs.icon,
                  height: 128.0,
                  width: 128.0,
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, _itemArgs.titleKey),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.title(appTheme)?.copyWith(
                    color: LelloTheme.palleteOf(appTheme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(context, _itemArgs.subTitleKey),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(appTheme)?.copyWith(
                    color: LelloTheme.palleteOf(appTheme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                PrimaryButton(
                  text: getString(context, _itemArgs.goToSettingsButtonKey),
                  onPressed: () async {
                    _shouldCheckPermissionsOnResume = true;
                    await Geolocator.openAppSettings();
                  },
                ),
                SizedBox(height: Dimens.spacing),
                TertiaryButton(
                    text: getString(context, _itemArgs.backButtonKey),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkPermission() async {
    log(_itemArgs.item.toString());
    PermissionStatus _status;
    if (_itemArgs.item == AcessSettingsPermissionsDeniedItemEnum.location) {
      _status = await Permission.location.status;
      if (_status.isGranted) {
        Navigator.of(context).pop(true);
      }
      return;
    }
    if (_itemArgs.item == AcessSettingsPermissionsDeniedItemEnum.files) {
      if (await CheckPermissions.storage()) {
        Navigator.of(context).pop(true);
      }
      return;
    }
    if (_itemArgs.item == AcessSettingsPermissionsDeniedItemEnum.cam) {
      _status = await Permission.camera.status;
      if (_status.isGranted) {
        Navigator.of(context).pop(true);
      }
      return;
    }
    return;
  }
}
