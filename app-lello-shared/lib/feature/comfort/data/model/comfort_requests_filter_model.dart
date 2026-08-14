import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

part 'comfort_requests_filter_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortRequestsFilterModel {
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  String? subcategories;

  ComfortRequestsFilterModel({
    this.startDate,
    this.endDate,
    this.status,
    this.subcategories,
  });

  factory ComfortRequestsFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortRequestsFilterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ComfortRequestsFilterModelToJson(this);

  static ComfortRequestsFilterModel fromEntity(ComfortRequestsFilter entity) =>
      ComfortRequestsFilterModel(
        startDate: entity.startDate,
        endDate: entity.endDate,
        status: enumToString(entity.status),
        subcategories: enumToString(entity.subcategories),
      );

  ComfortRequestsFilter toEntity() => ComfortRequestsFilter(
        startDate: this.startDate,
        endDate: this.endDate,
        status:
            stringToEnum(ComfortFilterRequestStatus.values, this.status ?? ''),
        subcategories:
            stringToEnum(ComfortType.values, this.subcategories ?? ''),
      );
}
