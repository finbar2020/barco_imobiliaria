class SendTokenRequestEntity {
  final String? method;
  final String? value;

  SendTokenRequestEntity({
    this.method,
    this.value,
  });

  SendTokenRequestEntity copyWith({
    String? method,
    String? value,
  }) {
    return SendTokenRequestEntity(
      method: method ?? this.method,
      value: value ?? this.value,
    );
  }
}
