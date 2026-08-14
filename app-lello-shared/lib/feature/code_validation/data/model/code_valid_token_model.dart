import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

part 'code_valid_token_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CodeValidTokenModel {
  @JsonKey(name: 'token')
  String? token;

  CodeValidTokenModel({this.token});

  factory CodeValidTokenModel.fromJson(Map<String, dynamic> json) =>
      _$CodeValidTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeValidTokenModelToJson(this);

  CodeValidToken toEntity() => CodeValidToken(token: this.token ?? "");
}
