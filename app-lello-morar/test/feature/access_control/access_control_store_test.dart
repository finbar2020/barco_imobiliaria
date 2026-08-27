import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_bloc.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_event.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_provider_controller.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_visitant_controller.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _Flags {
  bool failSave = false;
  bool failEdit = false;
  bool failAdd = false;
  bool failInvite = false;
  bool failDelete = false;
  bool failDeleteVisit = false;
  bool failEditVisit = false;
  bool failList = false;
  final calls = <String>[];
}

AccessControl _gest({String type = 'GEST', String? id = 'g1', String? document = '123.456.789-01', bool withUnit = true}) => AccessControl(
      idGest: id,
      name: 'Carlos',
      document: document,
      phone: '(11) 99999-8888',
      type: type,
      gestUnits: [
        if (withUnit)
          AccessControlGestUnits(
            idGestUnit: 'gu',
            unit: testUnity(id: 'u9'),
            observation: 'obs',
            autorizationTypeInt: 1,
            authorizations: const [],
          ),
      ],
    );

AccessControlAuthorizations _auth({bool? facial, String? id = 'rec'}) => AccessControlAuthorizations(
      id: id,
      start: '2026-03-01T10:00:00',
      useFacialBiometric: facial,
      recurrence: AccessControlRecurrence(recurrenceType: 'WEEKLY'),
    );

class _FakeGet extends Fake implements GetVisitants {
  _FakeGet(this.f);
  final _Flags f;
  @override
  Future<Try<List<AccessControl>>> call(GetVisitantsParam params) async {
    f.calls.add('list:${params.unitId}');
    if (f.failList) return Rejection(UnknownFailure('x'));
    return Success([_gest(), _gest(type: 'SERVICE', id: 'p1')]);
  }
}

class _FakeSave extends Fake implements SaveVisitant {
  _FakeSave(this.f);
  final _Flags f;
  AccessControlVisitant? visitant;
  @override
  Future<Try<AccessControl>> call(SaveVisitantParam params) async {
    visitant = params.visitant;
    f.calls.add('save');
    if (f.failSave) return Rejection(UnknownFailure('x'));
    return Success(AccessControl(idGest: 'novo'));
  }
}

class _FakeEdit extends Fake implements EditVisitant {
  _FakeEdit(this.f);
  final _Flags f;
  AccessControlVisitant? visitant;
  @override
  Future<Try<String>> call(EditVisitantParam params) async {
    visitant = params.visitant;
    f.calls.add('edit');
    if (f.failEdit) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeDeleteVisitant extends Fake implements DeleteVisitant {
  _FakeDeleteVisitant(this.f);
  final _Flags f;
  @override
  Future<Try<String>> call(DeleteVisitantParam params) async {
    f.calls.add('deleteVisitant:${params.gestId}');
    if (f.failDelete) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeAdd extends Fake implements AddVisit {
  _FakeAdd(this.f);
  final _Flags f;
  AddVisitParam? params;
  @override
  Future<Try<String>> call(AddVisitParam p) async {
    params = p;
    f.calls.add('add:${p.gestId}:${p.unitId}');
    if (f.failAdd) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeDeleteVisit extends Fake implements DeleteVisit {
  _FakeDeleteVisit(this.f);
  final _Flags f;
  @override
  Future<Try<String>> call(DeleteVisitParam params) async {
    f.calls.add('deleteVisit:${params.recurrenceId}');
    if (f.failDeleteVisit) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeEditVisit extends Fake implements EditVisit {
  _FakeEditVisit(this.f);
  final _Flags f;
  @override
  Future<Try<String>> call(EditVisitParam params) async {
    f.calls.add('editVisit:${params.recurrenceId}');
    if (f.failEditVisit) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeInvite extends Fake implements SendInviteUsecase {
  _FakeInvite(this.f);
  final _Flags f;
  AccessControlSendInviteEntity? body;
  @override
  Future<Try<String>> call(SendInviteParam params) async {
    body = params.body;
    f.calls.add('invite');
    if (f.failInvite) return Rejection(UnknownFailure('x'));
    return Success('https://link');
  }
}

void main() {
  late _Flags f;
  late FakeSessionBloc sessionBloc;
  late AccessControlStore store;
  late _FakeSave save;
  late _FakeEdit edit;
  late _FakeAdd add;
  late _FakeInvite invite;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    f = _Flags();
    sessionBloc = FakeSessionBloc();
    save = _FakeSave(f);
    edit = _FakeEdit(f);
    add = _FakeAdd(f);
    invite = _FakeInvite(f);
    store = AccessControlStore(
      bloc: AccessControlBloc(),
      getVisitantsUseCase: _FakeGet(f),
      save: save,
      edit: edit,
      deleteVisitantUsecase: _FakeDeleteVisitant(f),
      addVisit: add,
      deleteScheduled: _FakeDeleteVisit(f),
      editScheduled: _FakeEditVisit(f),
      sessionBloc: sessionBloc,
      sendInvite: invite,
    );
  });

  tearDown(() => store.bloc.close());

  test('bloc mapeia eventos', () async {
    final bloc = AccessControlBloc();
    final gest = _gest();
    final auth = _auth();
    final states = <dynamic>[];
    final sub = bloc.stream.listen(states.add);
    bloc
      ..add(const AccessControlLoadingEvent())
      ..add(const AccessControlFailureEvent())
      ..add(const AccessControlOnBoardingEvent())
      ..add(AccessControlLoadedEvent(visitants: [gest], providers: const []))
      ..add(SaveVisitantFailureEvent(visitants: const [], providers: const [], visitant: gest, model: auth, failureInvite: true))
      ..add(const SaveVisitantLoadedEvent(visitants: [], providers: [], useFacial: true, isVisitant: true, link: 'l'))
      ..add(EditVisitantEvent(visitant: gest, providers: const [], model: auth, visitants: const []))
      ..add(DeleteVisitantEvent(visitants: const [], providers: const [], visitant: gest))
      ..add(DeleteFailureVisitEvent(visitants: const [], providers: const [], visitant: gest, model: auth))
      ..add(const DeleteVisitEvent(isVisitant: true))
      ..add(SearchingVisitantEvent(visitants: [gest], providers: const []))
      ..add(SearchingProviderEvent(visitants: const [], providers: [gest]));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await sub.cancel();
    await bloc.close();
    expect(states.map((s) => s.runtimeType).toList(), [
      AccessControlLoadingState,
      AccessControlFailureState,
      AccessControlOnBoardingState,
      AccessControlLoadedState,
      SaveVisitantFailureState,
      SaveVisitantLoadedState,
      EditVisitantState,
      DeleteVisitantState,
      DeleteFailureVisitState,
      DeleteVisitState,
      SearchingVisitantState,
      SearchingProviderState,
    ]);
    expect((states[5] as SaveVisitantLoadedState).link, 'l');
    expect(EditVisitEvent(visitants: const [], providers: const [], model: auth).props.length, 3);
    expect(EditVisitState(visitants: const [], providers: const [], model: auth).props.length, 3);
    expect(const DeleteVisitEvent(isVisitant: false).props, [false]);
  });

  group('getLists', () {
    test('sem condomínio falha', () async {
      sessionBloc.session.condominium!.id = null;
      await store.getLists();
      await waitFor(() => store.bloc.state is AccessControlFailureState);
    });

    test('mostra onboarding para condomínio com biometria', () async {
      await store.getLists();
      await waitFor(() => store.bloc.state is AccessControlOnBoardingState);
      expect(f.calls, isEmpty);
    });

    test('fechar onboarding persiste e carrega listas', () async {
      await store.getLists(closeOnboarding: true);
      await waitFor(() => store.bloc.state is AccessControlLoadedState);
      expect(store.visitants.single.idGest, 'g1');
      expect(store.providers.single.idGest, 'p1');
      final prefs = await SharedPreferences.getInstance();
      final key = SharedPreferencesKeys.accessControlOnboarding.replaceAll('#ref', 'R1');
      expect(jsonDecode(prefs.getString(key)!)['onboarding'], isFalse);

      // com o onboarding fechado não mostra de novo
      await store.getLists();
      await waitFor(() => store.bloc.state is AccessControlLoadedState);
      expect(f.calls.where((c) => c.startsWith('list')), hasLength(2));

      f.failList = true;
      await store.getLists();
      await waitFor(() => store.bloc.state is AccessControlFailureState);
    });

    test('condomínio sem biometria pula o onboarding', () async {
      sessionBloc.session.condominium!.useFacialBiometric = false;
      await store.getLists();
      await waitFor(() => store.bloc.state is AccessControlLoadedState);
    });
  });

  group('saveAccess', () {
    test('sucesso sem biometria', () async {
      fakeAnalytics.reset();
      final states = <Type>[];
      final sub = store.bloc.stream.listen((s) => states.add(s.runtimeType));
      expect(await store.saveAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await sub.cancel();
      // Corrigido: só o estado terminal é emitido (sem Loaded intermediários).
      expect(states, [AccessControlLoadingState, SaveVisitantLoadedState]);
      expect(save.visitant!.gest!.phone, '11999998888');
      expect(save.visitant!.units.single.id, 'u9');
      expect(add.params!.gestId, 'novo');
      expect(f.calls, ['save', 'add:novo:u1']);
      expect(fakeAnalytics.events['autorizacao_entradas_agendamentos_sucesso']!['tipo agendamento'], 'Recorrente');
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState);
    });

    test('sucesso com biometria envia convite', () async {
      expect(await store.saveAccess(model: _gest(type: 'SERVICE', withUnit: false), authorizations: _auth(), useFacialBiometric: true), isTrue);
      expect(save.visitant!.units.single.id, 'u1');
      expect(invite.body!.userType, AccessControlInviteUserType.serviceprovider);
      expect(invite.body!.cpf, '12345678901');
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState && (store.bloc.state as SaveVisitantLoadedState).link == 'https://link');

      f.failInvite = true;
      expect(await store.saveAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: true), isFalse);
      await waitFor(() => store.bloc.state is SaveVisitantFailureState && (store.bloc.state as SaveVisitantFailureState).failureInvite);
    });

    test('falhas ao salvar e ao agendar', () async {
      f.failSave = true;
      expect(await store.saveAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false), isFalse);
      await waitFor(() => store.bloc.state is SaveVisitantFailureState);

      f.failSave = false;
      f.failAdd = true;
      expect(await store.saveAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false), isFalse);
      expect(f.calls.last, 'deleteVisitant:novo');
    });
  });

  group('saveVisit', () {
    test('sem biometria conclui', () async {
      final auth = _auth(facial: false);
      final states = <Type>[];
      final sub = store.bloc.stream.listen((s) => states.add(s.runtimeType));
      expect(await store.saveVisit(model: _gest(), authorizations: auth, cpf: null), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await sub.cancel();
      // Corrigido: só o estado terminal é emitido (sem Loaded intermediários).
      expect(states, [AccessControlLoadingState, SaveVisitantLoadedState]);
      expect(auth.idUnit, 'u1');
      expect(auth.idGest, 'g1');
      expect(edit.visitant!.units.single.id, 'u9');
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState && (store.bloc.state as SaveVisitantLoadedState).newVisit);
    });

    test('com biometria envia convite e conclui com o link', () async {
      /// Corrigido: após o convite o método devolve o resultado do envio e o
      /// último estado é `SaveVisitantLoadedState` com o link (não há mais a
      /// falha final com `failureInvite: false`).
      final states = <Type>[];
      final sub = store.bloc.stream.listen((s) => states.add(s.runtimeType));
      expect(await store.saveVisit(model: _gest(withUnit: false), authorizations: _auth(facial: true), cpf: 'c'), isTrue);
      expect(invite.body!.userType, AccessControlInviteUserType.gest);
      expect(edit.visitant!.units.single.id, 'u1');
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState && (store.bloc.state as SaveVisitantLoadedState).link == 'https://link');
      await sub.cancel();
      expect(states, [AccessControlLoadingState, SaveVisitantLoadedState]);

      f.failInvite = true;
      expect(await store.saveVisit(model: _gest(), authorizations: _auth(facial: true), cpf: 'c'), isFalse);
      await waitFor(() => store.bloc.state is SaveVisitantFailureState && (store.bloc.state as SaveVisitantFailureState).failureInvite);
    });

    test('falhas', () async {
      f.failEdit = true;
      expect(await store.saveVisit(model: _gest(), authorizations: _auth(facial: false), cpf: null), isFalse);
      // Corrigido: a falha na edição termina em falha (antes emitia um
      // `SaveVisitantLoadedState(newVisit: true)` depois da falha).
      await waitFor(() => store.bloc.state is SaveVisitantFailureState && !(store.bloc.state as SaveVisitantFailureState).failureInvite);
      f.failEdit = false;
      f.failAdd = true;
      expect(await store.saveVisit(model: _gest(), authorizations: _auth(facial: false), cpf: null), isFalse);
      await waitFor(() => store.bloc.state is SaveVisitantFailureState);
    });
  });

  group('editScheduledVisit', () {
    test('sem biometria', () async {
      final auth = _auth(facial: false);
      expect(await store.editScheduledVisit(model: _gest(withUnit: false), authorizations: auth, cpf: null), isTrue);
      expect(auth.idUnit, 'u1');
      expect(f.calls, ['edit', 'editVisit:rec']);
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState && (store.bloc.state as SaveVisitantLoadedState).edit);
    });

    test('com biometria envia convite', () async {
      expect(await store.editScheduledVisit(model: _gest(), authorizations: _auth(facial: true), cpf: null), isTrue);
      await waitFor(() => store.bloc.state is SaveVisitantLoadedState && (store.bloc.state as SaveVisitantLoadedState).link == 'https://link');
      f.failInvite = true;
      expect(await store.editScheduledVisit(model: _gest(), authorizations: _auth(facial: true), cpf: null), isFalse);
    });

    test('falhas', () async {
      f.failEdit = true;
      expect(await store.editScheduledVisit(model: _gest(), authorizations: _auth(), cpf: null), isFalse);
      f.failEdit = false;
      f.failEditVisit = true;
      expect(await store.editScheduledVisit(model: _gest(), authorizations: _auth(id: null), cpf: null), isFalse);
      expect(f.calls.last, 'editVisit:');
    });
  });

  test('editVisitant, deleteVisitant e deleteVisit', () async {
    await store.editVisitant(visitant: _gest(), authorizations: _auth());
    await waitFor(() => store.bloc.state is EditVisitantState);

    fakeAnalytics.reset();
    await store.deleteVisitant(gestId: 'g1', visitant: _gest(), authorizations: _auth());
    await waitFor(() => store.bloc.state is DeleteVisitantState);
    expect(fakeAnalytics.eventNames, contains('autorizacao_entradas_acessar_apagar_visitante'));
    f.failDelete = true;
    await store.deleteVisitant(gestId: 'g1', visitant: _gest(), authorizations: _auth());
    await waitFor(() => store.bloc.state is SaveVisitantFailureState && (store.bloc.state as SaveVisitantFailureState).deletVisitant);

    fakeAnalytics.reset();
    await store.deleteVisit(recurrenceId: 'r', visitant: _gest(type: 'SERVICE'), authorizations: _auth());
    await waitFor(() => store.bloc.state is DeleteVisitState);
    expect((store.bloc.state as DeleteVisitState).isVisitant, isFalse);
    expect(fakeAnalytics.eventNames, contains('autorizacao_entradas_acessar_agendamentos_apagar'));
    f.failDeleteVisit = true;
    await store.deleteVisit(recurrenceId: 'r', visitant: _gest(), authorizations: _auth());
    await waitFor(() => store.bloc.state is DeleteFailureVisitState);
  });

  test('visitantSearch', () async {
    await store.getLists(closeOnboarding: true);
    await waitFor(() => store.bloc.state is AccessControlLoadedState);
    await store.visitantSearch(name: '', visitant: const [], isProvider: false);
    expect(store.bloc.state, isA<AccessControlLoadedState>());

    await store.visitantSearch(name: 'car', visitant: const [], isProvider: false);
    await waitFor(() => store.bloc.state is SearchingVisitantState);
    expect(store.bloc.state.visitants, hasLength(1));

    await store.visitantSearch(name: '123.456', visitant: const [], isProvider: true);
    await waitFor(() => store.bloc.state is SearchingProviderState);
    expect(store.bloc.state.providers, hasLength(1));

    await store.visitantSearch(name: 'zzz', visitant: const [], isProvider: true);
    await waitFor(() => store.bloc.state is SearchingProviderState && store.bloc.state.providers.isEmpty);
    await store.visitantSearch(name: 'zzz', visitant: const [], isProvider: false);
    await waitFor(() => store.bloc.state is SearchingVisitantState && store.bloc.state.visitants.isEmpty);
  });

  test('sendInviteAccess', () async {
    await store.sendInviteAccess(visitant: _gest(), authorizations: _auth(facial: true));
    await waitFor(() => store.bloc.state is SaveVisitantLoadedState);
    expect((store.bloc.state as SaveVisitantLoadedState).link, 'https://link');
    f.failInvite = true;
    await store.sendInviteAccess(visitant: _gest(type: 'SERVICE'), authorizations: _auth());
    await waitFor(() => store.bloc.state is SaveVisitantFailureState);
    expect(invite.body!.userType, AccessControlInviteUserType.serviceprovider);
  });

  test('controllers logam analytics quando a store tem sucesso', () async {
    fakeAnalytics.reset();
    final visitant = AccessControlVisitantController(store: store);
    await visitant.saveVisitantAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false);
    expect(fakeAnalytics.eventNames, contains('autorizacao_entradas_cadastrar_novo_visitante_sucesso'));
    fakeAnalytics.reset();
    await visitant.saveVisitantVisit(visitant: _gest(), authorizations: _auth(facial: false), cpf: null);
    expect(fakeAnalytics.events['autorizacao_entradas_agendamentos_sucesso']!['tipo'], 'GEST');
    expect(await visitant.editVisitantScheduledVisit(visitant: _gest(), authorizations: _auth(facial: false), cpf: null), isTrue);

    fakeAnalytics.reset();
    final provider = AccessControlProviderController(store: store);
    await provider.saveProviderAccess(model: _gest(type: 'SERVICE'), authorizations: _auth(), useFacialBiometric: false);
    expect(fakeAnalytics.events['autorizacao_entradas_cadastrar_novo_visitante_sucesso']!['tipo'], 'SERVICE');
    fakeAnalytics.reset();
    await provider.saveProviderVisit(visitant: _gest(type: 'SERVICE'), authorizations: _auth(facial: false), cpf: null);
    expect(fakeAnalytics.eventNames, contains('autorizacao_entradas_agendamentos_sucesso'));
    expect(await provider.editProviderScheduledVisit(visitant: _gest(), authorizations: _auth(facial: false), cpf: null), isTrue);

    f.failSave = true;
    fakeAnalytics.reset();
    await visitant.saveVisitantAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false);
    await provider.saveProviderAccess(model: _gest(), authorizations: _auth(), useFacialBiometric: false);
    f.failEdit = true;
    await visitant.saveVisitantVisit(visitant: _gest(), authorizations: _auth(facial: false), cpf: null);
    await provider.saveProviderVisit(visitant: _gest(), authorizations: _auth(facial: false), cpf: null);
    expect(fakeAnalytics.eventNames, isEmpty);
  });
}
