import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'authentication_support.dart';

void main() {
  late FakeFirebaseAuthPlatform firebaseAuth;

  setUpAll(() async {
    await setUpFakeFirebase();
    firebaseAuth = installFakeFirebaseAuth();
  });

  setUp(() {
    firebaseAuth.tokens.clear();
    firebaseAuth.fail = false;
  });

  final credentials = Credentials(username: '123', password: 'p');

  group('AuthenticateImpl', () {
    late FakeAccessTokenRepository repository;
    late FakeAuthenticateFirebase firebase;
    late AuthenticateImpl useCase;

    setUp(() {
      repository = FakeAccessTokenRepository();
      firebase = FakeAuthenticateFirebase();
      useCase =
          AuthenticateImpl(repository: repository, authenticateFirebase: firebase);
    });

    test('credenciais vazias são rejeitadas antes de chamar a API', () async {
      for (final c in [
        Credentials(username: '', password: 'p'),
        Credentials(username: 'u', password: ''),
      ]) {
        final result = await useCase.call(c);
        final failure = (result as Rejection).get();
        expect(failure, isA<InvalidCredentialsFailure>());
        expect(failure.code, 'validate_credentials_failure');
      }
      expect(repository.posted, isEmpty);
    });

    test('sucesso salva o token, autentica no Firebase e devolve o salvo',
        () async {
      final result = await useCase.call(credentials);

      expect(result.fold((_) => null, (t) => t!.accessToken), 'salvo');
      expect(repository.saved.single!.accessToken, 'jwt-1');
      expect(firebase.tokens, ['fb-1']);
    });

    test('falha ao salvar devolve o token recebido', () async {
      repository.saveResult = Rejection(UnknownFailure('disco'));

      final result = await useCase.call(credentials);

      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
    });

    test('rejeição do repositório é propagada', () async {
      repository.postResult = Rejection(InvalidCredentialsFailure('x', null));

      final result = await useCase.call(credentials);

      expect((result as Rejection).get(), isA<InvalidCredentialsFailure>());
      expect(repository.saved, isEmpty);
    });

    test('token nulo ou sem token do Firebase vira UnknownFailure', () async {
      repository.postResult = Success(null);
      var result = await useCase.call(credentials);
      expect((result as Rejection).get(), isA<UnknownFailure>());

      repository.postResult = Success(buildToken(firebaseToken: null));
      result = await useCase.call(credentials);
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('AuthenticateConviteteImpl', () {
    late FakeAccessTokenRepository repository;

    setUp(() {
      repository = FakeAccessTokenRepository();
    });

    test('valida credenciais e usa a rota do convite', () async {
      final firebase = FakeAuthenticateFirebase();
      final useCase = AuthenticateConviteteImpl(
          repository: repository, authenticateFirebase: firebase);

      final invalid =
          await useCase.call(Credentials(username: '', password: ''));
      expect((invalid as Rejection).get(), isA<InvalidCredentialsFailure>());

      final result = await useCase.call(credentials);
      expect(result.fold((_) => null, (t) => t!.accessToken), 'salvo');
      expect(repository.posted.single.username, '123');
      expect(firebase.tokens, ['fb-1']);
    });

    test('sem Firebase só salva; rejeição e exceção são tratadas', () async {
      final useCase = AuthenticateConviteteImpl(repository: repository);

      final ok = await useCase.call(credentials);
      expect(ok, isA<Success<AccessToken?>>());

      repository.postInviteResult = Rejection(UnknownFailure('x'));
      final rejected = await useCase.call(credentials);
      expect(rejected, isA<Rejection>());

      repository.postInviteResult = Success(null);
      final thrown = await useCase.call(credentials);
      expect((thrown as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('AuthenticateFirebaseImpl', () {
    test('token vazio ou nulo é inválido', () async {
      final useCase = AuthenticateFirebaseImpl();
      final result = await useCase.call('');
      expect((result as Rejection).get(), isA<InvalidParamFailure>());
      expect(firebaseAuth.tokens, isEmpty);
    });

    test('faz login com o token customizado', () async {
      final result = await AuthenticateFirebaseImpl().call('fb-token');

      expect(result.fold((_) => false, (r) => r), isTrue);
      expect(firebaseAuth.tokens, ['fb-token']);
    });

    test('erro do Firebase vira UnknownFailure', () async {
      firebaseAuth.fail = true;

      final result = await AuthenticateFirebaseImpl().call('fb-token');

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('DeleteAccountImpl e GetTokenImpl', () {
    test('delegam ao repositório', () async {
      final repository = FakeAccessTokenRepository();

      expect(await DeleteAccountImpl(repository: repository).call(),
          isA<Success<String?>>());

      final getToken = GetTokenImpl(repository: repository);
      expect(await getToken.call(null), isA<Success<AccessToken?>>());
      await getToken.call(GetTokenParams(role: 'R'));
      expect(repository.selectedRoles, [null, 'R']);
    });
  });

  group('LogoutImpl', () {
    test('limpa token, pendências e sessão e apaga o token do FCM', () async {
      final repository = FakeAccessTokenRepository()
        ..saveResult = Success(null);
      final pendencies = FakeClearable();
      final session = FakeClearable();
      final useCase = LogoutImpl(
          repository: repository,
          pendencyRepository: pendencies,
          sessionRepository: session);

      final result = await useCase.call();

      expect(result, isA<Success<Nothing>>());
      expect(repository.saved, [null]);
      expect(pendencies.clears, 1);
      expect(session.clears, 1);
    });

    test('sem repositório de pendências e com falha ao salvar', () async {
      final repository = FakeAccessTokenRepository()
        ..saveResult = Rejection(UnknownFailure('x'));
      final session = FakeClearable();
      final useCase = LogoutImpl(
          repository: repository,
          pendencyRepository: null,
          sessionRepository: session);

      final result = await useCase.call();

      expect(result, isA<Rejection>());
      expect(session.clears, 1);
    });
  });

  group('SwitchRolesImpl', () {
    late FakeAccessTokenRepository repository;
    late FakeAuthenticateFirebase firebase;
    late SwitchRolesImpl useCase;

    setUp(() {
      repository = FakeAccessTokenRepository();
      firebase = FakeAuthenticateFirebase();
      useCase = SwitchRolesImpl(
          repository: repository, authenticateFirebase: firebase);
    });

    test('troca o papel, salva com o nome e autentica no Firebase', () async {
      final result =
          await useCase.call(SwitchParams(role: 'CONDO-1', name: 'Condo'));

      expect(result.fold((_) => null, (t) => t!.accessToken), 'salvo');
      expect(repository.switched, ['CONDO-1']);
      expect(repository.savedRoles, ['Condo']);
      expect(firebase.tokens, ['fb-1']);
    });

    test('falha ao salvar devolve o token recebido', () async {
      repository.saveResult = Rejection(UnknownFailure('x'));
      final result =
          await useCase.call(SwitchParams(role: 'CONDO-1', name: 'Condo'));
      expect(result.fold((_) => null, (t) => t!.accessToken), 'jwt-1');
    });

    test('rejeição e exceção são tratadas', () async {
      repository.switchResult = Rejection(ForbidenTokenFailure('f', null));
      var result = await useCase.call(SwitchParams(role: 'R', name: 'N'));
      expect((result as Rejection).get(), isA<ForbidenTokenFailure>());

      repository.switchResult = Success(null);
      result = await useCase.call(SwitchParams(role: 'R', name: 'N'));
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('RefreshTokenImpl', () {
    late FakeRefreshTokenRepository repository;
    late AuthenticationBloc bloc;
    late RefreshTokenImpl useCase;

    setUp(() {
      repository = FakeRefreshTokenRepository();
      bloc = AuthenticationBloc();
      useCase = RefreshTokenImpl(repository: repository, authenticationBloc: bloc);
    });

    tearDown(() => bloc.close());

    test('autenticado: salva, preserva as permissões e reautentica o bloc',
        () async {
      bloc.add(AuthenticateEvent(
          accessToken: buildToken(permissions: ['antiga']), me: 'eu'));
      await Future<void>.delayed(Duration.zero);
      repository.saveResult = Rejection(UnknownFailure('x'));

      final result = await useCase.call();
      await Future<void>.delayed(Duration.zero);

      final token = result.fold((_) => null, (t) => t)!;
      expect(token.accessToken, 'jwt-2');
      expect(token.selectedRolePermissions, ['antiga']);
      expect(repository.saved.single!.accessToken, 'jwt-2');
      final state = bloc.state as AuthenticatedState;
      expect(state.accessToken.accessToken, 'jwt-2');
      expect(state.onLogin, isFalse);
      expect(state.me, 'eu');
    });

    test('salvo com sucesso usa o token persistido', () async {
      bloc.add(AuthenticateEvent(accessToken: buildToken()));
      await Future<void>.delayed(Duration.zero);

      final result = await useCase.call();

      expect(result.fold((_) => null, (t) => t!.accessToken), 'salvo');
    });

    test('bloc não autenticado ou token nulo vira UnknownFailure', () async {
      var result = await useCase.call();
      expect((result as Rejection).get(), isA<UnknownFailure>());

      bloc.add(AuthenticateEvent(accessToken: buildToken()));
      await Future<void>.delayed(Duration.zero);
      repository.refreshResult = Success(null);
      repository.saveResult = Success(null);
      result = await useCase.call();
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('refresh inválido desloga o usuário e limpa o cache', () async {
      repository.refreshResult =
          Rejection(BadRefreshTokenFailure('bad', null));

      final result = await useCase.call();
      await Future<void>.delayed(Duration.zero);

      expect((result as Rejection).get(), isA<BadRefreshTokenFailure>());
      expect(repository.clears, 1);
      final state = bloc.state as UnautorizedState;
      expect(state.restartApp, isTrue);
      expect(state.error, isA<BadRefreshTokenFailure>());
    });

    test('outras falhas e exceções viram UnknownFailure', () async {
      repository.refreshResult = Rejection(UnknownFailure('rede'));
      var result = await useCase.call();
      expect((result as Rejection).get(), isA<UnknownFailure>());

      repository.throwOnRefresh = true;
      result = await useCase.call();
      expect((result as Rejection).get(), isA<UnknownFailure>());
      expect(bloc.state, const UnauthenticatedState());
    });
  });
}
