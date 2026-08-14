import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';

part 'home_banner_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeBannerModel {
  bool? insideApp;
  String? image;
  String? url;

  HomeBannerModel({
    this.insideApp,
    this.image,
    this.url,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeBannerModelToJson(this);

  static HomeBannerModel? fromEntity(HomeBanner? entity) => entity == null
      ? null
      : (HomeBannerModel()
        ..insideApp = entity.insideApp
        ..image = entity.image
        ..url = entity.url);

  HomeBanner toEntity() => HomeBanner()
    ..insideApp = this.insideApp
    ..image = this.image
    ..url = this.url;
}
