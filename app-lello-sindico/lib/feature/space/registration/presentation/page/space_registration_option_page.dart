import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/shared_features.dart';

class SpaceRegistrationOptionPage extends StatefulWidget {
  @override
  State<SpaceRegistrationOptionPage> createState() =>
      _SpaceRegistrationOptionPageState();
}

class _SpaceRegistrationOptionPageState
    extends State<SpaceRegistrationOptionPage> {
  PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            title: getString(context, "space_register"), theme: theme),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: _buildButtons(
                    theme,
                    changeLelloForCompanyName(
                        context, "space_list_request_lello"), () {
              Navigator.of(context)
                  .pushNamed(ApplicationRoute.spaceRegistrationLello);
            })),
            Divider(),
            Expanded(
                child: _buildButtons(
                    theme, getString(context, "space_list_register_manually"),
                    () {
              Navigator.of(context)
                  .pushNamed(ApplicationRoute.spaceRegistration);
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(ThemeData theme, String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title, style: LelloTextStyles.bodyBold(theme))],
      ),
    );
  }

  bool _isGeneric() {
    String packageName = _getPackageName();
    return packageName == SharedPreferencesKeys.genericSindico ||
        packageName == SharedPreferencesKeys.iosGenericSindico;
  }

  String _getPackageName() {
    if (packageInfo != null)
      return packageInfo!.packageName;
    else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  String changeLelloForCompanyName(BuildContext context, String getText) {
    if (_isGeneric()) {
      var textFormatted = getString(context, getText);
      if (textFormatted.isNotEmpty) {
        return textFormatted.replaceAll("Lello", packageInfo!.appName);
      } else {
        return getString(context, getText);
      }
    } else {
      return getString(context, getText);
    }
  }
}
