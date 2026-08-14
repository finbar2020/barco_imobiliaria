import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AppVersionWidget extends StatefulWidget {
  const AppVersionWidget({Key? key}) : super(key: key);

  @override
  State<AppVersionWidget> createState() => _AppVersionWidgetState();
}

class _AppVersionWidgetState extends State<AppVersionWidget> {
  PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    String version = _getVersion();
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          getString(context, "version", defaultText: "Versão"),
          textAlign: TextAlign.right,
          style: LelloTextStyles.bodyBold(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
        Text(
          version,
          textAlign: TextAlign.right,
          style: LelloTextStyles.body(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
      ],
    );
  }

  String _getVersion() {
    if (packageInfo != null) {
      return "V${packageInfo!.version}";
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }
}
