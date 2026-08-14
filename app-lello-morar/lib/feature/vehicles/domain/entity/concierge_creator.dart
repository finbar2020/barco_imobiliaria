import 'package:json_annotation/json_annotation.dart';

part 'concierge_creator.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ConciergeCreator {
  final String? name;
  final String? id;
  final ConciergeCreatorType? type;
  ConciergeCreator({
    this.name,
    this.id,
    this.type,
  });

  factory ConciergeCreator.fromJson(Map<String, dynamic> json) =>
      _$ConciergeCreatorFromJson(json);
  Map<String, dynamic> toJson() => _$ConciergeCreatorToJson(this);
}

enum ConciergeCreatorType {
  appmorar,
  appsindico,
  portaria,
  resolvafacil,
  moradorcriador,
  moradorcriadorsemlogin,
}
