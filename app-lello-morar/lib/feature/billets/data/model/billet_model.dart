import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/billets/data/model/billet_found_model.dart';
import 'package:morar/feature/billets/data/model/billet_instructions_model.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';

part 'billet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletModel {
  String? id;
  double? value;
  DateTime? period;
  String? situation;
  String? nrBillet;
  String? code;
  String? notificationParameter;
  String? name;
  bool? isDuplicate;
  List<BilletFoundModel> founds;
  BilletInstructionsModel? instructions;

  BilletModel({
    this.id,
    this.value,
    this.period,
    this.situation,
    this.code,
    this.nrBillet,
    this.founds = const [],
    this.instructions,
    this.name,
    this.isDuplicate,
  });

  factory BilletModel.fromJson(Map<String, dynamic> json) =>
      _$BilletModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletModelToJson(this);

  static BilletModel? fromEntity(Billet? entity) => entity == null
      ? null
      : (BilletModel()
        ..id = entity.id
        ..value = entity.value
        ..situation = enumToString(entity.situation) ?? ""
        ..code = entity.code
        ..nrBillet = entity.nrBillet
        ..notificationParameter = entity.notificationParameter
        ..name = entity.name
        ..isDuplicate = entity.isDuplicate
        ..founds =
            entity.founds.map((e) => BilletFoundModel.fromEntity(e)).toList()
        ..instructions =
            BilletInstructionsModel.fromEntity(entity.instructions));

  Billet toEntity() => Billet()
    ..id = this.id
    ..value = this.value
    ..period = this.period
    ..situation =
        stringToEnum(BilletStatusEnum.values, this.situation ?? "outros") ??
            BilletStatusEnum.outros
    ..value = this.value
    ..code = this.code
    ..nrBillet = this.nrBillet
    ..notificationParameter = this.notificationParameter
    ..name = this.name
    ..isDuplicate = this.isDuplicate
    ..founds = this.founds.map((e) => e.toEntity()).toList()
    ..instructions = this.instructions?.toEntity();
}
