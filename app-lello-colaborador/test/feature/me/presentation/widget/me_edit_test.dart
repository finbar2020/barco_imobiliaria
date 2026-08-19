import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  _FakeMeBloc(this._state);

  final MeState _state;

  bool editPasswordCalled = false;
  bool saveCalled = false;
  bool takePhotoCalled = false;
  bool pickImageCalled = false;

  @override
  MeState get state => _state;

  @override
  Stream<MeState> get stream => Stream.value(_state);

  @override
  void beginEditPassword() => editPasswordCalled = true;

  @override
  void beginSave({CodeValidation? codeValidation}) => saveCalled = true;

  @override
  void beginTakePhoto() => takePhotoCalled = true;

  @override
  void beginPickImage() => pickImageCalled = true;
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

Future<void> _installContainer() async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
  locator.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc());
  locator.registerFactory<Validator>(() => ValidatorImpl());
}

Me _me({
  String cpf = '123.456.789-00',
  String phone = '(11)98765-4321',
  String email = 'ana@lello.com',
}) {
  return testMe()
    ..cpf = cpf
    ..phone = phone
    ..email = email;
}

Future<_FakeMeBloc> _pumpMeEdit(
  WidgetTester tester, {
  Me? me,
}) async {
  final bloc = _FakeMeBloc(MeLoadedState(me ?? _me()));
  await pumpApp(
    tester,
    BlocProvider<MeBloc>.value(value: bloc, child: const MeEdit()),
    localized: true,
    shrinkWrap: false,
    surface: const Size(400, 900),
  );
  return bloc;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('MeEdit', () {
    testWidgets('exibe cpf, nome e campos editáveis do colaborador',
        (tester) async {
      await _pumpMeEdit(tester);

      expect(find.text('me_cpf_title'), findsOneWidget);
      expect(find.text('123.456.789-00'), findsOneWidget);
      expect(find.text('full_name'), findsOneWidget);
      expect(find.text('ana silva'), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('me_edit_password_title'), findsOneWidget);
      expect(find.text('conclude'), findsOneWidget);
    });

    testWidgets('usa rótulo de cnpj quando o documento tem mais de 14 dígitos',
        (tester) async {
      await _pumpMeEdit(tester, me: _me(cpf: '12.345.678/0001-90'));

      expect(find.text('cnpj'), findsOneWidget);
      expect(find.text('me_cpf_title'), findsNothing);
    });

    testWidgets('separa ddd e telefone do valor salvo', (tester) async {
      await _pumpMeEdit(tester);

      expect(find.widgetWithText(TextFormField, '11'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '987654321'), findsOneWidget);
    });

    testWidgets('separa ddd e telefone no formato +55', (tester) async {
      await _pumpMeEdit(tester, me: _me(phone: '+5511987654321'));

      expect(find.widgetWithText(TextFormField, '11'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '987654321'), findsOneWidget);
    });

    testWidgets('aciona edição de senha', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.tap(find.text('me_edit_password_title'));
      await tester.pump();

      expect(bloc.editPasswordCalled, isTrue);
    });

    testWidgets('salva quando o formulário está válido', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.tap(find.text('conclude'));
      await tester.pump();

      expect(bloc.saveCalled, isTrue);
    });

    testWidgets('não salva quando o email é inválido', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'ana@lello.com'),
        'email-invalido',
      );
      await tester.tap(find.text('conclude'));
      await tester.pump();

      expect(bloc.saveCalled, isFalse);
    });

    testWidgets('não salva quando o ddd está vazio', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, '11'),
        '',
      );
      await tester.tap(find.text('conclude'));
      await tester.pump();

      expect(bloc.saveCalled, isFalse);
    });

    testWidgets('atualiza o telefone do colaborador ao digitar o ddd',
        (tester) async {
      final me = _me(phone: '');
      await _pumpMeEdit(tester, me: me);

      await tester.enterText(find.byType(TextFormField).at(1), '11');
      await tester.pump();

      expect(me.phone, '(11)');
    });

    testWidgets('formata o número digitado com a máscara de celular',
        (tester) async {
      final me = _me(phone: '');
      await _pumpMeEdit(tester, me: me);

      await tester.enterText(find.byType(TextFormField).at(2), '988887777');
      await tester.pump();

      expect(find.widgetWithText(TextFormField, '98888-7777'), findsOneWidget);
      expect(me.phone, contains('98888-7777'));
    });

    testWidgets('abre bottom sheet da foto e aciona a câmera', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);

      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();

      expect(bloc.takePhotoCalled, isTrue);
      expect(find.text('camera'), findsNothing);
    });

    testWidgets('abre bottom sheet da foto e aciona a galeria', (tester) async {
      final bloc = await _pumpMeEdit(tester);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();

      expect(bloc.pickImageCalled, isTrue);
    });
  });
}
