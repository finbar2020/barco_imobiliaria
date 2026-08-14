import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_digital_document.dart';

part 'resin_refund_digital_document_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinRefundDigitalDocumentModel {
  String? id;
  String? bytes;
  String? name;

  ResinRefundDigitalDocumentModel({
    this.id,
    this.bytes,
    this.name,
  });

  factory ResinRefundDigitalDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$ResinRefundDigitalDocumentModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ResinRefundDigitalDocumentModelToJson(this);

  static ResinRefundDigitalDocumentModel fromEntity(
          ResinRefundDigitalDocument entity) =>
      ResinRefundDigitalDocumentModel(
        id: entity.id,
        bytes: entity.bytes,
        name: entity.name,
      );

  ResinRefundDigitalDocument? toEntity() => isValid
      ? ResinRefundDigitalDocument(
          id: id ?? '',
          bytes: bytes,
          name: name ?? '',
        )
      : null;

  //Verify if model isValid to convert to Entity
  bool get isValid {
    if (id == null) {
      return false;
    }
    if (name == null) {
      return false;
    }
    return true;
  }
}
