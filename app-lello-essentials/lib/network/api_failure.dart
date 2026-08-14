import 'package:json_annotation/json_annotation.dart';

part 'api_failure.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiFailure {
  int? status;
  String? title;
  String? detail;
  String? type;
  String? instance;
  String? failure;
  String? message;

  ApiFailure();

  factory ApiFailure.fromJson(Map<String, dynamic> json) =>
      _$ApiFailureFromJson(json);
  Map<String, dynamic> toJson() => _$ApiFailureToJson(this);

  @override
  String toString() {
    return 'ApiFailure(status: $status, title: $title, detail: $detail, '
        'type: $type, instance: $instance, failure: $failure, message: $message)';
  }
}
