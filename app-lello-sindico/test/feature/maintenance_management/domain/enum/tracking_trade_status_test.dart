import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';

void main() {
  group('TrackingTradeStatusExtension.fromApiValue', () {
    test('parses ACTIVE values', () {
      expect(
        TrackingTradeStatusExtension.fromApiValue('ACTIVE'),
        TrackingTradeStatus.active,
      );
      expect(
        TrackingTradeStatusExtension.fromApiValue('active'),
        TrackingTradeStatus.active,
      );
      expect(
        TrackingTradeStatusExtension.fromApiValue(' Active '),
        TrackingTradeStatus.active,
      );
    });

    test('parses INACTIVE value', () {
      expect(
        TrackingTradeStatusExtension.fromApiValue('INACTIVE'),
        TrackingTradeStatus.inactive,
      );
    });

    test('parses SERVICE_UNAVAILABLE variants', () {
      expect(
        TrackingTradeStatusExtension.fromApiValue('SERVICE_UNAVAILABLE'),
        TrackingTradeStatus.serviceUnavailable,
      );
      expect(
        TrackingTradeStatusExtension.fromApiValue('service-unavailable'),
        TrackingTradeStatus.serviceUnavailable,
      );
      expect(
        TrackingTradeStatusExtension.fromApiValue('service unavailable'),
        TrackingTradeStatus.serviceUnavailable,
      );
    });

    test('returns null for unknown or empty values', () {
      expect(TrackingTradeStatusExtension.fromApiValue(null), isNull);
      expect(TrackingTradeStatusExtension.fromApiValue(''), isNull);
      expect(TrackingTradeStatusExtension.fromApiValue('UNKNOWN_STATUS'), isNull);
    });
  });

  group('TrackingTradeStatusExtension.apiValue', () {
    test('maps enum to API value', () {
      expect(TrackingTradeStatus.active.apiValue, 'ACTIVE');
      expect(TrackingTradeStatus.inactive.apiValue, 'INACTIVE');
      expect(
        TrackingTradeStatus.serviceUnavailable.apiValue,
        'SERVICE_UNAVAILABLE',
      );
    });
  });
}
