import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/status.dart';
part 'status_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StatusModel {
  final int? idStatus;
  final String? descricaoStatus;
  final dynamic flagStatus;
  final List<dynamic> listStatusTipoStatusVO;

  StatusModel({
    this.idStatus,
    this.descricaoStatus,
    this.flagStatus,
    this.listStatusTipoStatusVO = const [],
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusModelToJson(this);

  static StatusModel? fromEntity(StatusEntity? entity) {
    if (entity == null) return null;
    return StatusModel(
      idStatus: entity.idStatus,
      descricaoStatus: entity.descricaoStatus,
      flagStatus: entity.flagStatus,
      listStatusTipoStatusVO: entity.listStatusTipoStatusVO,
    );
  }

  StatusEntity toEntity() {
    return StatusEntity(
      idStatus: idStatus,
      descricaoStatus: descricaoStatus,
      flagStatus: flagStatus,
      listStatusTipoStatusVO: listStatusTipoStatusVO,
    );
  }
}
