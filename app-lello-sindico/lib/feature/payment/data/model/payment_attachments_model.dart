import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/payment_attachments.dart';

part 'payment_attachments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentAttachmentsModel {
  String? type;
  String? content;
  String? name;

  PaymentAttachmentsModel();

  factory PaymentAttachmentsModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentAttachmentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentAttachmentsModelToJson(this);

  static PaymentAttachmentsModel? fromEntity(PaymentAttachments? entity) =>
      entity == null
          ? null
          : (PaymentAttachmentsModel()
            ..type = entity.type
            ..content = entity.content
            ..name = entity.name);

  PaymentAttachments toEntity() => PaymentAttachments(
        type: type,
        content: content,
        name: name,
      );
}
