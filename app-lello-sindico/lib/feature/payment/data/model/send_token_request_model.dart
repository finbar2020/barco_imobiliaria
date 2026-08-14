import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';
part 'send_token_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SendTokenRequestModel {
  final String? method;
  final String? value;

  SendTokenRequestModel({
    this.method,
    this.value,
  });

  factory SendTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendTokenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendTokenRequestModelToJson(this);

  static SendTokenRequestModel? fromEntity(SendTokenRequestEntity? entity) {
    if (entity == null) return null;
    return SendTokenRequestModel(
      method: entity.method,
      value: entity.value,
    );
  }

  SendTokenRequestEntity toEntity() {
    return SendTokenRequestEntity(
      method: method,
      value: value,
    );
  }
}
