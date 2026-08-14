import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/code_validation/data/model/code_data_contact_model.dart';
import 'package:shared_features/shared_features.dart';

part 'code_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CodeDataModel {
  @JsonKey(name: 'email_contacts')
  List<CodeDataContactModel>? emailContacts;

  @JsonKey(name: 'sms_contacts')
  List<CodeDataContactModel>? smsContacts;

  @JsonKey(name: 'registered')
  bool? registered;

  CodeDataModel({this.emailContacts, this.smsContacts, this.registered});

  factory CodeDataModel.fromJson(Map<String, dynamic> json) =>
      _$CodeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeDataModelToJson(this);

  CodeData toEntity() => CodeData(
        registered: this.registered ?? false,
        emailContacts: this.emailContacts?.isNotEmpty != true
            ? []
            : this.emailContacts!.map((e) => e.toEntity()).toList(),
        smsContacts: this.smsContacts?.isNotEmpty != true
            ? []
            : this.smsContacts!.map((e) => e.toEntity()).toList(),
      );
}
