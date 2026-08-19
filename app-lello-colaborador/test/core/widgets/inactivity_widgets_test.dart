import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_state.dart';
import 'package:colaborador/core/widgets/inactivity_bloc_builder_widget.dart';
import 'package:colaborador/core/widgets/inactivity_timer_draggable.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _TabletSessionBloc extends Fake implements SessionBloc {
  _TabletSessionBloc({this.isTabletSession = true});

  final bool isTabletSession;

  late final Session _session = Session(
    me: testMe(isTabletSession: isTabletSession)
      ..isTabletSession = isTabletSession,
    condominium: testCondominium(),
  );

  @override
  Session? get getSession => _session;

  @override
  SessionState get state =>
      SessionLoadedState(session: _session, isTabletSession: isTabletSession);
}

Future<void> _pumpBuilder(WidgetTester tester, InactivityCubit cubit) => pumpApp(
      tester,
      Stack(children: [InactivityBlocBuilder(inactivityCubit: cubit)]),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 800),
    );

void main() {
  group('InactivityBlocBuilder', () {
    testWidgets('não mostra nada fora da contagem regressiva', (tester) async {
      final cubit = InactivityCubit(sessionBloc: _TabletSessionBloc());
      addTearDown(cubit.close);

      await _pumpBuilder(tester, cubit);
      await tester.pump();

      expect(find.byType(InactivityTimerDraggable), findsNothing);
      expect(find.byType(Draggable), findsNothing);
    });

    testWidgets('mostra a contagem regressiva em sessão de tablet',
        (tester) async {
      final cubit = InactivityCubit(sessionBloc: _TabletSessionBloc());
      addTearDown(cubit.close);

      cubit.start();
      await _pumpBuilder(tester, cubit);
      await tester.pump(const Duration(seconds: 1));

      expect(cubit.isActive(), isTrue);
      expect(find.byType(InactivityTimerDraggable), findsOneWidget);

      cubit.cancel();
      await tester.pump();
      await tester.pump();
      expect(find.byType(InactivityTimerDraggable), findsNothing);
    });

    testWidgets('fora do tablet a contagem não é exibida', (tester) async {
      final cubit = InactivityCubit(
        sessionBloc: _TabletSessionBloc(isTabletSession: false),
      );
      addTearDown(cubit.close);

      cubit.start();
      await _pumpBuilder(tester, cubit);
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(InactivityTimerDraggable), findsNothing);

      cubit.cancel();
      await tester.pump();
    });
  });

  group('InactivityTimerDraggable', () {
    testWidgets('nos últimos segundos o contador cresce', (tester) async {
      await pumpApp(
        tester,
        const InactivityTimerDraggable(timer: 5, duration: 60),
        localized: true,
        shrinkWrap: false,
        settle: false,
        surface: const Size(400, 800),
      );

      expect(find.text('5s'), findsOneWidget);
      final box = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.height, 60);
    });

    testWidgets('fora dos últimos segundos o contador é menor',
        (tester) async {
      await pumpApp(
        tester,
        const InactivityTimerDraggable(timer: 40, duration: 60),
        localized: true,
        shrinkWrap: false,
        settle: false,
        surface: const Size(400, 800),
      );

      expect(find.text('40s'), findsOneWidget);
      final box = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.height, 50);
    });
  });

  group('InactivityCubit', () {
    testWidgets('arrastar a bolha guarda a nova posição', (tester) async {
      final cubit = InactivityCubit(sessionBloc: _TabletSessionBloc());
      addTearDown(cubit.close);

      // A posição inicial é calculada com o tamanho da view padrão e ficaria
      // fora da superfície do teste, impedindo o hit test do arraste.
      cubit.setOffset(const Offset(60, 60));
      cubit.start();
      await _pumpBuilder(tester, cubit);
      await tester.pump(const Duration(seconds: 1));

      final before = cubit.offsetBubble;
      await tester.drag(
        find.byType(InactivityTimerDraggable),
        const Offset(-40, -60),
      );
      await tester.pump();

      expect(cubit.offsetBubble, isNot(before));

      cubit.cancel();
      await tester.pump();
    });

    test('cancel encerra o timer e emite estado vazio', () async {
      final cubit = InactivityCubit(sessionBloc: _TabletSessionBloc());
      addTearDown(cubit.close);

      cubit.start();
      expect(cubit.isActive(), isTrue);

      cubit.cancel();
      expect(cubit.isActive(), isFalse);
      expect(cubit.state, isA<TimeoutEmptyState>());
    });

    test('setOffset guarda a posição da bolha', () {
      final cubit = InactivityCubit(sessionBloc: _TabletSessionBloc());
      addTearDown(cubit.close);

      cubit.setOffset(const Offset(10, 20));

      expect(cubit.offsetBubble, const Offset(10, 20));
    });
  });
}
