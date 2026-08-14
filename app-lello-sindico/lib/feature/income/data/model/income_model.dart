// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/data/model/billet_model.dart';
import 'package:lello/feature/income/data/model/income_forecast_model.dart';
import 'package:lello/feature/income/data/model/income_share_model.dart';
import 'package:lello/feature/income/domain/entity/income.dart';

part 'income_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IncomeModel {
  final String? period;
  final List<IncomeShareModel?>? shares;
  final List<IncomeForecastModel?>? forecast;
  final List<BilletModel?>? pendingBillets;
  final double? value;

  IncomeModel({
    this.period,
    this.shares,
    this.forecast,
    this.pendingBillets,
    this.value,
  });

  static final dateFormat = DateFormat("yyyy-MM");

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeModelToJson(this);

  static IncomeModel? fromEntity(Income? entity) => entity == null
      ? null
      : (IncomeModel(
          period: dateFormat.format(entity.period!),
          value: entity.value,
          shares: entity.shares
                  ?.map((e) => IncomeShareModel.fromEntity(e))
                  .toList() ??
              [],
          forecast: entity.forecast
                  ?.map((e) => IncomeForecastModel.fromEntity(e))
                  .toList() ??
              [],
          pendingBillets: entity.pendingBillets
                  ?.map((e) => BilletModel.fromEntity(e))
                  .toList() ??
              [],
        ));

  Income toEntity() {
    return Income(
      period: period != null ? dateFormat.parse(period!) : null,
      value: value,
      shares: shares?.map((e) => e!.toEntity()).toList() ?? [],
      forecast: forecast?.map((e) => e!.toEntity()).toList() ?? [],
      pendingBillets: pendingBillets?.map((e) => e!.toEntity()).toList() ?? [],
    );
  }

  IncomeModel copyWith({
    String? period,
    List<IncomeShareModel?>? shares,
    List<IncomeForecastModel?>? forecast,
    List<BilletModel?>? pendingBillets,
    double? value,
  }) {
    return IncomeModel(
      period: period ?? this.period,
      shares: shares ?? this.shares,
      forecast: forecast ?? this.forecast,
      pendingBillets: pendingBillets ?? this.pendingBillets,
      value: value ?? this.value,
    );
  }
}
