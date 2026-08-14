import 'package:json_annotation/json_annotation.dart';

part 'submit_form_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmitFormResponseModel {
  final bool success;
  
  @JsonKey(name: 'detail')
  final String? message;
  
  final String? data;

  SubmitFormResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory SubmitFormResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitFormResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitFormResponseModelToJson(this);
}
