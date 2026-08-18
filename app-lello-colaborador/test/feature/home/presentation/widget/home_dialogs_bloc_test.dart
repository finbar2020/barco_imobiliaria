import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeDialogEvent', () {
    test('InitialEvent é igual', () {
      expect(const InitialEvent(), const InitialEvent());
    });
  });

  group('HomeDialogState', () {
    test('estados iniciais são iguais', () {
      expect(const HomeDialogInitialState(), const HomeDialogInitialState());
      expect(
        const NotificationPermissionState(),
        const NotificationPermissionState(),
      );
    });
  });
}
