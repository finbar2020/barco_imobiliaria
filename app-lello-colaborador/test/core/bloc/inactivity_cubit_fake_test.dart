import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InactivityCubit', () {
    test('cancel emite estado vazio', () {
      final cubit = InactivityCubit(sessionBloc: FakeSessionBloc());
      addTearDown(cubit.close);

      cubit.cancel();

      expect(cubit.state, isA<TimeoutEmptyState>());
    });

    test('start ativa timer e cancel desativa', () {
      final cubit = InactivityCubit(sessionBloc: FakeSessionBloc());
      addTearDown(cubit.close);

      cubit.start();
      expect(cubit.isActive(), isTrue);

      cubit.cancel();
      expect(cubit.isActive(), isFalse);
    });

    test('setOffset atualiza posição da bolha', () {
      final cubit = InactivityCubit(sessionBloc: FakeSessionBloc());
      addTearDown(cubit.close);
      const offset = Offset(10, 20);

      cubit.setOffset(offset);

      expect(cubit.offsetBubble, offset);
    });

    test('reset restaura contagem', () {
      final cubit = InactivityCubit(sessionBloc: FakeSessionBloc());
      addTearDown(cubit.close);

      cubit.start();
      cubit.reset();

      expect(cubit.countDown, cubit.duration - 1);
    });
  });
}
