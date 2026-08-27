import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_event.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_event.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';

import 'payroll_test_helpers.dart';

void main() {
  late PayrollEnv env;

  setUp(() => env = PayrollEnv());

  group('PayrollBloc', () {
    test('ao nascer com sessão carrega a lista de folhas', () async {
      env.stubPayrolls([payrollJson(period: '2026-07-01T00:00:00.000'), payrollJson()]);
      final states = <PayrollState>[];
      final bloc = env.payrollBloc();
      expect(bloc.state, isA<PayrollLoadingState>());
      expect(bloc.state.props, [<Object>[], null, null]);
      bloc.stream.listen(states.add);
      await drain();

      expect(env.paths, [payrollsPath]);
      expect(states, hasLength(2));
      expect(states[0], isA<PayrollLoadingState>());
      expect(states[0].condominiumId, 'C1');
      final loaded = states[1] as PayrollListLoadedState;
      expect(loaded.data, hasLength(2));
      expect(loaded.detail, isNull);
      expect(loaded.data.last.period, DateTime(2026, 8));
      await bloc.close();
    });

    test('sem sessão usa condomínio vazio e falha na validação', () async {
      final bloc = env.payrollBloc(withSession: false);
      await drain();
      final failed = bloc.state as PayrollLoadFailedState;
      expect(failed.condominiumId, '');
      expect(failed.error, isA<InvalidParamFailure>());
      expect(failed.props.last, failed.error);
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('falha na lista emite LoadFailed', () async {
      env.http.failAll();
      final bloc = env.payrollBloc();
      await drain();
      expect((bloc.state as PayrollLoadFailedState).error, isA<UnknownFailure>());
      await bloc.close();
    });

    test('beginLoad busca a folha do período e emite Loaded com o detalhe', () async {
      env.stubPayrolls([payrollJson()]);
      env.stubPayroll('2026-08', payrollJson(type: 'Adiantamento'));
      final bloc = env.payrollBloc();
      await drain();
      final states = <PayrollState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoad(DateTime(2026, 8, 10));
      await drain();

      expect(env.paths.last, '$payrollsPath/2026-08');
      expect(states[0], isA<PayrollLoadingState>());
      expect(states[0].data, hasLength(1));
      final loaded = states[1] as PayrollLoadedState;
      expect(loaded.detail?.type, 'Adiantamento');
      expect(loaded.data, hasLength(1));
      expect(loaded.condominiumId, 'C1');

      env.http.failAll();
      bloc.beginLoad(DateTime(2026, 7));
      await drain();
      final failed = bloc.state as PayrollLoadFailedState;
      expect(failed.detail?.type, 'Adiantamento');
      expect(failed.data, hasLength(1));
      await bloc.close();
    });

    test('eventos e estados comparáveis por valor', () {
      final periodo = DateTime(2026, 8);
      expect(PayrollLoadEvent(condominiumId: 'C1', period: periodo),
          PayrollLoadEvent(condominiumId: 'C1', period: periodo));
      expect(PayrollLoadEvent(condominiumId: 'C1', period: periodo).props, ['C1', periodo]);
      expect(const PayrollLoadListEvent(condominiumId: 'C1').props, ['C1']);
      expect(const PayrollInitialState([], 'C1').detail, isNull);
      expect(const PayrollInitialState([], 'C1').props, [<Object>[], null, 'C1']);
      final p = payroll();
      expect(PayrollLoadedState(const [], p, 'C1'), PayrollLoadedState(const [], p, 'C1'));
    });
  });

  group('PayrollEntryBloc', () {
    test('beginLoad sem sessão não faz nada', () async {
      final bloc = env.entryBloc(withSession: false);
      expect(bloc.state, isA<PayrollEntryLoadingState>());
      expect(bloc.state.props, [<Object>[], null, null]);
      bloc.beginLoad(payroll());
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('beginLoad lista os lançamentos do período da folha', () async {
      env.stubEntries('2026-08', [payrollEntryJson(), payrollEntryJson(id: 'PE2', title: 'INSS')]);
      final states = <PayrollEntryState>[];
      final bloc = env.entryBloc();
      bloc.stream.listen(states.add);

      bloc.beginLoad(payroll());
      await drain();

      expect(env.paths, ['$payrollsPath/2026-08/entries']);
      expect(states[0], isA<PayrollEntryLoadingState>());
      expect(states[0].payroll?.type, 'Mensal');
      final loaded = states[1] as PayrollEntryLoadedState;
      expect(loaded.data.map((e) => e.title), ['Salário', 'INSS']);
      expect(loaded.condominiumId, 'C1');

      env.http.failAll();
      bloc.beginLoad(payroll());
      await drain();
      final failed = bloc.state as PayrollEntryLoadFailedState;
      expect(failed.data, hasLength(2));
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.props.last, failed.error);
      await bloc.close();
    });

    test('evento comparável por valor', () {
      final p = payroll();
      expect(PayrollEntryLoadEvent(condominiumId: 'C1', payroll: p),
          PayrollEntryLoadEvent(condominiumId: 'C1', payroll: p));
      expect(PayrollEntryLoadEvent(condominiumId: 'C1', payroll: p).props, ['C1', p]);
    });
  });
}
