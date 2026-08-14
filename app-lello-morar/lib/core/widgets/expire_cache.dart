class ExpireCache {
  static bool banners(DateTime? lastUpdateAt) => lastUpdateAt == null
      ? true
      : DateTime.now().difference(lastUpdateAt).inHours > 1;
  static bool bannersHomolog(DateTime? lastUpdateAt) => lastUpdateAt == null
      ? true
      : DateTime.now().difference(lastUpdateAt).inMinutes > 1;
}
