import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lello/feature/splash/data/data_source/boot_data_source.dart';
import 'package:lello/feature/splash/data/model/boot_data_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BootDataSourceImpl extends BootDataSource {
  final String _key = SharedPreferencesKeys.managerBootData;

  @override
  Future<BootDataModel?> select() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      String? persisted = preferences.get(_key) as String?;
      if (persisted != null && persisted.isNotEmpty) {
        return _deserialize(persisted);
      }
    } catch (ex, stack) {
      FirebaseCrashlytics.instance.recordError(ex, stack);
    }

    return null;
  }

  @override
  Future<BootDataModel?> save(BootDataModel? model) async {
    var preferences = await SharedPreferences.getInstance();
    if (model == null) {
      preferences.remove(_key);
    } else {
      preferences.setString(_key, _serialize(model));
    }
    return model;
  }

  String _serialize(BootDataModel model) => json.encode(model.toJson());
  BootDataModel _deserialize(String serialized) =>
      BootDataModel.fromJson(json.decode(serialized));
}
