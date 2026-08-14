import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
part 'send_token_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SendTokenDataModel {
  final int? id;

  SendTokenDataModel({
    this.id,
  });

  factory SendTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$SendTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendTokenDataModelToJson(this);

  static SendTokenDataModel? fromEntity(SendTokenData? entity) {
    if (entity == null) return null;
    return SendTokenDataModel(
      id: entity.id,
    );
  }

  SendTokenData toEntity() {
    return SendTokenData(
      id: id,
    );
  }
}
