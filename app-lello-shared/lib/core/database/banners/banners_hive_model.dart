import 'package:hive/hive.dart';

part 'banners_hive_model.g.dart';

@HiveType(typeId: 1)
class BannersHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String condominiumId;

  @HiveField(2)
  String? redirect;

  @HiveField(3)
  String? redirectType;

  @HiveField(4)
  late String image;

  @HiveField(5)
  String? urlImage;

  @HiveField(6)
  String? feature;

  @HiveField(7)
  DateTime? lastUpdateAt;

  @HiveField(8)
  String? name;

  @HiveField(9)
  String? observacao;

  @HiveField(10)
  String? location;

  @HiveField(11)
  String? subTitle;

  @HiveField(12)
  String? typeBanner;

  @HiveField(13)
  String? projeto;

  @HiveField(14)
  int? ordem;

  @HiveField(15)
  String? ativo;
}
