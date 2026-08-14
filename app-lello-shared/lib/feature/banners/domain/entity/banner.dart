import 'package:shared_features/feature/banners/domain/entity/banner_args.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_type_enum.dart';

class BannerEntity {
  String id;
  String? redirect;
  BannerRedirectTypeEnum redirectType;
  String? name;
  String? subtitle;
  String? observacao;
  String image;
  String? urlImage;
  BannerFeatureEnum feature;
  BannerLocationEnum? location;
  BannerTypeEnum? typeBanner;
  BannerArgs? arg;
  String? projeto;
  int? ordem;
  String? ativo;
  DateTime? lastUpdateAt;

  BannerEntity({
    required this.id,
    this.redirect,
    this.redirectType = BannerRedirectTypeEnum.other,
    this.name,
    this.subtitle,
    this.observacao,
    required this.image,
    this.urlImage,
    this.feature = BannerFeatureEnum.others,
    this.location,
    this.typeBanner,
    this.arg,
    this.projeto,
    this.ordem,
    this.ativo,
    this.lastUpdateAt,
  });
}
