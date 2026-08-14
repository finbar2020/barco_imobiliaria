class LedgerAccountBalance {
  final double balance;

  LedgerAccountBalance({
    required this.balance,
  });

  LedgerAccountBalance copyWith({
    double? balance,
  }) {
    return LedgerAccountBalance(
      balance: balance ?? this.balance,
    );
  }
}
