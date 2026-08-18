import 'package:colaborador/feature/home/presentation/bloc/register_point_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterPointEvent', () {
    test('eventos sem props são iguais', () {
      expect(const StartRegisterPointEvent(), const StartRegisterPointEvent());
      expect(const RegisterPointSuccessEvent(), const RegisterPointSuccessEvent());
      expect(const NoLocationPermissionEvent(), const NoLocationPermissionEvent());
      expect(const OutOfRangeEvent(), const OutOfRangeEvent());
      expect(const OfflineFailureEvent(), const OfflineFailureEvent());
    });

    test('RegisterPointFailureEvent compara message', () {
      const a = RegisterPointFailureEvent(message: 'erro');
      const b = RegisterPointFailureEvent(message: 'erro');
      const c = RegisterPointFailureEvent(message: 'outro');
      expect(a, b);
      expect(a, isNot(c));
      expect(a.props, ['erro']);
    });

    test('WorkLeaveEvent compara description', () {
      const a = WorkLeaveEvent(description: 'afastado');
      const b = WorkLeaveEvent(description: 'afastado');
      expect(a, b);
      expect(a.props, ['afastado']);
    });

    test('DeviceTypeFailureEvent compara flags', () {
      const a = DeviceTypeFailureEvent(onlyTablet: true);
      const b = DeviceTypeFailureEvent(onlyTablet: true);
      const c = DeviceTypeFailureEvent(onlyPhone: true);
      expect(a, b);
      expect(a, isNot(c));
      expect(a.props, [true, false]);
    });
  });
}
