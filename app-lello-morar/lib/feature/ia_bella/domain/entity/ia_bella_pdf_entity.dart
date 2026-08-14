class IaBellaPdfEntity {
  String? content;
  String? fileName;

  IaBellaPdfEntity({
    this.content,
    this.fileName,
  });

  IaBellaPdfEntity copyWith({
    String? content,
    String? fileName,
  }) {
    return IaBellaPdfEntity(
      content: content ?? this.content,
      fileName: fileName ?? this.fileName,
    );
  }
}
