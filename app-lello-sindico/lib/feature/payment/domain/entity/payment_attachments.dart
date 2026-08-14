class PaymentAttachments {
  final String? type;
  final String? content;
  final String? name;

  PaymentAttachments({
    this.type,
    this.content,
    this.name,
  });

  PaymentAttachments copyWith({
    String? type,
    String? content,
    String? name,
  }) {
    return PaymentAttachments(
      type: type ?? this.type,
      content: content ?? this.content,
      name: name ?? this.name,
    );
  }
}
