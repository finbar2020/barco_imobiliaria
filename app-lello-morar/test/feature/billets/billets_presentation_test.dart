import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_bloc.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_event.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class _FakeBillets extends Fake implements BilletsUseCase {
  _FakeBillets({this.result, this.fail = false});

  final Paginator? result;
  final bool fail;
  BilletsParams? params;

  @override
  Future<Try<Paginator>> call(BilletsParams p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(result ?? Paginator(data: const [], meta: Meta()));
  }
}

class _FakePdf extends Fake implements BilletsPdfUseCase {
  _FakePdf({this.fail = false});

  final bool fail;
  final calls = <String>[];

  @override
  Future<Try<DocumentFile>> call(BilletsPdfParams p) async {
    calls.add(p.nrBillet);
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(DocumentFile(name: 'f.pdf', data: 'ZGF0YQ=='));
  }
}

Future<List<dynamic>> _collect(BilletsBloc bloc, Future<void> Function() run,
    {int expected = 2}) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('BilletsBloc', () {
    test('mapeia eventos em estados', () async {
      final bloc = BilletsBloc();
      expect(bloc.state, const BilletsInitialState());
      final billet = Billet(id: '1');
      final states = <dynamic>[];
      final sub = bloc.stream.listen(states.add);
      bloc
        ..add(BilletsLoadingEvent(billet: billet))
        ..add(BilletsLoadedEvent(billets: [billet], allBillets: 4))
        ..add(BilletsShowInfoEvent(billet: billet, pdf: 'p', fileName: 'n'))
        ..add(const BilletsFailureEvent(error: 'e'))
        ..add(const BilletsEmptyEvent());
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      await bloc.close();
      expect(states, [
        BilletsLoadingState(billet: billet),
        BilletsLoadedState(billets: [billet], allBillets: 4),
        BilletsShowInfoState(billet: billet, pdf: 'p', fileName: 'n'),
        const BilletsFailureState(errorMessageKey: 'e'),
        const BilletsInitialState(),
      ]);
    });

    test('estados e eventos são comparáveis', () {
      expect(const BilletsLoadingEvent().props, [null]);
      expect(const BilletsEmptyEvent().props, [null]);
      expect(const BilletsFailureEvent(error: 'e').props, ['e', null]);
      expect(const BilletsInitialState().props, [const [], 0, null]);
    });
  });

  group('BilletsController', () {
    late BilletsBloc bloc;
    late FakeSessionBloc sessionBloc;

    setUp(() {
      bloc = BilletsBloc();
      sessionBloc = FakeSessionBloc();
    });

    tearDown(() => bloc.close());

    BilletsController build({_FakeBillets? billets, _FakePdf? pdf}) =>
        BilletsController(
          bloc: bloc,
          billetsUseCase: billets ?? _FakeBillets(),
          billetsPdf: pdf ?? _FakePdf(),
          sessionBloc: sessionBloc,
        );

    test('getBillets carrega a lista e loga analytics', () async {
      final useCase = _FakeBillets(
        result: Paginator(
          meta: Meta(totalItems: 7),
          data: [
            {'id': '1', 'situation': 'pendente'},
            {'id': '2', 'situation': 'baixado'},
          ],
        ),
      );
      final controller = build(billets: useCase);
      final states = await _collect(bloc, controller.getBillets);
      expect(states.first, isA<BilletsLoadingState>());
      final loaded = states.last as BilletsLoadedState;
      expect(loaded.billets.map((b) => b.id), ['1', '2']);
      expect(loaded.allBillets, 7);
      expect(useCase.params!.reference, 'R1');
      expect(useCase.params!.unitId, '101');
      expect(fakeAnalytics.eventNames, contains('boletos_acessar'));
    });

    test('getBillets vazio volta ao estado inicial', () async {
      final controller = build();
      final states = await _collect(bloc, controller.getBillets);
      expect(states.last, const BilletsInitialState());
    });

    test('getBillets falha vira BilletsFailureState', () async {
      final controller = build(billets: _FakeBillets(fail: true));
      final states = await _collect(bloc, controller.getBillets);
      expect(states.last,
          const BilletsFailureState(errorMessageKey: 'billets_error'));
    });

    test('getBillets com payload inválido vira falha', () async {
      final controller = build(
        billets: _FakeBillets(
          result: Paginator(data: ['nao é mapa'], meta: Meta()),
        ),
      );
      final states = await _collect(bloc, controller.getBillets);
      expect(states.last, isA<BilletsFailureState>());
    });

    test('showBillet sem pdf para status não elegível', () async {
      final pdf = _FakePdf();
      final controller = build(pdf: pdf);
      final billet = Billet(id: '1', situation: BilletStatusEnum.cancelado);
      final states = await _collect(bloc, () => controller.showBillet(billet));
      expect(states.single, BilletsShowInfoState(billet: billet));
      expect(pdf.calls, isEmpty);
    });

    test('showBillet pendente baixa o pdf e loga analytics', () async {
      final pdf = _FakePdf();
      final controller = build(pdf: pdf);
      final billet = Billet(
        id: '1',
        nrBillet: '55',
        situation: BilletStatusEnum.pendente,
      );
      fakeAnalytics.reset();
      final states = await _collect(bloc, () => controller.showBillet(billet));
      expect(states.first, BilletsLoadingState(billet: billet));
      expect(
        states.last,
        BilletsShowInfoState(billet: billet, pdf: 'ZGF0YQ==', fileName: 'f.pdf'),
      );
      expect(pdf.calls, ['55']);
      expect(fakeAnalytics.eventNames, contains('boletos_acessar_vencido'));
    });

    test('showBillet baixado com erro no pdf', () async {
      final controller = build(pdf: _FakePdf(fail: true));
      final billet = Billet(
        id: '1',
        nrBillet: '55',
        situation: BilletStatusEnum.baixado,
      );
      fakeAnalytics.reset();
      final states = await _collect(bloc, () => controller.showBillet(billet));
      expect(
        states.last,
        BilletsFailureState(errorMessageKey: 'billets_error', billet: billet),
      );
      expect(fakeAnalytics.eventNames, isNot(contains('boletos_acessar_vencido')));
    });
  });
}
