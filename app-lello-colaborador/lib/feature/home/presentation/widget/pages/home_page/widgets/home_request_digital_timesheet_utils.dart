import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_approved_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_declined_dialog.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRequestsDigitalTimesheetUtils {
  static Future<String?> _saveAndGetDigitalTimesheetStatusEnum(
      DigitalTimesheetStatusEnum status) async {
    String key = SharedPreferencesKeys.employeeDigitalTimesheetStatus;
    var preferences = await SharedPreferences.getInstance();
    var getState = preferences.getString(key);
    String? previousState;
    if (getState != null) {
      previousState = getState;
      preferences.remove(key);
    }
    preferences.setString(key, status.toString());
    return previousState;
  }

  static show(BuildContext context, DigitalTimesheetStatusEnum status,
      bool isOnline) async {
    _saveAndGetDigitalTimesheetStatusEnum(status).then((value) {
      if (value == DigitalTimesheetStatusEnum.pending.toString() &&
          status == DigitalTimesheetStatusEnum.declined) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return HomeRequestDeclinedDialog(
                  status: status, isOnline: isOnline);
            });
      } else if (value == DigitalTimesheetStatusEnum.pending.toString() &&
          status == DigitalTimesheetStatusEnum.approved) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const HomeRequestApprovedDialog();
            });
      }
    });
  }
}
