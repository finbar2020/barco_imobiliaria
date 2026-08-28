import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/data/model/address_model.dart';
import 'package:morar/feature/me/data/model/block_model.dart';
import 'package:morar/feature/me/data/model/condominium_model.dart';
import 'package:morar/feature/me/data/model/layout_model.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/data/model/me_password_model.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';
import 'package:morar/feature/me/domain/entity/address.dart';
import 'package:morar/feature/me/domain/entity/block.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/entity/me_step.dart';
import 'package:morar/feature/me/domain/repository/me_repository.dart';
import 'package:morar/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me_failure.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture_impl.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:shared_features/shared_features.dart' hide Address;

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _FakeMeRepository extends Fake implements MeRepository {
  final calls = <String>[];

  @override
  Future<Try<Me?>> select() async {
    calls.add('select');
    return Success(testMe(name: 'remote'));
  }

  @override
  Future<Try<Me?>> selectFromCache() async {
    calls.add('cache');
    return Success(testMe(name: 'cache'));
  }

  @override
  Future<Try<Me?>> save(Me me, String code) async {
    calls.add('save:$code');
    return Success(me);
  }

  @override
  Future<Try> updatePassword(
      String cpf, String originPassword, String password) async {
    calls.add('password:$cpf:$originPassword:$password');
    return Success(null);
  }
}

class _FakePictureRepository extends Fake implements ProfilePictureRepository {
  _FakePictureRepository({this.fail = false});
  final bool fail;

  @override
  Future<Try<String>> upload(
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    if (fail) {
      onError(Exception('upload'));
    } else {
      onComplete('http://picture');
    }
    return Success('task');
  }
}

void main() {
  group('Me', () {
    test('picture, imagem e links', () {
      final me = testMe(picture: testPictureBase64, cpf: '');
      expect(me.hasImage, isTrue);
      expect(me.image, isNotNull);
      expect(me.picture, testPictureBase64);
      expect(me.isEmpty, isTrue);
      expect(me.pictureLink, '');
      expect(me.biometriaImageLink, isNull);

      me
        ..pictureHash = 'h'
        ..biometricPictureHash = 'b';
      expect(me.pictureLink, '/me/pictures/file/h');
      expect(me.biometriaImageLink, '/concierge/accesscontrol/pictures/file/b');
      expect(testMe().hasImage, isFalse);
      expect(testMe().isEmpty, isFalse);
    });

    test('unidades agregadas', () {
      final me = testMe(
        condominiums: [
          testCondominium(
            id: 'c1',
            blocks: [
              testBlock(id: 'b1', units: [testUnity(id: 'u1')]),
              testBlock(id: 'b2', units: [testUnity(id: 'u2'), testUnity(id: 'u3')]),
            ],
          ),
          testCondominium(id: 'c2', blocks: [testBlock(id: 'b3', units: [])]),
        ],
      );
      expect(me.allUnitIds, ['u1', 'u2', 'u3']);
      expect(me.allUnitsEntity.map((u) => u.id), ['u1', 'u2', 'u3']);
      expect(me.allUnits.length, 3);
      expect(me.allUnits.first[0], isA<Condominium>());
      expect((me.allUnits.first[1] as Unity).id, 'u1');
    });

    test('hasToUpdate, empty, clone e copyWith', () {
      expect(testMe(lastUpdatedAt: DateTime.now()).hasToUpdate, isFalse);
      expect(
        testMe(lastUpdatedAt: DateTime.now().subtract(const Duration(minutes: 5)))
            .hasToUpdate,
        isTrue,
      );
      final empty = Me.empty();
      expect(empty.name, '');
      expect(empty.condominiums, isEmpty);
      expect(empty.hasToUpdate, isFalse);

      final me = testMe()..useFacialBiometric = null;
      final clone = Me.clone(me);
      expect(clone.name, me.name);
      expect(clone.useFacialBiometric, isFalse);
      expect(clone.condominiums!.single.id, 'c1');
      expect(identical(clone.condominiums!.single, me.condominiums!.single),
          isFalse);

      final copy = me.copyWith(name: 'novo', phone: '1');
      expect(copy.name, 'novo');
      expect(copy.phone, '1');
      expect(copy.email, me.email);
      expect(me.copyWith().cpf, me.cpf);
    });

    testWidgets('getGreetings usa o primeiro nome capitalizado', (tester) async {
      await pumpApp(tester, const Text('x'), localized: true);
      final context = tester.element(find.text('x'));
      final me = testMe(name: 'aNA silva');
      expect(me.getGreetings(context, me), 'hi, Ana');
    });
  });

  group('Condominium / Block / Unity / Layout / Session', () {
    test('Condominium', () {
      final condo = testCondominium(
        blocks: [
          testBlock(units: [testUnity(), testUnity(id: 'u2')]),
          Block(id: 'b2'),
        ],
        layout: testLayout(),
      );
      expect(condo.unitsLength, 2);
      expect(Condominium().unitsLength, 0);
      final clone = Condominium.clone(condo);
      expect(clone.id, 'c1');
      expect(clone.layout!.companyName, 'Lello');
      expect(clone.useFacialBiometric, isTrue);
      expect(condo.toString(), contains('reference: R1'));
      expect(Block().unitsLength, 0);
    });

    test('Unity.namedTitle', () {
      expect(testUnity(title: '101.0').namedTitle, '101');
      expect(testUnity(title: '12').namedTitle, '12');
      expect(testUnity(title: 'Casa A').namedTitle, 'Casa A');
      expect(Unity().namedTitle, '1');
      expect(Unity(title: '1').toString(), contains('title: 1'));
    });

    test('Session resolve unidade e condomínio padrão', () {
      final session = testSession();
      expect(session.condominium!.id, 'c1');
      expect(session.unity!.id, 'u1');
      expect(session.tokenName, 'R1101');

      final other = testUnity(id: 'u9', title: '909');
      session.unity = other;
      expect(session.unity, same(other));
      expect(session.tokenName, 'R1909');

      session.condominium = Condominium();
      expect(session.tokenName, isNull);
      expect(Session().tokenName, isNull);
      expect(Session().unity, isNull);
    });
  });

  group('models', () {
    test('MeModel round trip', () {
      final me = testMe(picture: testPictureBase64)
        ..pictureHash = 'h'
        ..biometricPictureHash = 'b'
        ..useFacialBiometric = null;
      me.condominiums!.single.layout = testLayout();
      final model = MeModel.fromEntity(me)!;
      expect(model.useFacialBiometric, isFalse);
      final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(json['picture_hash'], 'h');
      expect(json['condominiums'][0]['blocks'][0]['units'][0]['id'], 'u1');
      expect(json['condominiums'][0]['layout']['logo_path'], 'logo.png');

      final back = MeModel.fromJson(json).toEntity()!;
      expect(back.email, me.email);
      expect(back.condominiums!.single.layout!.name, 'Lello');
      expect(back.condominiums!.single.blocks!.single.units!.single.title, '101');
      expect(back.lastUpdatedAt, DateTime(2026, 1, 1));
      expect(MeModel.fromEntity(null), isNull);
    });

    test('CondominiumModel e LayoutModel', () {
      final condo = CondominiumModel.fromJson({
        'id': 'c',
        'name': 'n',
        'reference': 'r',
        'blocks': [
          {'id': 'b', 'name': 'B', 'units': []}
        ],
      }).toEntity();
      expect(condo.useFacialBiometric, isFalse);
      expect(condo.layout, isNull);
      expect(condo.blocks!.single.units, isEmpty);
      expect(CondominiumModel.fromEntity(null), isNull);
      expect(LayoutModel.fromEntity(null), isNull);
      expect(LayoutModel.fromJson({'cod': 'x'}).toEntity().cod, 'x');
      expect(BlockModel.fromEntity(null), isNull);
      expect(BlockModel.fromEntity(testBlock())!.units!.single.id, 'u1');
      expect(BlockModel.fromJson({'id': 'b'}).toEntity().units, isNull);
    });

    test('UnityModel e AddressModel', () {
      final unit = UnityModel.fromEntity(testUnity(rented: true))!;
      expect(unit.toJson()['rented'], isTrue);
      expect(UnityModel.fromEntity(null), isNull);
      expect(UnityModel.fromJson({'id': 'u', 'term_home_to_go': true})
          .toEntity()
          .termHomeToGo, isTrue);

      final address = AddressModel.fromEntity(Address(cep: '01000', number: '1'))!;
      expect(address.toJson()['cep'], '01000');
      expect(AddressModel.fromJson({'bairro': 'Centro'}).toEntity().bairro,
          'Centro');
      expect(AddressModel.fromEntity(null), isNull);
    });

    test('MePasswordModel', () {
      final model = MePasswordModel.init('c', 'o', 'p');
      expect(model.toJson(), {'cpf': 'c', 'origin_password': 'o', 'password': 'p'});
      expect(MePasswordModel.fromJson(model.toJson()).password, 'p');
    });
  });

  group('use cases', () {
    test('GetMeImpl escolhe a origem', () async {
      final repo = _FakeMeRepository();
      final useCase = GetMeImpl(repository: repo);
      final local = await useCase(DataOrigin.local);
      final remote = await useCase(DataOrigin.remote);
      expect(local.fold((_) => null, (m) => m!.name), 'cache');
      expect(remote.fold((_) => null, (m) => m!.name), 'remote');
      expect(repo.calls, ['cache', 'select']);
    });

    test('SaveMeImpl valida', () async {
      final repo = _FakeMeRepository();
      final useCase = SaveMeImpl(repository: repo);
      Failure? failureOf(Try<Me?> r) => r.fold((f) => f, (_) => null);

      expect(failureOf(await useCase(SaveMeParam())), isA<InvalidParamFailure>());
      expect(failureOf(await useCase(SaveMeParam(me: testMe()))),
          isA<InvalidParamFailure>());
      expect(
        failureOf(await useCase(SaveMeParam(
          me: testMe(phone: '1'),
          originalMe: testMe(phone: '2'),
        ))),
        isA<SaveMeInvalidCodeValidationFailure>(),
      );

      final ok = await useCase(SaveMeParam(me: testMe(), originalMe: testMe()));
      expect(ok.fold((_) => null, (m) => m!.name), 'ana silva');
      expect(repo.calls, ['save:']);

      await useCase(SaveMeParam(
        me: testMe(phone: '1'),
        originalMe: testMe(phone: '2'),
        codeValidation: CodeValidation(id: 'code-1'),
      ));
      expect(repo.calls.last, 'save:code-1');
    });

    test('UpdatePasswordMeImpl valida', () async {
      final repo = _FakeMeRepository();
      final useCase = UpdatePasswordMeImpl(repository: repo);
      Failure? failureOf(Try r) => r.fold((f) => f, (_) => null);
      expect(
        failureOf(await useCase(
            UpdatePasswordMeParam(cpf: '', originPassword: 'o', password: 'p'))),
        isA<InvalidParamFailure>(),
      );
      expect(
        failureOf(await useCase(
            UpdatePasswordMeParam(cpf: 'c', originPassword: '', password: 'p'))),
        isA<InvalidParamFailure>(),
      );
      expect(
        failureOf(await useCase(
            UpdatePasswordMeParam(cpf: 'c', originPassword: 'o', password: ''))),
        isA<InvalidParamFailure>(),
      );
      await useCase(
          UpdatePasswordMeParam(cpf: 'c', originPassword: 'o', password: 'p'));
      expect(repo.calls, ['password:c:o:p']);
    });

    test('UploadProfilePictureImpl recarrega a sessão ao concluir', () async {
      final session = FakeSessionBloc();
      final useCase = UploadProfilePictureImpl(
        uploader: _FakePictureRepository(),
        sessionBloc: session,
      );
      final result = await useCase(File('x'));
      expect(result.fold((_) => null, (u) => u), 'http://picture');
      expect(session.loadCalls, 1);

      final failed = await UploadProfilePictureImpl(
        uploader: _FakePictureRepository(fail: true),
        sessionBloc: session,
      )(File('x'));
      expect(failed.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  group('MeBloc', () {
    test('mapeia todos os eventos', () async {
      final bloc = MeBloc();
      expect(bloc.state.me.name, '');
      final me = testMe();
      final failure = UnknownFailure('x');
      final request = CodeRequest(
        source: CodeValidationSource.phone,
        origin: CodeValidationOrigin.changeNumber,
        value: 'v',
        token: 't',
      );
      final states = <MeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc
        ..add(MeLoadingEvent(me))
        ..add(MeLoadedCacheEvent(me: me))
        ..add(MeLoadedEvent(me))
        ..add(MeLoadFailedEvent(me, failure))
        ..add(MeEditLoadingEvent(me: me))
        ..add(MeEditLoadedEvent(me: me))
        ..add(MeEditPasswordEvent(me, 'o', 'p'))
        ..add(MeEditPasswordLoadingEvent(me, 'o', 'p'))
        ..add(MeEditPasswordFailedEvent(me, 'o', 'p', failure))
        ..add(MeEditSucceededEvent(me: me))
        ..add(MeEditFailedEvent(me, request, CodeValidation(id: 'c'), failure))
        ..add(MeEditPhoneChangedEvent(me))
        ..add(MeEditEmailChangedEvent(me))
        ..add(MeEditRequestingCodeEvent(me))
        ..add(MeEditRequestingCodeFailedEvent(me, failure))
        ..add(MeEditNoContactAvailableEvent(me))
        ..add(MeEditValidateCodeSuccessEvent(me, request))
        ..add(MeUploadProfileFailedEvent(me, failure))
        ..add(MeUploadProfileSucceededEvent(me))
        ..add(MeUnauthenticatedEvent(me))
        ..add(MeDeleteSuccessEvent(me: me))
        ..add(MeDeleteFailedEvent(me: me));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await sub.cancel();
      await bloc.close();

      expect(states.map((s) => s.runtimeType).toList(), [
        MeLoadingState,
        MeLoadedCacheState,
        MeLoadedState,
        MeLoadFailedState,
        MeEditLoadingState,
        MeEditState,
        MeEditPasswordState,
        MeEditPasswordLoadingState,
        MeEditPasswordFailedState,
        MeEditSucceededState,
        MeEditFailedState,
        MeEditPhoneChangedState,
        MeEditEmailChangedState,
        MeEditRequestingCodeState,
        MeEditRequestCodeFailedState,
        MeEditNoContactAvailableState,
        MeEditValidateCodeState,
        MeUploadProfileFailedState,
        MeUploadProfileSucceededState,
        MeUnauthenticatedState,
        MeDeleteAccountSuccessState,
        MeDeleteAccountFailedState,
      ]);
      final failed = states[10] as MeEditFailedState;
      expect(failed.error, failure);
      expect(failed.codeRequest, request);
      expect(failed.codeValidation!.id, 'c');
      expect((states[16] as MeEditValidateCodeState).codeRequest, request);
      expect((states[3] as MeLoadFailedState).failure, failure);
      expect((states[8] as MeEditPasswordFailedState).error, failure);
    });

    test('eventos auxiliares guardam dados', () {
      expect(MeLoadEvent(forceUpdate: true).forceUpdate, isTrue);
      expect(MeChangeStepEvent(step: MeStep.edit).step, MeStep.edit);
      expect(MeSaveEvent(codeValidation: CodeValidation(code: '1')).codeValidation!.code, '1');
      expect(MeBeginEditSavePasswordEvent(originPassword: 'a', password: 'b').password, 'b');
      expect(MeChooseImageEvent(ImageSource.camera).source, ImageSource.camera);
      expect(MeDeleteAccountEvent(testMe()).me.id, 'm1');
      expect(MeUploadProfileLoadingState(testMe()).codeRequest, isNull);
      expect(MeEditPasswordSucceededState(testMe()).me.id, 'm1');
    });
  });
}
