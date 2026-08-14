class ExpireCache {
  static condominiumBalance(DateTime? lastUpdateAt) => lastUpdateAt == null
      ? false
      : DateTime.now().difference(lastUpdateAt).inMinutes > 60;
  static condominiumBalanceDetail(DateTime? lastUpdateAt) =>
      lastUpdateAt == null
          ? false
          : DateTime.now().difference(lastUpdateAt).inMinutes > 60;
  static bool banners(DateTime? lastUpdateAt) => lastUpdateAt == null
      ? true
      : DateTime.now().difference(lastUpdateAt).inHours > 1;
  static bool bannersHomolog(DateTime? lastUpdateAt) => lastUpdateAt == null
      ? true
      : DateTime.now().difference(lastUpdateAt).inMinutes > 1;
}
