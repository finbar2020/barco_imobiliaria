import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_args.dart';

part 'banner_args_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BannerArgsModel {
  String? partnerId;

  BannerArgsModel({
    this.partnerId,
  });

  factory BannerArgsModel.fromJson(Map<String, dynamic> json) =>
      _$BannerArgsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerArgsModelToJson(this);

  static BannerArgsModel? fromEntity(BannerArgs? entity) =>
      entity == null ? null : (BannerArgsModel()..partnerId = entity.partnerId);

  BannerArgs toEntity() => BannerArgs(
        partnerId: this.partnerId,
      );
}
