import 'package:hive/hive.dart';
import 'package:shared_features/shared_features.dart';
import 'banners_args_hive_model.dart';
import 'package:collection/collection.dart';

class BannersArgsDao {
  Future<Box<BannersArgsHiveModel>> get box async {
    if (Hive.isAdapterRegistered(BannersArgsHiveModelAdapter().typeId) == false)
      Hive.registerAdapter<BannersArgsHiveModel>(BannersArgsHiveModelAdapter());

    var openedBox = await Hive.openBox<BannersArgsHiveModel>(
        SharedPreferencesKeys.bannersArgs);

    return openedBox;
  }

  Future<BannersArgsHiveModel?> getByBannerId(String bannerId) async {
    try {
      return (await box)
          .values
          .firstWhereOrNull((element) => element.bannerId == bannerId);
    } catch (e) {
      return null;
    }
  }

  Future<List<BannersArgsHiveModel>> getByCondominiumId(
      String condominiumId) async {
    return (await box)
        .values
        .where((element) => element.condominiumId == condominiumId)
        .toList();
  }

  Future<void> clearByCondominium(String condominiumId) async {
    final items = (await box)
        .values
        .where((element) => element.condominiumId == condominiumId)
        .toList();
    for (var item in items) {
      item.delete();
    }
  }

  Future<void> insert(BannersArgsHiveModel data) async {
    await (await box).put(data.bannerId, data);
  }
}
