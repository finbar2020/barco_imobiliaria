class FirstResponsibleEntity {
  final String id;
  final String name;

  FirstResponsibleEntity({
    required this.id,
    required this.name,
  });
}

class ProcedureOptionEntity {
  final String id;
  final String title;
  final String? titleKey;
  final String? description;
  final String urlImage;
  final String? procedureId;
  final String? procedureGroupId;
  final dynamic procedureGroup;
  final FirstResponsibleEntity? firstResponsible;

  ProcedureOptionEntity({
    required this.id,
    required this.title,
    this.titleKey,
    this.description,
    required this.urlImage,
    this.procedureId,
    this.procedureGroupId,
    this.procedureGroup,
    this.firstResponsible,
  });
}

class ProcedureOptionsEntity {
  final List<ProcedureOptionEntity> procedureOptions;

  ProcedureOptionsEntity({
    required this.procedureOptions,
  });
}
