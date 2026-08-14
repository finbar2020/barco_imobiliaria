import 'package:hive/hive.dart';

part 'banners_args_hive_model.g.dart';

@HiveType(typeId: 0)
class BannersArgsHiveModel extends HiveObject {
  @HiveField(0)
  late String bannerId;

  @HiveField(1)
  late String condominiumId;

  @HiveField(2)
  String? partnerId;
}
