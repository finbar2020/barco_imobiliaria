import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';

part 'unity_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnityModel {
  String? id;
  String? notificationContext;
  String? title;
  bool? rented;
  bool? compliant;
  bool? agreement;
  bool? termHomeToGo;

  UnityModel(
      {this.id,
      this.notificationContext,
      this.title,
      this.rented,
      this.compliant,
      this.agreement,
      this.termHomeToGo});

  factory UnityModel.fromJson(Map<String, dynamic> json) =>
      _$UnityModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnityModelToJson(this);

  static UnityModel? fromEntity(Unity? entity) => entity == null
      ? null
      : (UnityModel()
        ..id = entity.id
        ..notificationContext = entity.notificationContext
        ..title = entity.title
        ..rented = entity.rented
        ..compliant = entity.compliant
        ..agreement = entity.agreement
        ..termHomeToGo = entity.termHomeToGo);

  Unity toEntity() => Unity()
    ..id = this.id
    ..notificationContext = this.notificationContext
    ..title = this.title
    ..rented = this.rented
    ..compliant = this.compliant
    ..agreement = this.agreement
    ..termHomeToGo = this.termHomeToGo;

  @override
  String toString() {
    return 'UnityModel(id: $id,notificationContext: $notificationContext, title: $title, rented: $rented, compliant: $compliant, agreement: $agreement, termHomeToGo: $termHomeToGo)';
  }
}
