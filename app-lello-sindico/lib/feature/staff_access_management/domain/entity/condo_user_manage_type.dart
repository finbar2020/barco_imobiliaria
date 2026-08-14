enum CondoUserManageType {
  executiveBody, // 'CorpoDiretivo'
  otherUsers // 'OutrosUsuarios'
}

extension CondoUserManageTypeExtension on CondoUserManageType {
  String toFormatString() {
    if (this == CondoUserManageType.executiveBody) {
      return "executiveBody";
    }
    return "otherUsers";
  }
}
