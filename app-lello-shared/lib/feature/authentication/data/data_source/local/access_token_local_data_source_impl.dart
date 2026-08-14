part of shared_features;

class AccessTokenLocalDataSourceImpl extends AccessTokenLocalDataSource {
  final String _key = SharedPreferencesKeys.accessToken;
  final String _keyRefreshToken = SharedPreferencesKeys.refreshToken;
  final String _lastRole = SharedPreferencesKeys.lastRole;
  final String _boxName = "accessToken";
  final String _boxNameRefreshToken = "refreshToken";

  @override
  Future<AccessTokenModel?> select({required String? role}) async {
    var box = await Hive.openBox(_boxName);
    AccessTokenModel? model;
    try {
      if (role == "") {
        role = box.get(_lastRole) as String?;
      }
      String? persisted = box.get(_key + (role ?? "")) as String?;

      if (persisted != null && persisted.isNotEmpty) {
        await box.put(_lastRole, role);
        model = _deserialize(persisted);
      }

      if (model?.refreshToken?.isNotEmpty == true) {
      } else {
        model?.refreshToken = await _selectRefreshToken(model);
      }
    } catch (ex) {
      debugPrint("$ex");
    }

    return model;
  }

  Future<String?> _selectRefreshToken(AccessTokenModel? model) async {
    var boxRefresh = await Hive.openBox(_boxNameRefreshToken);
    String? refreshToken = boxRefresh.get(_keyRefreshToken) as String?;
    if (refreshToken?.isNotEmpty == true) {
      return refreshToken;
    }
    return null;
  }

  @override
  Future<AccessTokenModel?> save(AccessTokenModel? model,
      {required String role}) async {
    var box = await Hive.openBox(_boxName);
    var boxRefresh = await Hive.openBox(_boxNameRefreshToken);

    if (model == null) {
      box.clear();
      boxRefresh.clear();
    } else {
      box.delete(_key + role);

      box.put(_key + role, _serialize(model));

      box.put(_lastRole, role);

      if (model.refreshToken?.isNotEmpty == true) {
        boxRefresh.put(_keyRefreshToken, model.refreshToken);
      } else {
        model.refreshToken = await _selectRefreshToken(model);
      }
    }
    return model;
  }

  String _serialize(AccessTokenModel model) => json.encode(model.toJson());
  AccessTokenModel _deserialize(String serialized) =>
      AccessTokenModel.fromJson(json.decode(serialized));
}
