import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';

part 'comfort_partner_favorite_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortPartnerFavoriteModel {
  String comfortOwnerId;
  bool isFavorite;

  ComfortPartnerFavoriteModel({
    this.comfortOwnerId = "",
    this.isFavorite = false,
  });

  factory ComfortPartnerFavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortPartnerFavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortPartnerFavoriteModelToJson(this);

  static ComfortPartnerFavoriteModel? fromEntity(
          ComfortPartnerFavorite? entity) =>
      entity == null
          ? null
          : (ComfortPartnerFavoriteModel()
            ..comfortOwnerId = entity.comfortOwnerId
            ..isFavorite = entity.isFavorite);

  ComfortPartnerFavorite toEntity() => ComfortPartnerFavorite(
        comfortOwnerId: this.comfortOwnerId,
        isFavorite: this.isFavorite,
      );
}
