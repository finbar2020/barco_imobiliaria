import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:essentials/essentials.dart';

part 'digital_point_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DigitalPointModel {
  final int? id;
  final DateTime date;
  final String latitude;
  final String longitude;
  final String photoPath;
  final String? photoTempHash;
  final String typePoint;
  final String typeCapture;
  final String status;
  final String uniqueHash;
  final bool? tabletSession;
  final String? reference;
  final String? numCra;
  final String? numCad;
  @JsonKey(includeFromJson: false, includeToJson: true, toJson: _toJsonLogs)
  final List<DigitalPointLogData>? logs;

  static List<Map<String, dynamic>> _toJsonLogs(
          List<DigitalPointLogData>? value) =>
      value?.map((DigitalPointLogData e) => e.toJson()).toList() ?? [];

  DigitalPointModel({
    this.id,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.typePoint,
    required this.photoPath,
    required this.status,
    required this.typeCapture,
    required this.uniqueHash,
    required this.tabletSession,
    this.logs,
    this.photoTempHash,
    this.reference,
    this.numCra,
    this.numCad,
  });

  factory DigitalPointModel.fromJson(Map<String, dynamic> json) =>
      _$DigitalPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$DigitalPointModelToJson(this);

  static DigitalPointModel fromEntity(DigitalPointEntity point) =>
      DigitalPointModel(
        id: point.id,
        date: point.date,
        latitude: point.latitude,
        longitude: point.longitude,
        typePoint: enumToString(point.typePoint) ?? "",
        photoTempHash: point.photoTempHash,
        photoPath: point.photoPath,
        status: enumToString(point.status) ?? "",
        typeCapture: enumToString(point.captureType) ?? "",
        uniqueHash: point.uniqueHash,
        logs: point.logs,
        tabletSession: point.tabletSession,
        reference: point.reference,
        numCra: point.numCra,
        numCad: point.numCad,
      );

  DigitalPointEntity toEntity() => DigitalPointEntity(
        id: id,
        date: date,
        latitude: latitude,
        longitude: longitude,
        typePoint: stringToEnum(DigitalPointTypeEnum.values, typePoint) ??
            DigitalPointTypeEnum.offline,
        photoTempHash: photoTempHash,
        photoPath: photoPath,
        status: stringToEnum(DigitalPointStatusEnum.values, status) ??
            DigitalPointStatusEnum.pending,
        captureType: stringToEnum(DigitalPointCaptureTypeEnum.values, status) ??
            DigitalPointCaptureTypeEnum.automatic,
        uniqueHash: uniqueHash,
        logs: logs,
        tabletSession: tabletSession ?? false,
        reference: reference,
        numCra: numCra,
        numCad: numCad,
      );

  DigitalPointModel copyWith({
    int? id,
    DateTime? date,
    String? latitude,
    String? longitude,
    String? photoPath,
    String? photoTempHash,
    String? typePoint,
    String? typeCapture,
    String? status,
    String? uniqueHash,
    List<DigitalPointLogData>? logs,
    bool? tabletSession,
    String? reference,
    String? numCra,
    String? numCad,
  }) {
    return DigitalPointModel(
      id: id ?? this.id,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPath: photoPath ?? this.photoPath,
      photoTempHash: photoTempHash ?? this.photoTempHash,
      typePoint: typePoint ?? this.typePoint,
      typeCapture: typeCapture ?? this.typeCapture,
      status: status ?? this.status,
      uniqueHash: uniqueHash ?? this.uniqueHash,
      logs: logs ?? this.logs,
      tabletSession: tabletSession ?? this.tabletSession,
      reference: reference ?? this.reference,
      numCra: numCra ?? this.numCra,
      numCad: numCad ?? this.numCad,
    );
  }
}
