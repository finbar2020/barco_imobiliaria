import 'package:essentials/essentials.dart';

part 'procedure_options_model.g.dart';

@JsonSerializable()
class FirstResponsibleModel {
  final String id;
  final String name;

  FirstResponsibleModel({
    required this.id,
    required this.name,
  });

  factory FirstResponsibleModel.fromJson(Map<String, dynamic> json) =>
      FirstResponsibleModel(
        id: _stringOrEmpty(json['id']),
        name: _stringOrEmpty(json['name']),
      );

  Map<String, dynamic> toJson() => _$FirstResponsibleModelToJson(this);
}

@JsonSerializable()
class ProcedureOptionModel {
  final String id;
  final String title;
  @JsonKey(name: 'title_key')
  final String? titleKey;
  final String? description;
  @JsonKey(name: 'url_image')
  final String urlImage;
  @JsonKey(name: 'procedure_id')
  final String? procedureId;
  @JsonKey(name: 'procedure_group_id')
  final String? procedureGroupId;
  @JsonKey(name: 'procedure_group')
  final dynamic procedureGroup;
  @JsonKey(name: 'first_responsible')
  final FirstResponsibleModel? firstResponsible;

  ProcedureOptionModel({
    required this.id,
    required this.title,
    this.titleKey,
    this.description,
    required this.urlImage,
    this.procedureId,
    this.procedureGroupId,
    this.procedureGroup,
    this.firstResponsible,
  });

  factory ProcedureOptionModel.fromJson(Map<String, dynamic> json) =>
      ProcedureOptionModel(
        id: _stringOrEmpty(json['id']),
        title: _stringOrEmpty(json['title']),
        titleKey: _nullableString(json['title_key']),
        description: _nullableString(json['description']),
        urlImage: _stringOrEmpty(json['url_image']),
        procedureId: _nullableString(json['procedure_id']),
        procedureGroupId: _nullableString(json['procedure_group_id']),
        procedureGroup: json['procedure_group'],
        firstResponsible: _mapOrNull(json['first_responsible']) == null
            ? null
            : FirstResponsibleModel.fromJson(
                _mapOrNull(json['first_responsible'])!),
      );

  Map<String, dynamic> toJson() => _$ProcedureOptionModelToJson(this);
}

@JsonSerializable()
class ProcedureOptionsModel {
  @JsonKey(name: 'procedure_options')
  final List<ProcedureOptionModel> procedureOptions;

  ProcedureOptionsModel({
    required this.procedureOptions,
  });

  factory ProcedureOptionsModel.fromJson(Map<String, dynamic> json) {
    final dynamic optionsData = json['procedure_options'];
    final optionsRaw = optionsData is List ? optionsData : const <dynamic>[];

    return ProcedureOptionsModel(
      procedureOptions: optionsRaw
          .map(_mapOrNull)
          .whereType<Map<String, dynamic>>()
          .map(ProcedureOptionModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$ProcedureOptionsModelToJson(this);
}

Map<String, dynamic>? _mapOrNull(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}

String _stringOrEmpty(dynamic value) {
  final parsed = _nullableString(value);
  return parsed ?? '';
}

String? _nullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is String) {
    return value;
  }

  return value.toString();
}
