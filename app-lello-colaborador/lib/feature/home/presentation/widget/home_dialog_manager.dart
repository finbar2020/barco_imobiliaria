import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_not_connected_dialog.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_digital_points_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDialogManager {
  static void showHomeDialog(
    BuildContext context,
    bool isOnline,
    SharedPreferences preferences, {
    List<DigitalPointEntity> digitalPoints = const [],
  }) {
    //Check if dialog has been already shown
    final String lastShow = preferences
            .getString(SharedPreferencesKeys.employeeDialogManagerLastShow) ??
        "";
    DateTime? lastShowDateTime = DateTime.tryParse(lastShow);

    if (lastShowDateTime != null) {
      Duration difference = DateTime.now().difference(lastShowDateTime);
      if (difference.inSeconds < 5) {
        return;
      }
    }
    preferences.setString(SharedPreferencesKeys.employeeDialogManagerLastShow,
        DateTime.now().toString());

    if (!isOnline) {
      HomeNotConnectedDialog.show(context);
      return;
    }

    if (digitalPoints.isNotEmpty) {
      SyncDigitalPointsDialog.show(context, digitalPoints);
      return;
    }
  }
}
