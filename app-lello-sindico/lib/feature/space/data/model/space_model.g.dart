// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceModel _$SpaceModelFromJson(Map<String, dynamic> json) => SpaceModel()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..pictureUrl = json['picture_url'] as String?
  ..fileUrl = json['file_url'] as String?
  ..type = json['type'] == null
      ? null
      : SpaceTypeModel.fromJson(json['type'] as Map<String, dynamic>)
  ..description = json['description'] as String?
  ..capacity = (json['capacity'] as num?)?.toInt()
  ..sharedSpace = json['shared_space'] == null
      ? null
      : SpaceModel.fromJson(json['shared_space'] as Map<String, dynamic>)
  ..reservationRule = json['reservation_rule'] == null
      ? null
      : ReservationRuleModel.fromJson(
          json['reservation_rule'] as Map<String, dynamic>)
  ..term = json['term'] as String?;

Map<String, dynamic> _$SpaceModelToJson(SpaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture_url': instance.pictureUrl,
      'file_url': instance.fileUrl,
      'type': instance.type,
      'description': instance.description,
      'capacity': instance.capacity,
      'shared_space': instance.sharedSpace,
      'reservation_rule': instance.reservationRule,
      'term': instance.term,
    };
