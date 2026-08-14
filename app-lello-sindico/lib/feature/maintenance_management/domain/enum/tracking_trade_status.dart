enum TrackingTradeStatus {
  inactive,
  active,
  serviceUnavailable,
}

extension TrackingTradeStatusExtension on TrackingTradeStatus {
  static TrackingTradeStatus? fromApiValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final normalized = value
        .trim()
        .toUpperCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    switch (normalized) {
      case 'INACTIVE':
        return TrackingTradeStatus.inactive;
      case 'ACTIVE':
        return TrackingTradeStatus.active;
      case 'SERVICE_UNAVAILABLE':
        return TrackingTradeStatus.serviceUnavailable;
      default:
        return null;
    }
  }

  String get apiValue {
    switch (this) {
      case TrackingTradeStatus.inactive:
        return 'INACTIVE';
      case TrackingTradeStatus.active:
        return 'ACTIVE';
      case TrackingTradeStatus.serviceUnavailable:
        return 'SERVICE_UNAVAILABLE';
    }
  }

  bool get isActive => this == TrackingTradeStatus.active;
}
