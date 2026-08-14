import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComfortYourCondoRemoteConfig {
  final String type;
  final String iconType;
  final String iconPath;
  final String title;
  final String body;

  ComfortYourCondoRemoteConfig({
    required this.type,
    required this.iconType,
    required this.iconPath,
    required this.title,
    required this.body,
  });

  static ComfortYourCondoRemoteConfig fromRemote(dynamic json) =>
      ComfortYourCondoRemoteConfig(
        type: json["type"],
        iconType: json["iconType"],
        iconPath: json["iconPath"],
        title: json["title"],
        body: json["body"],
      );

  Widget getIconWithColor(Color color) => iconType == "asset"
      ? SvgPicture.asset(
          "assets/$iconPath",
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        )
      : Icon(
          Icons.info_outline,
          color: color,
        );
  Widget get getIcon => iconType == "asset"
      ? SvgPicture.asset("assets/$iconPath")
      : Icon(Icons.info_outline);
}
