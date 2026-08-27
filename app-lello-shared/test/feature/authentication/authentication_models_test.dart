import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_request_model.dart';
import 'package:shared_features/feature/authentication/data/model/refresh_token_request_model.dart';
import 'package:shared_features/feature/authentication/data/model/role_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'authentication_support.dart';

void main() {
  group('AccessTokenModel', () {
    test('fromJson/toJson preservam todos os campos', () {
      final model = AccessTokenModel.fromJson(tokenJson(custom: ['x.y']));

      expect(model.accessToken, 'jwt-1');
      expect(model.refreshToken, 'refresh-1');
      expect(model.firebaseToken, 'fb-1');
      expect(model.userId, 'u1');
      expect(model.expiresIn, 1700000000);
      expect(model.roles, hasLength(2));
      expect(model.roles!.first.context, 'CONDO-1');
      expect(model.roles!.first.roleName, 'SINDICO');
      expect(model.selectedRole, 'SINDICO');
      expect(model.selectedRolePermissions, ['home.menu.item', 'home.banner']);
      expect(model.customRolePermissions, ['x.y']);

      final json = model.toJson();
      expect(json['access_token'], 'jwt-1');
      expect(json['expires_in'], 1700000000);
      expect(json['custom_role_permissions'], ['x.y']);
      expect((json['roles'] as List).first, isA<RoleModel>());
    });

    test('fromJson aceita campos nulos', () {
      final model = AccessTokenModel.fromJson(tokenJson(
        accessToken: null,
        refreshToken: null,
        firebaseToken: null,
        userId: null,
        expiresIn: null,
        roles: null,
        selectedRole: null,
        permissions: null,
      ));

      expect(model.accessToken, isNull);
      expect(model.roles, isNull);
      expect(model.expiresIn, isNull);

      final entity = model.toEntity();
      expect(entity.expiresIn, isNull);
      expect(entity.roles, isNull);
      expect(entity.selectedRolePermissions, isEmpty);
    });

    test('toEntity converte expiração em DateTime e expande as permissões',
        () {
      final entity = AccessTokenModel.fromJson(tokenJson()).toEntity();

      expect(entity.accessToken, 'jwt-1');
      expect(entity.refreshToken, 'refresh-1');
      expect(entity.firebaseToken, 'fb-1');
      expect(entity.userId, 'u1');
      expect(entity.expiresIn,
          DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000));
      expect(entity.roles, hasLength(2));
      expect(entity.roles!.first, isA<Role>());
      expect(entity.roles!.last.roleName, 'MORADOR');
      expect(entity.selectedRole, 'SINDICO');
      expect(entity.selectedRolePermissions,
          ['home', 'home.menu', 'home.menu.item', 'home.banner']);
    });

    test('mapAllRoles gera os prefixos sem repetição', () {
      final model = AccessTokenModel();

      expect(model.mapAllRoles([]), isEmpty);
      expect(model.mapAllRoles(['a.b.c', 'a.b', 'a.x']),
          ['a', 'a.b', 'a.b.c', 'a.x']);
    });

    test('fromEntity converte a data em segundos e nulo em nulo', () {
      expect(AccessTokenModel.fromEntity(null), isNull);

      final entity = buildToken(
          expiresIn: DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000));
      final model = AccessTokenModel.fromEntity(entity)!;

      expect(model.accessToken, 'jwt-1');
      expect(model.refreshToken, 'refresh-1');
      expect(model.firebaseToken, 'fb-1');
      expect(model.expiresIn, 1700000000);
      expect(model.roles, hasLength(1));
      expect(model.selectedRolePermissions, ['home.menu.item']);
      expect(model.selectedRole, 'SINDICO');
      expect(model.userId, 'u1');

      // Sem expiração a conversão devolve zero.
      expect(AccessTokenModel.fromEntity(buildToken())!.expiresIn, 0);
    });
  });

  group('RoleModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model =
          RoleModel.fromJson({'context': 'C1', 'role_name': 'SINDICO'});
      expect(model.context, 'C1');
      expect(model.roleName, 'SINDICO');
      expect(model.toJson(), {'context': 'C1', 'role_name': 'SINDICO'});

      final entity = model.toEntity();
      expect(entity.context, 'C1');
      expect(entity.roleName, 'SINDICO');

      expect(RoleModel.fromEntity(null), isNull);
      final back = RoleModel.fromEntity(entity)!;
      expect(back.context, 'C1');
      expect(back.roleName, 'SINDICO');

      expect(RoleModel.fromJson({}).context, isNull);
    });
  });

  group('modelos de requisição', () {
    test('AccessTokenRequestModel serializa usuário e senha', () {
      final model =
          AccessTokenRequestModel(username: '123', password: 'senha');
      expect(model.grantType, 'password');
      expect(model.toJson(), {'username': '123', 'password': 'senha'});

      final parsed = AccessTokenRequestModel.fromJson(
          {'username': 'u', 'password': 'p'});
      expect(parsed.username, 'u');
      expect(parsed.password, 'p');
    });

    test('RefreshTokenRequestModel serializa token e refresh', () {
      final model = RefreshTokenRequestModel(token: 't', refreshToken: 'r');
      expect(model.toJson(), {'token': 't', 'refresh_token': 'r'});

      final parsed = RefreshTokenRequestModel.fromJson(
          {'token': 'a', 'refresh_token': 'b'});
      expect(parsed.token, 'a');
      expect(parsed.refreshToken, 'b');
    });
  });

  group('entidades', () {
    test('AccessToken.checkPermission olha as permissões do papel e custom',
        () {
      final token = buildToken(permissions: ['a'], custom: ['b']);
      expect(token.checkPermission('a'), isTrue);
      expect(token.checkPermission('b'), isTrue);
      expect(token.checkPermission('c'), isFalse);

      final vazio = AccessToken();
      expect(vazio.checkPermission('a'), isFalse);
    });

    test('Credentials, AuthArguments, Role, SwitchParams e GetTokenParams',
        () {
      final credentials = Credentials(username: 'u', password: 'p');
      credentials.username = 'x';
      expect(credentials.username, 'x');
      expect(credentials.password, 'p');

      expect(AuthArguments().goToRegister, isNull);
      expect(AuthArguments(goToRegister: true).goToRegister, isTrue);

      final role = Role(context: 'C', roleName: 'R');
      expect(role.context, 'C');
      expect(role.roleName, 'R');

      final params = SwitchParams(role: 'R', name: 'N');
      expect(params.role, 'R');
      expect(params.name, 'N');

      expect(GetTokenParams().role, isNull);
      expect(GetTokenParams(role: 'r').role, 'r');
    });

    test('falhas de autenticação guardam código e erro', () {
      final failures = <KnownFailure>[
        InvalidCredentialsFailure('c1', 'e'),
        UnknowCredentialsFailure('c2', 'e'),
        NotRegisteredCredentialsFailure('c3', 'e'),
        NoRoleForCredentialsFailure('c4', 'e'),
        BadRefreshTokenFailure('c5', 'e'),
        ForbidenTokenFailure('c6', 'e'),
      ];
      for (final f in failures) {
        expect(f, isA<AuthenticateFailure>());
        expect(f.code, startsWith('c'));
        expect(f.error, 'e');
      }
      expect(InvalidConviteCredentialsFailure(),
          isA<AuthenticateConviteFailure>());
    });
  });
}
