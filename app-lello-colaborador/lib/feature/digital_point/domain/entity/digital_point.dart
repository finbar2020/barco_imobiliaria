// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:intl/intl.dart';

class DigitalPointEntity {
  final int? id;
  final DateTime date;
  final String latitude;
  final String longitude;
  final DigitalPointTypeEnum typePoint;
  final String photoPath;
  final DigitalPointStatusEnum status;
  final DigitalPointCaptureTypeEnum captureType;
  final String uniqueHash;
  final bool tabletSession;
  String? photoTempHash;
  List<DigitalPointLogData>? logs;
  String? reference;
  String? numCra;
  String? numCad;

  DigitalPointEntity({
    this.id,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.typePoint,
    required this.photoPath,
    required this.status,
    required this.captureType,
    required this.uniqueHash,
    required this.tabletSession,
    this.photoTempHash,
    this.logs,
    this.reference,
    this.numCra,
    this.numCad,
  });

  bool get isValid {
    if (photoPath.isEmpty) {
      return false;
    }
    return true;
  }

  String get dateFormatted {
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  String get timeFormatted {
    DateFormat format = DateFormat("HH:mm");
    return format.format(date);
  }

  DigitalPointEntity copyWith({
    int? id,
    DateTime? date,
    String? latitude,
    String? longitude,
    DigitalPointTypeEnum? typePoint,
    String? photoPath,
    DigitalPointStatusEnum? status,
    DigitalPointCaptureTypeEnum? captureType,
    String? uniqueHash,
    String? photoTempHash,
    List<DigitalPointLogData>? logs,
    bool? tabletSession,
    String? reference,
    String? numCra,
    String? numCad,
  }) {
    return DigitalPointEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      typePoint: typePoint ?? this.typePoint,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      captureType: captureType ?? this.captureType,
      uniqueHash: uniqueHash ?? this.uniqueHash,
      photoTempHash: photoTempHash ?? this.photoTempHash,
      logs: logs ?? this.logs,
      tabletSession: tabletSession ?? this.tabletSession,
      reference: reference ?? this.reference,
      numCra: numCra ?? this.numCra,
      numCad: numCad ?? this.numCad,
    );
  }
}
