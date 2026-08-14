import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';

part 'pendency_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PendencyModel {
  String? id;
  DateTime? date;
  String? title;
  String? message;
  DateTime? visualizedAt;
  String? status;
  String? reference;
  String? iconType;
  String? identifier;
  String? idSender;
  String? type;
  bool? read;

  PendencyModel({
    this.id,
    this.date,
    this.title,
    this.message,
    this.visualizedAt,
    this.status,
    this.reference,
    this.iconType,
    this.identifier,
    this.idSender,
    this.type,
    this.read,
  });

  factory PendencyModel.fromJson(Map<String, dynamic> json) =>
      _$PendencyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PendencyModelToJson(this);

  static PendencyModel? fromEntity(Pendency? entity) => entity == null
      ? null
      : (PendencyModel()
        ..id = entity.id
        ..date = entity.date
        ..title = entity.title
        ..message = entity.message
        ..visualizedAt = entity.visualizedAt
        ..status = entity.status
        ..reference = entity.reference
        ..identifier = entity.identifier
        ..idSender = entity.idSender
        ..type = entity.type
        ..read = entity.read);

  Pendency toEntity() => Pendency()
    ..id = this.id
    ..date = this.date
    ..title = this.title
    ..message = this.message
    ..visualizedAt = this.visualizedAt
    ..status = this.status
    ..reference = this.reference
    ..identifier = this.identifier
    ..idSender = this.idSender
    ..type = this.type
    ..read = this.read;
}
