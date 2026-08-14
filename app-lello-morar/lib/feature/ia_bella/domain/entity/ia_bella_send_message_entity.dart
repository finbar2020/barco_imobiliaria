class IaBellaSendMessageEntity {
  String? message;
  String? sessionId;

  IaBellaSendMessageEntity({
    this.message,
    this.sessionId,
  });

  IaBellaSendMessageEntity copyWith({
    String? message,
    String? sessionId,
  }) {
    return IaBellaSendMessageEntity(
      message: message ?? this.message,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}
