class LocalLookupEntity {
  final String id;
  final String name;
  final String hierarchyLocals;

  LocalLookupEntity({
    required this.id,
    required this.name,
    required this.hierarchyLocals,
  });
}

class LocalsLookupEntity {
  final List<LocalLookupEntity> locals;

  LocalsLookupEntity({
    required this.locals,
  });
}
