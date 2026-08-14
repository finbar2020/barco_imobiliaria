import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/comfort_dialog/confort_to_your_condo_dialog_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortToYourCondoDialog {
  static Future<bool> canShowConfortToYourCondo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? date =
        prefs.getString(SharedPreferencesKeys.showDialogNewToYourCondo);
    if (date == null || date.isEmpty) {
      return true;
    } else {
      return _checkDateInterval(date: date);
    }
  }

  static Future<void> _setDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? date =
        prefs.getString(SharedPreferencesKeys.showDialogNewToYourCondo);
    if (date != null || date?.isNotEmpty == true) {
      await prefs.remove(SharedPreferencesKeys.showDialogNewToYourCondo);
    }
    await prefs.setString(SharedPreferencesKeys.showDialogNewToYourCondo,
        DateTime.now().toString());
  }

  static bool _checkDateInterval({required String date}) {
    try {
      int difference = DateTime.now().difference(DateTime.parse(date)).inDays;
      return difference >= 3 ? true : false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> show({
    required BuildContext context,
  }) async {
    try {
      _setDate();
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => const ComfortToYourCondoDialogWidget());
    } catch (e) {
      return;
    }
  }
}
