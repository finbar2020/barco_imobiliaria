// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/domain/entity/income_forecast.dart';

part 'income_forecast_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IncomeForecastModel {
  final String? period;
  final double? forecast;
  final double? value;

  IncomeForecastModel({
    this.period,
    this.forecast,
    this.value,
  });

  static final dateFormat = DateFormat("yyyy-MM");

  factory IncomeForecastModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeForecastModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeForecastModelToJson(this);

  static IncomeForecastModel? fromEntity(IncomeForecast? entity) =>
      entity == null
          ? null
          : (IncomeForecastModel(
              period: dateFormat.format(entity.period!),
              forecast: entity.forecast,
              value: entity.value,
            ));

  IncomeForecast toEntity() {
    return IncomeForecast(
      period: period != null ? dateFormat.parse(period!) : null,
      forecast: forecast,
      value: value,
    );
  }
}
