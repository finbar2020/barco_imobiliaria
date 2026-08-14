import 'dart:convert';

import 'package:morar/feature/session/data/data_source/session_local_data_source.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionLocalDataSourceImpl extends SessionLocalDataSource {
  final String _key = SharedPreferencesKeys.ownerSession;

  @override
  Future<SessionModel?> save(SessionModel? model) async {
    var preferences = await SharedPreferences.getInstance();
    if (model == null) {
      preferences.remove(_key);
    } else {
      preferences.setString(_key, _serialize(model));
    }
    return model;
  }

  @override
  Future<SessionModel?> select() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      String? persisted = preferences.get(_key) as String?;
      if (persisted != null && persisted.isNotEmpty) {
        return _deserialize(persisted);
      }
    } catch (ex) {}

    return null;
  }

  String _serialize(SessionModel model) => json.encode(model.toJson());
  SessionModel _deserialize(String serialized) =>
      SessionModel.fromJson(json.decode(serialized));
}
