import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';

class IaBellaStartSessionEntity {
  final String? timestamp;
  final int? statusCode;
  final IaBellaDataEntity? data;
  final String? errorMessage;

  IaBellaStartSessionEntity({
    this.timestamp,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  IaBellaStartSessionEntity copyWith({
    String? timestamp,
    int? statusCode,
    IaBellaDataEntity? data,
    String? errorMessage,
  }) {
    return IaBellaStartSessionEntity(
      timestamp: timestamp ?? this.timestamp,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
