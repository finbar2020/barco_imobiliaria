import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';

class IaBellaMessageResponseEntity {
  String? timestamp;
  int? statusCode;
  IaBellaDataEntity? data;
  String? errorMessage;

  IaBellaMessageResponseEntity({
    this.timestamp,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  IaBellaMessageResponseEntity copyWith({
    String? timestamp,
    int? statusCode,
    IaBellaDataEntity? data,
    String? errorMessage,
  }) {
    return IaBellaMessageResponseEntity(
      timestamp: timestamp ?? this.timestamp,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
