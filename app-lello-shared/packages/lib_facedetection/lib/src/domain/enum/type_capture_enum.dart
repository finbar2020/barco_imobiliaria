enum TypeCaptureEnum {
  manual,
  automatic,
  lifeValidation,
}

extension TypeCaptureEnumExtention on TypeCaptureEnum {
  bool get isManual => this == TypeCaptureEnum.manual;
  bool get isAutomatic => this == TypeCaptureEnum.automatic;
  bool get isLifeValidation => this == TypeCaptureEnum.lifeValidation;
}
