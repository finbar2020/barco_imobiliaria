import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';

part 'mailing_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MailingModel {
  final String? id;
  final DateTime? pickUpDate;
  final DateTime? arrivalDate;
  final String? addressee;
  final String? category;
  final String? size;
  final String? status;
  final String? pickUpResident;
  final String? notificationParameter;
  final String? photo;
  final String? trackingCode;
  final String? description;
  final String? observation;

  MailingModel({
    this.id,
    this.pickUpDate,
    this.arrivalDate,
    this.addressee,
    this.category,
    this.size,
    this.status,
    this.pickUpResident,
    this.notificationParameter,
    this.photo,
    this.trackingCode,
    this.description,
    this.observation,
  });

  factory MailingModel.fromJson(Map<String, dynamic> json) =>
      _$MailingModelFromJson(json);
  Map<String, dynamic> toJson() => _$MailingModelToJson(this);

  static MailingModel? fromEntity(Mailing? entity) => entity == null
      ? null
      : MailingModel(
          id: entity.id,
          addressee: entity.addressee,
          pickUpDate: entity.pickUpDate,
          arrivalDate: entity.arrivalDate,
          category: entity.category,
          size: entity.size,
          status: entity.status,
          pickUpResident: entity.pickUpResident,
          notificationParameter: entity.notificationParameter,
          description: entity.description,
          observation: entity.observation,
          photo: entity.photo,
          trackingCode: entity.trackingCode,
        );

  Mailing toEntity() {
    return Mailing(
      id: this.id,
      addressee: this.addressee,
      pickUpDate: this.pickUpDate,
      arrivalDate: this.arrivalDate,
      category: this.category,
      size: this.size,
      status: this.status,
      pickUpResident: this.pickUpResident,
      notificationParameter: this.notificationParameter,
      description: this.description,
      observation: this.observation,
      photo: this.photo,
      trackingCode: this.trackingCode,
    );
  }
}
