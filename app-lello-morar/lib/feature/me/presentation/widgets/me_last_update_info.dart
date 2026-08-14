import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:shared_features/shared_features.dart';

class MeLastUpdateInfo extends StatefulWidget {
  final MeController controller;
  const MeLastUpdateInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder(
      bloc: widget.controller.bloc,
      builder: (context, state) {
        _getLastGetMeUpdate(widget.controller.bloc.state.me.lastUpdatedAt);
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: Dimens.spacingSmall),
            child: Text(
              "$lastGetMeUpdateDifference$lastSwitchRolesUpdateDifference",
              textAlign: TextAlign.right,
              textScaleFactor: 1.0,
              style: LelloTextStyles.caption(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).background()),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getLastSwitchRolesUpdate() async {
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

  void _getLastGetMeUpdate(DateTime? lastGetMeUpdate) {
    DateFormat dateFormat = DateFormat("MMdd");
    String nowString = dateFormat.format(DateTime.now());
    if (lastGetMeUpdate != null) {
      Duration difference = DateTime.now().difference(lastGetMeUpdate);
      lastGetMeUpdateDifference =
          "$nowString-${difference.inSeconds.toString()}";
    } else {
      lastGetMeUpdateDifference = nowString;
    }
  }
}
