class SendTokenData {
  final int? id;

  SendTokenData({
    required this.id,
  });

  SendTokenData copyWith({
    int? id,
  }) {
    return SendTokenData(
      id: id ?? this.id,
    );
  }
}
