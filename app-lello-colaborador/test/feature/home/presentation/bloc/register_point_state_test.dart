import 'package:colaborador/feature/home/presentation/bloc/register_point_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterPointState', () {
    test('estados sem props são iguais', () {
      expect(const RegisterPointInitialState(), const RegisterPointInitialState());
      expect(const StartRegisterPointState(), const StartRegisterPointState());
      expect(const RegisterPointFaceCaptureState(), const RegisterPointFaceCaptureState());
      expect(const NoLocationPermissionState(), const NoLocationPermissionState());
      expect(const OutOfRangeState(), const OutOfRangeState());
      expect(const OfflineFailureState(), const OfflineFailureState());
    });

    test('RegisterPointFailureState compara message', () {
      const a = RegisterPointFailureState(message: 'erro');
      const b = RegisterPointFailureState(message: 'erro');
      expect(a, b);
      expect(a.props, ['erro']);
    });

    test('WorkLeaveState compara description', () {
      const a = WorkLeaveState(description: 'licença');
      const b = WorkLeaveState(description: 'licença');
      expect(a, b);
      expect(a.props, ['licença']);
    });

    test('DeviceTypeFailureState compara flags', () {
      const a = DeviceTypeFailureState(onlyPhone: true);
      const b = DeviceTypeFailureState(onlyPhone: true);
      const c = DeviceTypeFailureState(onlyTablet: true);
      expect(a, b);
      expect(a, isNot(c));
      expect(a.props, [false, true]);
    });
  });
}
