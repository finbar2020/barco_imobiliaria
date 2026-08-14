import 'package:essentials/essentials.dart';
import 'condominium_info_model.dart';

part 'workflow_data_model.g.dart';

/// Modelo Flutter que corresponde ao WorkFlowData do backend C#
@JsonSerializable()
class WorkflowDataModel {
  final String id;
  final String assets;
  final String floor;
  final int localsCount;
  final String workflowUsers;
  final String condominiumName;
  final int blocksCount;
  final int unitsCount;

  WorkflowDataModel({
    required this.id,
    required this.assets,
    required this.floor,
    required this.localsCount,
    required this.workflowUsers,
    required this.condominiumName,
    required this.blocksCount,
    required this.unitsCount,
  });

  factory WorkflowDataModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowDataModelToJson(this);

  /// Converte para CondominiumInfoModel (compatibilidade com código existente)
  CondominiumInfoModel toCondominiumInfoModel() {
    return CondominiumInfoModel(
      id: id,
      assets: int.tryParse(assets) ?? 0, // Converte string para int
      floor: floor,
      localsCount: localsCount,
      workflowUsers: workflowUsers,
      condominiumName: condominiumName,
      blocksCount: blocksCount,
      unitsCount: unitsCount,
      references: [], // Lista vazia como padrão
    );
  }
}
