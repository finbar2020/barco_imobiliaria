import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_enum.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';

import '../../helpers/page_harness.dart';

/// Id do usuário logado (`testMe().id`).
const mainUserId = 'm1';

/// Id da unidade da sessão de teste (`testUnity().id`).
const unitId = 'u1';

/// JSON de um sub usuário como devolvido por `/concierge/subUser/{unity}`.
Map<String, dynamic> subUserJson({
  String id = 's1',
  String name = 'Bia Souza',
  String? email = 'bia@lello.com',
  String? phone = '(11) 99999-8888',
  String? cpf = '123.456.789-01',
  String role = 'morar.morador',
  String roleDescription = 'Morador',
  bool blocked = false,
  bool useApp = true,
  bool mainUser = false,
  bool registered = false,
  bool useFacialBiometric = false,
  bool? flagBoletoEmail,
  String? expiresAt,
  String? notificationParameter,
  String? accessRenewalRequestStatus,
  String? accessRenewalRequestDate,
  Map<String, dynamic>? creator,
}) =>
    {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'cpf': cpf,
      'role': role,
      'role_description': roleDescription,
      'blocked': blocked,
      'use_app': useApp,
      'main_user': mainUser,
      'registered': registered,
      'use_facial_biometric': useFacialBiometric,
      'flag_boleto_email': flagBoletoEmail,
      'expires_at': expiresAt,
      'notification_parameter': notificationParameter ?? 'np-$id',
      'access_renewal_request_status': accessRenewalRequestStatus,
      'access_renewal_request_date': accessRenewalRequestDate,
      'unit_id': unitId,
      'creator': creator,
    };

/// JSON do usuário principal (o logado), proprietário por padrão.
Map<String, dynamic> ownerJson({
  String role = 'morar.proprietario',
  String roleDescription = 'Proprietário',
  bool useFacialBiometric = false,
  String? expiresAt,
  String? accessRenewalRequestStatus,
  String? accessRenewalRequestDate,
}) =>
    subUserJson(
      id: mainUserId,
      name: 'Ana Silva',
      email: 'ana@lello.com',
      role: role,
      roleDescription: roleDescription,
      mainUser: true,
      registered: true,
      useFacialBiometric: useFacialBiometric,
      expiresAt: expiresAt,
      accessRenewalRequestStatus: accessRenewalRequestStatus,
      accessRenewalRequestDate: accessRenewalRequestDate,
    );

Map<String, dynamic> pendingJson({
  int id = 1,
  String name = 'Carlos Pendente',
  String linkDescription = 'Inquilino',
  String registrationOrigin = 'LELLO',
  String? expirationDate,
  String remainingDays = '2 dias restantes',
}) =>
    {
      'id': id,
      'typeOfLink': 'INQUILINO',
      'linkDescription': linkDescription,
      'requestStatus': 'PENDENTE_PROPRIETARIO',
      'requestDate': '2026-08-01T00:00:00',
      'registrationOrigin': registrationOrigin,
      'expirationDate': expirationDate,
      'unitId': 1,
      'cpfCnpj': '12345678901',
      'email': 'c@x.com',
      'phone': '11999998888',
      'name': name,
      'remainingDays': remainingDays,
    };

List<Map<String, dynamic>> rolesJson() => [
      {'role': 'morar.proprietario', 'description': 'Proprietário', 'enabled': true},
      {'role': 'morar.inquilino', 'description': 'Inquilino', 'enabled': true},
      {'role': 'morar.morador', 'description': 'Morador', 'enabled': true},
      {'role': 'morar.parcial', 'description': 'Parcial', 'enabled': true},
    ];

/// Cadastra as rotas padrão da feature no [FakeHttp].
void registerSubUserRoutes(
  FakeHttp http, {
  List<Map<String, dynamic>>? users,
  List<Map<String, dynamic>> pending = const [],
  List<Map<String, dynamic>>? roles,
  bool serviceActive = true,
}) {
  http.on('GET', '/concierge/subUser/$unitId',
      body: users ?? [ownerJson(), subUserJson()]);
  http.on('GET', '/concierge/subUser/pending_requests/$unitId', body: pending);
  http.on('GET', '/concierge/subUser/enabled_roles', body: roles ?? rolesJson());
  http.on('PUT', '/concierge/subUser', body: users ?? [ownerJson(), subUserJson()]);
  http.on('POST', '/concierge/subUser', body: [subUserJson()]);
  http.on('GET', '/concierge/accesscontrol/getServiceSeventh',
      body: {'condominium_active': serviceActive});
  http.on('POST', '/concierge/subUser/renew_access/$unitId', body: 'ok');
  http.on('POST', '/concierge/subUser/pending_requests/change-status', body: {});
  http.on('DELETE', '/concierge/subUser/*', body: true);
  http.on('POST', '/concierge/accesscontrol/sendInvite', body: 'ok');
}

SubUser subUser({
  String id = 's1',
  String name = 'Bia Souza',
  String? email = 'bia@lello.com',
  String? phone = '(11) 99999-8888',
  String? cpf = '123.456.789-01',
  String role = 'morar.morador',
  String roleDescription = 'Morador',
  bool blocked = false,
  bool useApp = true,
  bool mainUser = false,
  bool registered = false,
  bool useFacialBiometric = false,
  bool? flagBoletoEmail,
  DateTime? expiresAt,
  String? accessRenewalRequestStatus,
  DateTime? accessRenewalRequestDate,
  ConciergeCreator? creator,
}) =>
    SubUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      cpf: cpf,
      role: role,
      roleDescription: roleDescription,
      blocked: blocked,
      useApp: useApp,
      mainUser: mainUser,
      registered: registered,
      useFacialBiometric: useFacialBiometric,
      flagBoletoEmail: flagBoletoEmail,
      expiresAt: expiresAt,
      accessRenewalRequestStatus: accessRenewalRequestStatus,
      accessRenewalRequestDate: accessRenewalRequestDate,
      unitId: unitId,
      creator: creator,
      notificationParameter: 'np-$id',
    );

SubUser owner({
  String role = 'morar.proprietario',
  String roleDescription = 'Proprietário',
  bool useFacialBiometric = false,
  DateTime? expiresAt,
  String? accessRenewalRequestStatus,
  DateTime? accessRenewalRequestDate,
}) =>
    subUser(
      id: mainUserId,
      name: 'Ana Silva',
      email: 'ana@lello.com',
      role: role,
      roleDescription: roleDescription,
      mainUser: true,
      registered: true,
      useFacialBiometric: useFacialBiometric,
      expiresAt: expiresAt,
      accessRenewalRequestStatus: accessRenewalRequestStatus,
      accessRenewalRequestDate: accessRenewalRequestDate,
    );

PendingRequestEntity pendingEntity({
  int id = 1,
  String name = 'Carlos Pendente',
  String linkDescription = 'Inquilino',
  RegistrationOrigin origin = RegistrationOrigin.lelloRegistration,
  DateTime? expirationDate,
}) =>
    PendingRequestEntity(
      id: id,
      typeOfLink: 'INQUILINO',
      linkDescription: linkDescription,
      requestStatus: 'PENDENTE_PROPRIETARIO',
      requestDate: DateTime(2026, 8, 1),
      registrationOrigin: origin,
      expirationDate: expirationDate,
      unitId: 1,
      cpfCnpj: '12345678901',
      email: 'c@x.com',
      phone: '11999998888',
      name: name,
      remainingDays: '2 dias restantes',
    );

const roles = [
  SubUserRole(role: 'morar.proprietario', description: 'Proprietário', enabled: true),
  SubUserRole(role: 'morar.inquilino', description: 'Inquilino', enabled: true),
  SubUserRole(role: 'morar.morador', description: 'Morador', enabled: true),
  SubUserRole(role: 'morar.parcial', description: 'Parcial', enabled: true),
];

/// Mocka o canal do `flutter_contacts` devolvendo [contacts]
/// (cada item: `{'displayName': ..., 'phones': [{'number': ...}]}`).
void mockFlutterContacts(List<Map<String, dynamic>> contacts) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter_contacts'),
          (call) async {
    if (call.method == 'crud.getAll') {
      return contacts
          .map((c) => {
                'id': c['displayName'],
                'displayName': c['displayName'],
                'phones': [
                  for (final p in (c['phones'] as List? ?? []))
                    {'number': p['number'], 'label': {'label': 'mobile'}},
                ],
              })
          .toList();
    }
    return null;
  });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_contacts'), null);
  });
}

/// Data ISO relativa a hoje.
String isoDaysFromNow(int days) =>
    DateTime.now().add(Duration(days: days)).toIso8601String();
