import 'package:hive/hive.dart';
import 'package:shared_features/shared_features.dart';
import 'banners_hive_model.dart';

class BannersDao {
  Future<Box<BannersHive>> get box async {
    if (Hive.isAdapterRegistered(BannersHiveAdapter().typeId) == false)
      Hive.registerAdapter<BannersHive>(BannersHiveAdapter());

    return await Hive.openBox<BannersHive>(SharedPreferencesKeys.banners);
  }

  Future<List<BannersHive>> get(String condominiumId) async {
    return (await box)
        .values
        .where((element) => element.condominiumId == condominiumId)
        .toList();
  }

  Future<void> clear(String condominiumId) async {
    final items = (await box)
        .values
        .where((element) => element.condominiumId == condominiumId)
        .toList();
    for (var item in items) {
      item.delete();
    }
  }

  Future<void> insert(BannersHive data) async {
    await (await box).put(data.id, data);
  }
}
