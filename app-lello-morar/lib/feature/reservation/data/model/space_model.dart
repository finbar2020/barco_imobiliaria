import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/data/model/reservation_rule_model.dart';
import 'package:morar/feature/reservation/data/model/space_type_model.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';

part 'space_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceModel {
  String? id;
  String? name;
  String? pictureUrl;
  String? fileUrl;
  SpaceTypeModel? type;
  String? description;
  int? capacity;
  SpaceModel? sharedSpace;
  ReservationRuleModel? reservationRule;
  String? term;

  SpaceModel({
    this.id,
    this.name,
    this.pictureUrl,
    this.fileUrl,
    this.type,
    this.description,
    this.capacity,
    this.reservationRule,
    this.term,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceModelToJson(this);

  static SpaceModel? fromEntity(Space? entity) => entity == null
      ? null
      : (SpaceModel()
        ..id = entity.id
        ..name = entity.name
        ..pictureUrl = entity.pictureUrl
        ..fileUrl = entity.fileUrl
        ..type = SpaceTypeModel.fromEntity(entity.type)
        ..description = entity.description
        ..capacity = entity.capacity
        ..sharedSpace = SpaceModel.fromEntity(entity.sharedSpace)
        ..reservationRule =
            ReservationRuleModel.fromEntity(entity.reservationRule)
        ..term = entity.term);

  Space toEntity() => Space()
    ..id = this.id
    ..name = this.name
    ..pictureUrl = this.pictureUrl
    ..fileUrl = this.fileUrl
    ..type = this.type?.toEntity()
    ..description = this.description
    ..capacity = this.capacity
    ..sharedSpace = this.sharedSpace?.toEntity()
    ..reservationRule = this.reservationRule?.toEntity() ?? ReservationRule()
    ..term = this.term;
}
