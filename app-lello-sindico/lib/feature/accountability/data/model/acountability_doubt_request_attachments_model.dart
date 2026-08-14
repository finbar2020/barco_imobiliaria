import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_attachments.dart';
import 'package:path/path.dart';

part 'acountability_doubt_request_attachments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttachmentsRequestModel {
  String id;
  String name;
  String? type;
  String? file;
  String? content;

  AttachmentsRequestModel(
      {required this.id,
      required this.name,
      required this.type,
      required this.file,
      required this.content});

  factory AttachmentsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentsRequestModelToJson(this);

  static AttachmentsRequestModel fromEntity(File entity) =>
      (AttachmentsRequestModel(
          id: entity.path,
          name: basename(entity.path).split(".").first,
          type: basename(entity.path).split(".").last,
          file: basename(entity.path),
          content: base64Encode(entity.readAsBytesSync())));

  Attachments toEntity() => Attachments(
        id: this.id,
        name: this.name,
        type: this.type,
        fileName: this.file,
      );
}
