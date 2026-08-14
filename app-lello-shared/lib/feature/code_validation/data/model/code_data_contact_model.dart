import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

part 'code_data_contact_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CodeDataContactModel {
  @JsonKey(name: 'key')
  String? key;

  @JsonKey(name: 'value')
  String? value;

  CodeDataContactModel({this.key, this.value});

  factory CodeDataContactModel.fromJson(Map<String, dynamic> json) =>
      _$CodeDataContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeDataContactModelToJson(this);

  CodeDataContact toEntity() => CodeDataContact(
        key: this.key!,
        value: this.value!,
      );
}
