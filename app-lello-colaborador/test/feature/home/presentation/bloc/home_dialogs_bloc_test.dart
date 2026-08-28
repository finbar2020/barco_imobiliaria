import 'dart:convert';

import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fake_permission_handler.dart';
import '../../../../helpers/fixtures.dart';

Future<HomeDialogState> _waitFor(
  HomeDialogBloc bloc,
  bool Function(HomeDialogState) test,
) =>
    bloc.stream.firstWhere(test);

HomeDialogBloc _bloc() {
  final bloc = HomeDialogBloc(sessionBloc: FakeSessionBloc());
  addTearDown(bloc.close);
  return bloc;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeDialogBloc', () {
    test('permissão de notificação negada pede a autorização', () async {
      SharedPreferences.setMockInitialValues({});
      setFakePermissionHandler(
        FakePermissionHandler(status: PermissionStatus.denied),
      );

      final bloc = _bloc();

      expect(
        await _waitFor(bloc, (s) => s is NotificationPermissionState),
        isA<NotificationPermissionState>(),
      );
      expect(bloc.jumpFirstStep, isTrue);
    });

    test('permissão permanentemente negada também pede autorização',
        () async {
      SharedPreferences.setMockInitialValues({});
      setFakePermissionHandler(
        FakePermissionHandler(status: PermissionStatus.permanentlyDenied),
      );

      final bloc = _bloc();

      expect(
        await _waitFor(bloc, (s) => s is NotificationPermissionState),
        isA<NotificationPermissionState>(),
      );

      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(SharedPreferencesKeys.notificationPermission),
        isNotNull,
      );
    });

    test('permissão concedida não abre nenhum diálogo', () async {
      SharedPreferences.setMockInitialValues({});
      setFakePermissionHandler(
        FakePermissionHandler(status: PermissionStatus.granted),
      );

      final bloc = _bloc();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state, isA<HomeDialogInitialState>());
      expect(bloc.jumpFirstStep, isFalse);
    });

    test('com a permissão já respondida antes o fluxo não repete', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.notificationPermission:
            json.encode({'accept': true}),
      });
      setFakePermissionHandler(
        FakePermissionHandler(status: PermissionStatus.denied),
      );

      final bloc = _bloc();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state, isA<HomeDialogInitialState>());
    });
  });
}
