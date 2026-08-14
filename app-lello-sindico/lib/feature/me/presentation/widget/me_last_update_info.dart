import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeLastUpdateInfo extends StatefulWidget {
  const MeLastUpdateInfo({Key? key}) : super(key: key);

  @override
  State<MeLastUpdateInfo> createState() => _MeLastUpdateInfoState();
}

class _MeLastUpdateInfoState extends State<MeLastUpdateInfo> {
  //Time difference between last switch roles update and now
  String lastSwitchRolesUpdateDifference = "";
  //Time difference between last getMe update and now
  String lastGetMeUpdateDifference = "";

  @override
  void initState() {
    super.initState();
    _getLastSwitchRolesUpdate();
    _getLastGetMeUpdate();
  }

  Future _getLastSwitchRolesUpdate() async {
    var preferences = await SharedPreferences.getInstance();
    final String? lastSwitchRolesString =
        preferences.getString(SharedPreferencesKeys.lastSwitchRoles);
    if (lastSwitchRolesString != null) {
      DateTime lastSwitchRoles = DateTime.parse(lastSwitchRolesString);
      setState(() {
        lastSwitchRolesUpdateDifference =
            "-${DateTime.now().difference(lastSwitchRoles).inSeconds.toString()}";
      });
    }
  }

  Future _getLastGetMeUpdate() async {
    DateFormat dateFormat = DateFormat("MMdd");
    String nowString = dateFormat.format(DateTime.now());
    var preferences = await SharedPreferences.getInstance();
    final String? lastGetMeString =
        preferences.getString(SharedPreferencesKeys.managerLastGetMe);
    if (lastGetMeString != null) {
      DateTime lastGetMeUpdate = DateTime.parse(lastGetMeString);
      Duration diference = DateTime.now().difference(lastGetMeUpdate);
      lastGetMeUpdateDifference =
          "$nowString-${diference.inSeconds.toString()}";
      setState(() {
        lastGetMeUpdateDifference =
            "$nowString-${diference.inSeconds.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(right: Dimens.spacingSmall),
        child: Text(
          "$lastGetMeUpdateDifference$lastSwitchRolesUpdateDifference",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: LelloTheme.palleteOf(theme).grey(), fontSize: 10),
        ),
      ),
    );
  }
}
