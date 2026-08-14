import 'package:essentials/configs/environment.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app_localization.dart';
import '../../../enum/app_origin_enum.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class AppVersionAndNameWidget extends StatefulWidget {
  final AppOriginEnum appOrigin;
  final Environment? env;
  AppVersionAndNameWidget({Key? key, required this.appOrigin, this.env})
      : super(key: key);

  @override
  State<AppVersionAndNameWidget> createState() =>
      _AppVersionAndNameWidgetState();
}

class _AppVersionAndNameWidgetState extends State<AppVersionAndNameWidget> {
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
          "$version",
          textAlign: TextAlign.right,
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        if (widget.env?.isProduction == false)
          Text(
            widget.env!.name,
            style: const TextStyle(fontSize: 10).copyWith(
              color: LelloTheme.palleteOf(theme).purpleText(),
            ),
          ),
        SizedBox(height: Dimens.spacingXSmall),
      ],
    );
  }

  String _getVersion() {
    if (packageInfo != null)
      return "${_getName()}${packageInfo!.version}";
    else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  String _getName() {
    switch (widget.appOrigin) {
      case AppOriginEnum.manager:
        return "s";
      case AppOriginEnum.owner:
        return "m";
      case AppOriginEnum.employee:
        return "c";
    }
  }
}
