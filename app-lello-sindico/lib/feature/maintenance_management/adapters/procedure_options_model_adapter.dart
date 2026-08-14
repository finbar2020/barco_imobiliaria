import '../data/model/procedure_options_model.dart';
import '../domain/entity/procedure_options_entity.dart';

class ProcedureOptionsModelAdapter {
  static ProcedureOptionsEntity toEntity(ProcedureOptionsModel model) {
    return ProcedureOptionsEntity(
      procedureOptions: model.procedureOptions
          .map((option) => _procedureOptionToEntity(option))
          .toList(),
    );
  }

  static ProcedureOptionEntity _procedureOptionToEntity(ProcedureOptionModel model) {
    return ProcedureOptionEntity(
      id: model.id,
      title: model.title,
      titleKey: model.titleKey,
      description: model.description,
      urlImage: model.urlImage,
      procedureId: model.procedureId,
      procedureGroupId: model.procedureGroupId,
      procedureGroup: model.procedureGroup,
      firstResponsible: model.firstResponsible != null
          ? _firstResponsibleToEntity(model.firstResponsible!)
          : null,
    );
  }

  static FirstResponsibleEntity _firstResponsibleToEntity(FirstResponsibleModel model) {
    return FirstResponsibleEntity(
      id: model.id,
      name: model.name,
    );
  }
}
