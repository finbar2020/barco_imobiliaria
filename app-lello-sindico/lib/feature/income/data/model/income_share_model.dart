// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/domain/entity/income_share.dart';

part 'income_share_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IncomeShareModel {
  final String? title;
  final int? total;
  final double? share;
  final String? color;

  IncomeShareModel({
    this.title,
    this.total,
    this.share,
    this.color,
  });

  factory IncomeShareModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeShareModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeShareModelToJson(this);

  static IncomeShareModel? fromEntity(IncomeShare? entity) => entity == null
      ? null
      : (IncomeShareModel(
          title: entity.title,
          total: entity.total,
          share: entity.share,
          color: entity.color.toString(),
        ));

  IncomeShare toEntity() {
    return IncomeShare(
      title: title,
      total: total,
      share: share ?? 0,
      color: parseColor(),
    );
  }

  Color? parseColor() {
    try {
      final hex = color!.replaceFirst("#", "");
      return Color(int.parse("0xFF$hex"));
    } catch (ex) {
      return null;
    }
  }
}
