import 'package:drift/drift.dart' hide isNotNull, isNull, equals;
import 'package:drift/native.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/lello_hub/lello_hub_dao.dart';

void main() {
  late LelloDatabase db;

  setUp(() async {
    db = LelloDatabase.forExecutor(NativeDatabase.memory());
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() async {
    await db.close();
  });

  test('tabelas, companions, composers e managers', () async {
    final pendencyData = PendencyData(condominiumId: 'condominiumId', id: 'id', title: 'title', message: 'message', date: DateTime(2026, 1, 10), type: 'type', senderId: 'senderId', senderName: 'senderName', senderPicture: 'senderPicture', module: 'module');
    final pendencyDataNull = PendencyData(condominiumId: 'condominiumId', id: 'id', type: 'type', senderId: 'senderId');
    expect(pendencyData == pendencyData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', title: Value('titleX'), message: Value('messageX'), date: Value(DateTime(2026, 1, 10)), type: 'typeX', senderId: 'senderIdX', senderName: Value('senderNameX'), senderPicture: Value('senderPictureX'), module: Value('moduleX')), isFalse);
    expect(pendencyData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', title: Value('titleX'), message: Value('messageX'), date: Value(DateTime(2026, 1, 10)), type: 'typeX', senderId: 'senderIdX', senderName: Value('senderNameX'), senderPicture: Value('senderPictureX'), module: Value('moduleX')), isNotNull);
    pendencyData.copyWithCompanion(PendencyTableCompanion());
    pendencyData.copyWithCompanion(PendencyTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', title: Value('title'), message: Value('message'), date: Value(DateTime(2026, 1, 10)), type: 'type', senderId: 'senderId', senderName: Value('senderName'), senderPicture: Value('senderPicture'), module: Value('module')));
    expect(pendencyDataNull.toCompanion(true), isNotNull);
    expect(pendencyDataNull.toColumns(false), isNotEmpty);
    expect(PendencyTableCompanion().toString(), contains('PendencyTableCompanion'));
    expect(PendencyTableCompanion().copyWith(), isNotNull);
    expect(PendencyTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', title: Value('title'), message: Value('message'), date: Value(DateTime(2026, 1, 10)), type: 'type', senderId: 'senderId', senderName: Value('senderName'), senderPicture: Value('senderPicture'), module: Value('module')).toColumns(true), isNotEmpty);
    expect(PendencyTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), title: Variable<String>('title'), message: Variable<String>('message'), date: Variable<DateTime>(DateTime(2026, 1, 10)), type: Variable<String>('type'), senderId: Variable<String>('senderId'), senderName: Variable<String>('senderName'), senderPicture: Variable<String>('senderPicture'), module: Variable<String>('module'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(PendencyTableCompanion.custom().toColumns(true), isEmpty);
    db.pendencyTable.validateIntegrity(pendencyData, isInserting: true);
    db.pendencyTable.validateIntegrity(pendencyData, isInserting: false);
    db.pendencyTable.validateIntegrity(PendencyTableCompanion(), isInserting: true);
    db.pendencyTable.validateIntegrity(PendencyTableCompanion(), isInserting: false);
    expect(db.pendencyTable.createAlias('pend_a').aliasedName, isNotEmpty);
    final pendencyDataF = $$PendencyTableTableFilterComposer($db: db, $table: db.pendencyTable);
    pendencyDataF.condominiumId; pendencyDataF.id; pendencyDataF.title; pendencyDataF.message; pendencyDataF.date; pendencyDataF.type; pendencyDataF.senderId; pendencyDataF.senderName; pendencyDataF.senderPicture; pendencyDataF.module;
    final pendencyDataO = $$PendencyTableTableOrderingComposer($db: db, $table: db.pendencyTable);
    pendencyDataO.condominiumId; pendencyDataO.id; pendencyDataO.title; pendencyDataO.message; pendencyDataO.date; pendencyDataO.type; pendencyDataO.senderId; pendencyDataO.senderName; pendencyDataO.senderPicture; pendencyDataO.module;
    final pendencyDataA = $$PendencyTableTableAnnotationComposer($db: db, $table: db.pendencyTable);
    pendencyDataA.condominiumId; pendencyDataA.id; pendencyDataA.title; pendencyDataA.message; pendencyDataA.date; pendencyDataA.type; pendencyDataA.senderId; pendencyDataA.senderName; pendencyDataA.senderPicture; pendencyDataA.module;
    await db.into(db.pendencyTable).insert(pendencyData, mode: InsertMode.replace);
    await (db.select(db.pendencyTable.createAlias('penx'))).get();
    await db.managers.pendencyTable.filter((f) {
      f.condominiumId;
      f.id;
      f.title;
      f.message;
      f.date;
      f.type;
      f.senderId;
      f.senderName;
      f.senderPicture;
      f.module;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.pendencyTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.title;
      o.message;
      o.date;
      o.type;
      o.senderId;
      o.senderName;
      o.senderPicture;
      o.module;
      return o.condominiumId.asc();
    }).get();
    await db.managers.pendencyTable.withReferences().get();
    await db.managers.pendencyTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final meData = MeData(name: 'name', email: 'email', cpf: 'cpf', phone: 'phone', picture: 'picture', pictureHash: 'pictureHash');
    final meDataNull = MeData(name: 'name', email: 'email');
    expect(meData == meData.copyWith(name: 'nameX', email: 'emailX', cpf: Value('cpfX'), phone: Value('phoneX'), picture: Value('pictureX'), pictureHash: Value('pictureHashX')), isFalse);
    expect(meData.copyWith(name: 'nameX', email: 'emailX', cpf: Value('cpfX'), phone: Value('phoneX'), picture: Value('pictureX'), pictureHash: Value('pictureHashX')), isNotNull);
    meData.copyWithCompanion(MeTableCompanion());
    meData.copyWithCompanion(MeTableCompanion.insert(name: 'name', email: 'email', cpf: Value('cpf'), phone: Value('phone'), picture: Value('picture'), pictureHash: Value('pictureHash')));
    expect(meDataNull.toCompanion(true), isNotNull);
    expect(meDataNull.toColumns(false), isNotEmpty);
    expect(MeTableCompanion().toString(), contains('MeTableCompanion'));
    expect(MeTableCompanion().copyWith(), isNotNull);
    expect(MeTableCompanion.insert(name: 'name', email: 'email', cpf: Value('cpf'), phone: Value('phone'), picture: Value('picture'), pictureHash: Value('pictureHash')).toColumns(true), isNotEmpty);
    expect(MeTableCompanion.custom(name: Variable<String>('name'), email: Variable<String>('email'), cpf: Variable<String>('cpf'), phone: Variable<String>('phone'), picture: Variable<String>('picture'), pictureHash: Variable<String>('pictureHash'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(MeTableCompanion.custom().toColumns(true), isEmpty);
    db.meTable.validateIntegrity(meData, isInserting: true);
    db.meTable.validateIntegrity(meData, isInserting: false);
    db.meTable.validateIntegrity(MeTableCompanion(), isInserting: true);
    db.meTable.validateIntegrity(MeTableCompanion(), isInserting: false);
    expect(db.meTable.createAlias('meTa_a').aliasedName, isNotEmpty);
    final meDataF = $$MeTableTableFilterComposer($db: db, $table: db.meTable);
    meDataF.name; meDataF.email; meDataF.cpf; meDataF.phone; meDataF.picture; meDataF.pictureHash;
    final meDataO = $$MeTableTableOrderingComposer($db: db, $table: db.meTable);
    meDataO.name; meDataO.email; meDataO.cpf; meDataO.phone; meDataO.picture; meDataO.pictureHash;
    final meDataA = $$MeTableTableAnnotationComposer($db: db, $table: db.meTable);
    meDataA.name; meDataA.email; meDataA.cpf; meDataA.phone; meDataA.picture; meDataA.pictureHash;
    await db.into(db.meTable).insert(meData, mode: InsertMode.replace);
    await (db.select(db.meTable.createAlias('meTx'))).get();
    await db.managers.meTable.filter((f) {
      f.name;
      f.email;
      f.cpf;
      f.phone;
      f.picture;
      f.pictureHash;
      return f.name.equals('name');
    }).get();
    await db.managers.meTable.orderBy((o) {
      o.name;
      o.email;
      o.cpf;
      o.phone;
      o.picture;
      o.pictureHash;
      return o.name.asc();
    }).get();
    await db.managers.meTable.withReferences().get();
    await db.managers.meTable.filter((f) => f.name.equals('name')).update((o) => o(
      name: Value('name'),
    ));

    final condominiumData = CondominiumData(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus', notificationContext: 'notificationContext');
    final condominiumDataNull = CondominiumData(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus');
    expect(condominiumData == condominiumData.copyWith(id: 'idX', name: 'nameX', address: 'addressX', reference: 'referenceX', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatusX', notificationContext: Value('notificationContextX')), isFalse);
    expect(condominiumData.copyWith(id: 'idX', name: 'nameX', address: 'addressX', reference: 'referenceX', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatusX', notificationContext: Value('notificationContextX')), isNotNull);
    condominiumData.copyWithCompanion(CondominiumTableCompanion());
    condominiumData.copyWithCompanion(CondominiumTableCompanion.insert(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus', notificationContext: Value('notificationContext')));
    expect(condominiumDataNull.toCompanion(true), isNotNull);
    expect(condominiumDataNull.toColumns(false), isNotEmpty);
    expect(CondominiumTableCompanion().toString(), contains('CondominiumTableCompanion'));
    expect(CondominiumTableCompanion().copyWith(), isNotNull);
    expect(CondominiumTableCompanion.insert(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus', notificationContext: Value('notificationContext')).toColumns(true), isNotEmpty);
    expect(CondominiumTableCompanion.custom(id: Variable<String>('id'), name: Variable<String>('name'), address: Variable<String>('address'), reference: Variable<String>('reference'), useFacialBiometric: Variable<bool>(true), managerAccessControlBiometricStatus: Variable<String>('managerAccessControlBiometricStatus'), notificationContext: Variable<String>('notificationContext'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(CondominiumTableCompanion.custom().toColumns(true), isEmpty);
    db.condominiumTable.validateIntegrity(condominiumData, isInserting: true);
    db.condominiumTable.validateIntegrity(condominiumData, isInserting: false);
    db.condominiumTable.validateIntegrity(CondominiumTableCompanion(), isInserting: true);
    db.condominiumTable.validateIntegrity(CondominiumTableCompanion(), isInserting: false);
    expect(db.condominiumTable.createAlias('cond_a').aliasedName, isNotEmpty);
    final condominiumDataF = $$CondominiumTableTableFilterComposer($db: db, $table: db.condominiumTable);
    condominiumDataF.id; condominiumDataF.name; condominiumDataF.address; condominiumDataF.reference; condominiumDataF.useFacialBiometric; condominiumDataF.managerAccessControlBiometricStatus; condominiumDataF.notificationContext;
    final condominiumDataO = $$CondominiumTableTableOrderingComposer($db: db, $table: db.condominiumTable);
    condominiumDataO.id; condominiumDataO.name; condominiumDataO.address; condominiumDataO.reference; condominiumDataO.useFacialBiometric; condominiumDataO.managerAccessControlBiometricStatus; condominiumDataO.notificationContext;
    final condominiumDataA = $$CondominiumTableTableAnnotationComposer($db: db, $table: db.condominiumTable);
    condominiumDataA.id; condominiumDataA.name; condominiumDataA.address; condominiumDataA.reference; condominiumDataA.useFacialBiometric; condominiumDataA.managerAccessControlBiometricStatus; condominiumDataA.notificationContext;
    await db.into(db.condominiumTable).insert(condominiumData, mode: InsertMode.replace);
    await (db.select(db.condominiumTable.createAlias('conx'))).get();
    await db.managers.condominiumTable.filter((f) {
      f.id;
      f.name;
      f.address;
      f.reference;
      f.useFacialBiometric;
      f.managerAccessControlBiometricStatus;
      f.notificationContext;
      return f.id.equals('id');
    }).get();
    await db.managers.condominiumTable.orderBy((o) {
      o.id;
      o.name;
      o.address;
      o.reference;
      o.useFacialBiometric;
      o.managerAccessControlBiometricStatus;
      o.notificationContext;
      return o.id.asc();
    }).get();
    await db.managers.condominiumTable.withReferences().get();
    await db.managers.condominiumTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final accountData = AccountData(id: 'id', number: 'number', name: 'name', condominiumId: 'condominiumId');
    final accountDataNull = AccountData(id: 'id', condominiumId: 'condominiumId');
    expect(accountData == accountData.copyWith(id: 'idX', number: Value('numberX'), name: Value('nameX'), condominiumId: 'condominiumIdX'), isFalse);
    expect(accountData.copyWith(id: 'idX', number: Value('numberX'), name: Value('nameX'), condominiumId: 'condominiumIdX'), isNotNull);
    accountData.copyWithCompanion(AccountTableCompanion());
    accountData.copyWithCompanion(AccountTableCompanion.insert(id: 'id', number: Value('number'), name: Value('name'), condominiumId: 'condominiumId'));
    expect(accountDataNull.toCompanion(true), isNotNull);
    expect(accountDataNull.toColumns(false), isNotEmpty);
    expect(AccountTableCompanion().toString(), contains('AccountTableCompanion'));
    expect(AccountTableCompanion().copyWith(), isNotNull);
    expect(AccountTableCompanion.insert(id: 'id', number: Value('number'), name: Value('name'), condominiumId: 'condominiumId').toColumns(true), isNotEmpty);
    expect(AccountTableCompanion.custom(id: Variable<String>('id'), number: Variable<String>('number'), name: Variable<String>('name'), condominiumId: Variable<String>('condominiumId'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AccountTableCompanion.custom().toColumns(true), isEmpty);
    db.accountTable.validateIntegrity(accountData, isInserting: true);
    db.accountTable.validateIntegrity(accountData, isInserting: false);
    db.accountTable.validateIntegrity(AccountTableCompanion(), isInserting: true);
    db.accountTable.validateIntegrity(AccountTableCompanion(), isInserting: false);
    expect(db.accountTable.createAlias('acco_a').aliasedName, isNotEmpty);
    final accountDataF = $$AccountTableTableFilterComposer($db: db, $table: db.accountTable);
    accountDataF.id; accountDataF.number; accountDataF.name; accountDataF.condominiumId;
    final accountDataO = $$AccountTableTableOrderingComposer($db: db, $table: db.accountTable);
    accountDataO.id; accountDataO.number; accountDataO.name; accountDataO.condominiumId;
    final accountDataA = $$AccountTableTableAnnotationComposer($db: db, $table: db.accountTable);
    accountDataA.id; accountDataA.number; accountDataA.name; accountDataA.condominiumId;
    await db.into(db.accountTable).insert(accountData, mode: InsertMode.replace);
    await (db.select(db.accountTable.createAlias('accx'))).get();
    await db.managers.accountTable.filter((f) {
      f.id;
      f.number;
      f.name;
      f.condominiumId;
      return f.id.equals('id');
    }).get();
    await db.managers.accountTable.orderBy((o) {
      o.id;
      o.number;
      o.name;
      o.condominiumId;
      return o.id.asc();
    }).get();
    await db.managers.accountTable.withReferences().get();
    await db.managers.accountTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final lelloHubData = LelloHubData(number: 'number');
    final lelloHubDataNull = LelloHubData();
    expect(lelloHubData == lelloHubData.copyWith(number: Value('numberX')), isFalse);
    expect(lelloHubData.copyWith(number: Value('numberX')), isNotNull);
    lelloHubData.copyWithCompanion(LelloHubTableCompanion());
    lelloHubData.copyWithCompanion(LelloHubTableCompanion.insert(number: Value('number')));
    expect(lelloHubDataNull.toCompanion(true), isNotNull);
    expect(lelloHubDataNull.toColumns(false), isNotEmpty);
    expect(LelloHubTableCompanion().toString(), contains('LelloHubTableCompanion'));
    expect(LelloHubTableCompanion().copyWith(), isNotNull);
    expect(LelloHubTableCompanion.insert(number: Value('number')).toColumns(true), isNotEmpty);
    expect(LelloHubTableCompanion.custom(number: Variable<String>('number'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(LelloHubTableCompanion.custom().toColumns(true), isEmpty);
    db.lelloHubTable.validateIntegrity(lelloHubData, isInserting: true);
    db.lelloHubTable.validateIntegrity(lelloHubData, isInserting: false);
    db.lelloHubTable.validateIntegrity(LelloHubTableCompanion(), isInserting: true);
    db.lelloHubTable.validateIntegrity(LelloHubTableCompanion(), isInserting: false);
    expect(db.lelloHubTable.createAlias('lell_a').aliasedName, isNotEmpty);
    final lelloHubDataF = $$LelloHubTableTableFilterComposer($db: db, $table: db.lelloHubTable);
    lelloHubDataF.number;
    final lelloHubDataO = $$LelloHubTableTableOrderingComposer($db: db, $table: db.lelloHubTable);
    lelloHubDataO.number;
    final lelloHubDataA = $$LelloHubTableTableAnnotationComposer($db: db, $table: db.lelloHubTable);
    lelloHubDataA.number;
    await db.into(db.lelloHubTable).insert(lelloHubData, mode: InsertMode.replace);
    await (db.select(db.lelloHubTable.createAlias('lelx'))).get();
    await db.managers.lelloHubTable.filter((f) {
      f.number;
      return f.number.equals('number');
    }).get();
    await db.managers.lelloHubTable.orderBy((o) {
      o.number;
      return o.number.asc();
    }).get();
    await db.managers.lelloHubTable.withReferences().get();
    await db.managers.lelloHubTable.filter((f) => f.number.equals('number')).update((o) => o(
      number: Value('number'),
    ));

    final unitData = UnitData(id: 'id', title: 'title', group: 'group', residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10));
    final unitDataNull = UnitData(id: 'id', title: 'title', residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10));
    expect(unitData == unitData.copyWith(id: 'idX', title: 'titleX', group: Value('groupX'), residentCount: 1, condominiumId: 'condominiumIdX', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatusX', usesApp: true, fixedPhone: 'fixedPhoneX', mobilePhone: 'mobilePhoneX', lastUpdated: DateTime(2026, 1, 10)), isFalse);
    expect(unitData.copyWith(id: 'idX', title: 'titleX', group: Value('groupX'), residentCount: 1, condominiumId: 'condominiumIdX', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatusX', usesApp: true, fixedPhone: 'fixedPhoneX', mobilePhone: 'mobilePhoneX', lastUpdated: DateTime(2026, 1, 10)), isNotNull);
    unitData.copyWithCompanion(UnitTableCompanion());
    unitData.copyWithCompanion(UnitTableCompanion.insert(id: 'id', title: 'title', group: Value('group'), residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10)));
    expect(unitDataNull.toCompanion(true), isNotNull);
    expect(unitDataNull.toColumns(false), isNotEmpty);
    expect(UnitTableCompanion().toString(), contains('UnitTableCompanion'));
    expect(UnitTableCompanion().copyWith(), isNotNull);
    expect(UnitTableCompanion.insert(id: 'id', title: 'title', group: Value('group'), residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10)).toColumns(true), isNotEmpty);
    expect(UnitTableCompanion.custom(id: Variable<String>('id'), title: Variable<String>('title'), group: Variable<String>('group'), residentCount: Variable<int>(1), condominiumId: Variable<String>('condominiumId'), vehicleCount: Variable<int>(1), adimplente: Variable<bool>(true), agreement: Variable<bool>(true), billingStatus: Variable<String>('billingStatus'), usesApp: Variable<bool>(true), fixedPhone: Variable<String>('fixedPhone'), mobilePhone: Variable<String>('mobilePhone'), lastUpdated: Variable<DateTime>(DateTime(2026, 1, 10)), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(UnitTableCompanion.custom().toColumns(true), isEmpty);
    db.unitTable.validateIntegrity(unitData, isInserting: true);
    db.unitTable.validateIntegrity(unitData, isInserting: false);
    db.unitTable.validateIntegrity(UnitTableCompanion(), isInserting: true);
    db.unitTable.validateIntegrity(UnitTableCompanion(), isInserting: false);
    expect(db.unitTable.createAlias('unit_a').aliasedName, isNotEmpty);
    final unitDataF = $$UnitTableTableFilterComposer($db: db, $table: db.unitTable);
    unitDataF.id; unitDataF.title; unitDataF.group; unitDataF.residentCount; unitDataF.condominiumId; unitDataF.vehicleCount; unitDataF.adimplente; unitDataF.agreement; unitDataF.billingStatus; unitDataF.usesApp; unitDataF.fixedPhone; unitDataF.mobilePhone; unitDataF.lastUpdated;
    final unitDataO = $$UnitTableTableOrderingComposer($db: db, $table: db.unitTable);
    unitDataO.id; unitDataO.title; unitDataO.group; unitDataO.residentCount; unitDataO.condominiumId; unitDataO.vehicleCount; unitDataO.adimplente; unitDataO.agreement; unitDataO.billingStatus; unitDataO.usesApp; unitDataO.fixedPhone; unitDataO.mobilePhone; unitDataO.lastUpdated;
    final unitDataA = $$UnitTableTableAnnotationComposer($db: db, $table: db.unitTable);
    unitDataA.id; unitDataA.title; unitDataA.group; unitDataA.residentCount; unitDataA.condominiumId; unitDataA.vehicleCount; unitDataA.adimplente; unitDataA.agreement; unitDataA.billingStatus; unitDataA.usesApp; unitDataA.fixedPhone; unitDataA.mobilePhone; unitDataA.lastUpdated;
    await db.into(db.unitTable).insert(unitData, mode: InsertMode.replace);
    await (db.select(db.unitTable.createAlias('unix'))).get();
    await db.managers.unitTable.filter((f) {
      f.id;
      f.title;
      f.group;
      f.residentCount;
      f.condominiumId;
      f.vehicleCount;
      f.adimplente;
      f.agreement;
      f.billingStatus;
      f.usesApp;
      f.fixedPhone;
      f.mobilePhone;
      f.lastUpdated;
      return f.id.equals('id');
    }).get();
    await db.managers.unitTable.orderBy((o) {
      o.id;
      o.title;
      o.group;
      o.residentCount;
      o.condominiumId;
      o.vehicleCount;
      o.adimplente;
      o.agreement;
      o.billingStatus;
      o.usesApp;
      o.fixedPhone;
      o.mobilePhone;
      o.lastUpdated;
      return o.id.asc();
    }).get();
    await db.managers.unitTable.withReferences().get();
    await db.managers.unitTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final residentData = ResidentData(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', unitResidentCount: 1, condominiumId: 'condominiumId');
    final residentDataNull = ResidentData(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitResidentCount: 1, condominiumId: 'condominiumId');
    expect(residentData == residentData.copyWith(id: 'idX', name: 'nameX', cpf: 'cpfX', unitId: 'unitIdX', unitTitle: 'unitTitleX', unitGroup: Value('unitGroupX'), unitResidentCount: 1, condominiumId: 'condominiumIdX'), isFalse);
    expect(residentData.copyWith(id: 'idX', name: 'nameX', cpf: 'cpfX', unitId: 'unitIdX', unitTitle: 'unitTitleX', unitGroup: Value('unitGroupX'), unitResidentCount: 1, condominiumId: 'condominiumIdX'), isNotNull);
    residentData.copyWithCompanion(ResidentTableCompanion());
    residentData.copyWithCompanion(ResidentTableCompanion.insert(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: Value('unitGroup'), unitResidentCount: 1, condominiumId: 'condominiumId'));
    expect(residentDataNull.toCompanion(true), isNotNull);
    expect(residentDataNull.toColumns(false), isNotEmpty);
    expect(ResidentTableCompanion().toString(), contains('ResidentTableCompanion'));
    expect(ResidentTableCompanion().copyWith(), isNotNull);
    expect(ResidentTableCompanion.insert(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: Value('unitGroup'), unitResidentCount: 1, condominiumId: 'condominiumId').toColumns(true), isNotEmpty);
    expect(ResidentTableCompanion.custom(id: Variable<String>('id'), name: Variable<String>('name'), cpf: Variable<String>('cpf'), unitId: Variable<String>('unitId'), unitTitle: Variable<String>('unitTitle'), unitGroup: Variable<String>('unitGroup'), unitResidentCount: Variable<int>(1), condominiumId: Variable<String>('condominiumId'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ResidentTableCompanion.custom().toColumns(true), isEmpty);
    db.residentTable.validateIntegrity(residentData, isInserting: true);
    db.residentTable.validateIntegrity(residentData, isInserting: false);
    db.residentTable.validateIntegrity(ResidentTableCompanion(), isInserting: true);
    db.residentTable.validateIntegrity(ResidentTableCompanion(), isInserting: false);
    expect(db.residentTable.createAlias('resi_a').aliasedName, isNotEmpty);
    final residentDataF = $$ResidentTableTableFilterComposer($db: db, $table: db.residentTable);
    residentDataF.id; residentDataF.name; residentDataF.cpf; residentDataF.unitId; residentDataF.unitTitle; residentDataF.unitGroup; residentDataF.unitResidentCount; residentDataF.condominiumId;
    final residentDataO = $$ResidentTableTableOrderingComposer($db: db, $table: db.residentTable);
    residentDataO.id; residentDataO.name; residentDataO.cpf; residentDataO.unitId; residentDataO.unitTitle; residentDataO.unitGroup; residentDataO.unitResidentCount; residentDataO.condominiumId;
    final residentDataA = $$ResidentTableTableAnnotationComposer($db: db, $table: db.residentTable);
    residentDataA.id; residentDataA.name; residentDataA.cpf; residentDataA.unitId; residentDataA.unitTitle; residentDataA.unitGroup; residentDataA.unitResidentCount; residentDataA.condominiumId;
    await db.into(db.residentTable).insert(residentData, mode: InsertMode.replace);
    await (db.select(db.residentTable.createAlias('resx'))).get();
    await db.managers.residentTable.filter((f) {
      f.id;
      f.name;
      f.cpf;
      f.unitId;
      f.unitTitle;
      f.unitGroup;
      f.unitResidentCount;
      f.condominiumId;
      return f.id.equals('id');
    }).get();
    await db.managers.residentTable.orderBy((o) {
      o.id;
      o.name;
      o.cpf;
      o.unitId;
      o.unitTitle;
      o.unitGroup;
      o.unitResidentCount;
      o.condominiumId;
      return o.id.asc();
    }).get();
    await db.managers.residentTable.withReferences().get();
    await db.managers.residentTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final incomeForecastData = IncomeForecastData(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5);
    final incomeForecastDataNull = IncomeForecastData(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5);
    expect(incomeForecastData == incomeForecastData.copyWith(condominiumId: 'condominiumIdX', year: 1, month: 1, forecastPeriod: 'forecastPeriodX', forecast: 1.5, value: 1.5), isFalse);
    expect(incomeForecastData.copyWith(condominiumId: 'condominiumIdX', year: 1, month: 1, forecastPeriod: 'forecastPeriodX', forecast: 1.5, value: 1.5), isNotNull);
    incomeForecastData.copyWithCompanion(IncomeForecastTableCompanion());
    incomeForecastData.copyWithCompanion(IncomeForecastTableCompanion.insert(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5));
    expect(incomeForecastDataNull.toCompanion(true), isNotNull);
    expect(incomeForecastDataNull.toColumns(false), isNotEmpty);
    expect(IncomeForecastTableCompanion().toString(), contains('IncomeForecastTableCompanion'));
    expect(IncomeForecastTableCompanion().copyWith(), isNotNull);
    expect(IncomeForecastTableCompanion.insert(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5).toColumns(true), isNotEmpty);
    expect(IncomeForecastTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), year: Variable<int>(1), month: Variable<int>(1), forecastPeriod: Variable<String>('forecastPeriod'), forecast: Variable<double>(1.5), value: Variable<double>(1.5), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(IncomeForecastTableCompanion.custom().toColumns(true), isEmpty);
    db.incomeForecastTable.validateIntegrity(incomeForecastData, isInserting: true);
    db.incomeForecastTable.validateIntegrity(incomeForecastData, isInserting: false);
    db.incomeForecastTable.validateIntegrity(IncomeForecastTableCompanion(), isInserting: true);
    db.incomeForecastTable.validateIntegrity(IncomeForecastTableCompanion(), isInserting: false);
    expect(db.incomeForecastTable.createAlias('inco_a').aliasedName, isNotEmpty);
    final incomeForecastDataF = $$IncomeForecastTableTableFilterComposer($db: db, $table: db.incomeForecastTable);
    incomeForecastDataF.condominiumId; incomeForecastDataF.year; incomeForecastDataF.month; incomeForecastDataF.forecastPeriod; incomeForecastDataF.forecast; incomeForecastDataF.value;
    final incomeForecastDataO = $$IncomeForecastTableTableOrderingComposer($db: db, $table: db.incomeForecastTable);
    incomeForecastDataO.condominiumId; incomeForecastDataO.year; incomeForecastDataO.month; incomeForecastDataO.forecastPeriod; incomeForecastDataO.forecast; incomeForecastDataO.value;
    final incomeForecastDataA = $$IncomeForecastTableTableAnnotationComposer($db: db, $table: db.incomeForecastTable);
    incomeForecastDataA.condominiumId; incomeForecastDataA.year; incomeForecastDataA.month; incomeForecastDataA.forecastPeriod; incomeForecastDataA.forecast; incomeForecastDataA.value;
    await db.into(db.incomeForecastTable).insert(incomeForecastData, mode: InsertMode.replace);
    await (db.select(db.incomeForecastTable.createAlias('incx'))).get();
    await db.managers.incomeForecastTable.filter((f) {
      f.condominiumId;
      f.year;
      f.month;
      f.forecastPeriod;
      f.forecast;
      f.value;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.incomeForecastTable.orderBy((o) {
      o.condominiumId;
      o.year;
      o.month;
      o.forecastPeriod;
      o.forecast;
      o.value;
      return o.condominiumId.asc();
    }).get();
    await db.managers.incomeForecastTable.withReferences().get();
    await db.managers.incomeForecastTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final incomeData = IncomeData(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1);
    final incomeDataNull = IncomeData(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1);
    expect(incomeData == incomeData.copyWith(condominiumId: 'condominiumIdX', value: 1.5, year: 1, month: 1), isFalse);
    expect(incomeData.copyWith(condominiumId: 'condominiumIdX', value: 1.5, year: 1, month: 1), isNotNull);
    incomeData.copyWithCompanion(IncomeTableCompanion());
    incomeData.copyWithCompanion(IncomeTableCompanion.insert(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1));
    expect(incomeDataNull.toCompanion(true), isNotNull);
    expect(incomeDataNull.toColumns(false), isNotEmpty);
    expect(IncomeTableCompanion().toString(), contains('IncomeTableCompanion'));
    expect(IncomeTableCompanion().copyWith(), isNotNull);
    expect(IncomeTableCompanion.insert(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1).toColumns(true), isNotEmpty);
    expect(IncomeTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), value: Variable<double>(1.5), year: Variable<int>(1), month: Variable<int>(1), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(IncomeTableCompanion.custom().toColumns(true), isEmpty);
    db.incomeTable.validateIntegrity(incomeData, isInserting: true);
    db.incomeTable.validateIntegrity(incomeData, isInserting: false);
    db.incomeTable.validateIntegrity(IncomeTableCompanion(), isInserting: true);
    db.incomeTable.validateIntegrity(IncomeTableCompanion(), isInserting: false);
    expect(db.incomeTable.createAlias('inco_a').aliasedName, isNotEmpty);
    final incomeDataF = $$IncomeTableTableFilterComposer($db: db, $table: db.incomeTable);
    incomeDataF.condominiumId; incomeDataF.value; incomeDataF.year; incomeDataF.month;
    final incomeDataO = $$IncomeTableTableOrderingComposer($db: db, $table: db.incomeTable);
    incomeDataO.condominiumId; incomeDataO.value; incomeDataO.year; incomeDataO.month;
    final incomeDataA = $$IncomeTableTableAnnotationComposer($db: db, $table: db.incomeTable);
    incomeDataA.condominiumId; incomeDataA.value; incomeDataA.year; incomeDataA.month;
    await db.into(db.incomeTable).insert(incomeData, mode: InsertMode.replace);
    await (db.select(db.incomeTable.createAlias('incx'))).get();
    await db.managers.incomeTable.filter((f) {
      f.condominiumId;
      f.value;
      f.year;
      f.month;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.incomeTable.orderBy((o) {
      o.condominiumId;
      o.value;
      o.year;
      o.month;
      return o.condominiumId.asc();
    }).get();
    await db.managers.incomeTable.withReferences().get();
    await db.managers.incomeTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final incomeShareData = IncomeShareData(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color');
    final incomeShareDataNull = IncomeShareData(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color');
    expect(incomeShareData == incomeShareData.copyWith(condominiumId: 'condominiumIdX', year: 1, month: 1, title: 'titleX', total: 1, share: 1.5, color: 'colorX'), isFalse);
    expect(incomeShareData.copyWith(condominiumId: 'condominiumIdX', year: 1, month: 1, title: 'titleX', total: 1, share: 1.5, color: 'colorX'), isNotNull);
    incomeShareData.copyWithCompanion(IncomeShareTableCompanion());
    incomeShareData.copyWithCompanion(IncomeShareTableCompanion.insert(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color'));
    expect(incomeShareDataNull.toCompanion(true), isNotNull);
    expect(incomeShareDataNull.toColumns(false), isNotEmpty);
    expect(IncomeShareTableCompanion().toString(), contains('IncomeShareTableCompanion'));
    expect(IncomeShareTableCompanion().copyWith(), isNotNull);
    expect(IncomeShareTableCompanion.insert(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color').toColumns(true), isNotEmpty);
    expect(IncomeShareTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), year: Variable<int>(1), month: Variable<int>(1), title: Variable<String>('title'), total: Variable<int>(1), share: Variable<double>(1.5), color: Variable<String>('color'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(IncomeShareTableCompanion.custom().toColumns(true), isEmpty);
    db.incomeShareTable.validateIntegrity(incomeShareData, isInserting: true);
    db.incomeShareTable.validateIntegrity(incomeShareData, isInserting: false);
    db.incomeShareTable.validateIntegrity(IncomeShareTableCompanion(), isInserting: true);
    db.incomeShareTable.validateIntegrity(IncomeShareTableCompanion(), isInserting: false);
    expect(db.incomeShareTable.createAlias('inco_a').aliasedName, isNotEmpty);
    final incomeShareDataF = $$IncomeShareTableTableFilterComposer($db: db, $table: db.incomeShareTable);
    incomeShareDataF.condominiumId; incomeShareDataF.year; incomeShareDataF.month; incomeShareDataF.title; incomeShareDataF.total; incomeShareDataF.share; incomeShareDataF.color;
    final incomeShareDataO = $$IncomeShareTableTableOrderingComposer($db: db, $table: db.incomeShareTable);
    incomeShareDataO.condominiumId; incomeShareDataO.year; incomeShareDataO.month; incomeShareDataO.title; incomeShareDataO.total; incomeShareDataO.share; incomeShareDataO.color;
    final incomeShareDataA = $$IncomeShareTableTableAnnotationComposer($db: db, $table: db.incomeShareTable);
    incomeShareDataA.condominiumId; incomeShareDataA.year; incomeShareDataA.month; incomeShareDataA.title; incomeShareDataA.total; incomeShareDataA.share; incomeShareDataA.color;
    await db.into(db.incomeShareTable).insert(incomeShareData, mode: InsertMode.replace);
    await (db.select(db.incomeShareTable.createAlias('incx'))).get();
    await db.managers.incomeShareTable.filter((f) {
      f.condominiumId;
      f.year;
      f.month;
      f.title;
      f.total;
      f.share;
      f.color;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.incomeShareTable.orderBy((o) {
      o.condominiumId;
      o.year;
      o.month;
      o.title;
      o.total;
      o.share;
      o.color;
      return o.condominiumId.asc();
    }).get();
    await db.managers.incomeShareTable.withReferences().get();
    await db.managers.incomeShareTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final chatContactData = ChatContactData(id: 'id', condominiumId: 'condominiumId', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', phone: 'phone');
    final chatContactDataNull = ChatContactData(id: 'id', condominiumId: 'condominiumId');
    expect(chatContactData == chatContactData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', unitId: Value('unitIdX'), unitTitle: Value('unitTitleX'), unitGroup: Value('unitGroupX'), phone: Value('phoneX')), isFalse);
    expect(chatContactData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', unitId: Value('unitIdX'), unitTitle: Value('unitTitleX'), unitGroup: Value('unitGroupX'), phone: Value('phoneX')), isNotNull);
    chatContactData.copyWithCompanion(ChatContactTableCompanion());
    chatContactData.copyWithCompanion(ChatContactTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', unitId: Value('unitId'), unitTitle: Value('unitTitle'), unitGroup: Value('unitGroup'), phone: Value('phone')));
    expect(chatContactDataNull.toCompanion(true), isNotNull);
    expect(chatContactDataNull.toColumns(false), isNotEmpty);
    expect(ChatContactTableCompanion().toString(), contains('ChatContactTableCompanion'));
    expect(ChatContactTableCompanion().copyWith(), isNotNull);
    expect(ChatContactTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', unitId: Value('unitId'), unitTitle: Value('unitTitle'), unitGroup: Value('unitGroup'), phone: Value('phone')).toColumns(true), isNotEmpty);
    expect(ChatContactTableCompanion.custom(id: Variable<String>('id'), condominiumId: Variable<String>('condominiumId'), unitId: Variable<String>('unitId'), unitTitle: Variable<String>('unitTitle'), unitGroup: Variable<String>('unitGroup'), phone: Variable<String>('phone'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ChatContactTableCompanion.custom().toColumns(true), isEmpty);
    db.chatContactTable.validateIntegrity(chatContactData, isInserting: true);
    db.chatContactTable.validateIntegrity(chatContactData, isInserting: false);
    db.chatContactTable.validateIntegrity(ChatContactTableCompanion(), isInserting: true);
    db.chatContactTable.validateIntegrity(ChatContactTableCompanion(), isInserting: false);
    expect(db.chatContactTable.createAlias('chat_a').aliasedName, isNotEmpty);
    final chatContactDataF = $$ChatContactTableTableFilterComposer($db: db, $table: db.chatContactTable);
    chatContactDataF.id; chatContactDataF.condominiumId; chatContactDataF.unitId; chatContactDataF.unitTitle; chatContactDataF.unitGroup; chatContactDataF.phone;
    final chatContactDataO = $$ChatContactTableTableOrderingComposer($db: db, $table: db.chatContactTable);
    chatContactDataO.id; chatContactDataO.condominiumId; chatContactDataO.unitId; chatContactDataO.unitTitle; chatContactDataO.unitGroup; chatContactDataO.phone;
    final chatContactDataA = $$ChatContactTableTableAnnotationComposer($db: db, $table: db.chatContactTable);
    chatContactDataA.id; chatContactDataA.condominiumId; chatContactDataA.unitId; chatContactDataA.unitTitle; chatContactDataA.unitGroup; chatContactDataA.phone;
    await db.into(db.chatContactTable).insert(chatContactData, mode: InsertMode.replace);
    await (db.select(db.chatContactTable.createAlias('chax'))).get();
    await db.managers.chatContactTable.filter((f) {
      f.id;
      f.condominiumId;
      f.unitId;
      f.unitTitle;
      f.unitGroup;
      f.phone;
      return f.id.equals('id');
    }).get();
    await db.managers.chatContactTable.orderBy((o) {
      o.id;
      o.condominiumId;
      o.unitId;
      o.unitTitle;
      o.unitGroup;
      o.phone;
      return o.id.asc();
    }).get();
    await db.managers.chatContactTable.withReferences().get();
    await db.managers.chatContactTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final employeeData = EmployeeData(condominiumId: 'condominiumId', id: 'id', name: 'name', dob: DateTime(2026, 1, 10), role: 'role', hiringDate: DateTime(2026, 1, 10), phone: 'phone', phone2: 'phone2', address: 'address', addressNumber: 'addressNumber', addressComplement: 'addressComplement', salary: 1.5, schooling: 'schooling', status: 'status');
    final employeeDataNull = EmployeeData(condominiumId: 'condominiumId', id: 'id');
    expect(employeeData == employeeData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', name: Value('nameX'), dob: Value(DateTime(2026, 1, 10)), role: Value('roleX'), hiringDate: Value(DateTime(2026, 1, 10)), phone: Value('phoneX'), phone2: Value('phone2X'), address: Value('addressX'), addressNumber: Value('addressNumberX'), addressComplement: Value('addressComplementX'), salary: Value(1.5), schooling: Value('schoolingX'), status: Value('statusX')), isFalse);
    expect(employeeData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', name: Value('nameX'), dob: Value(DateTime(2026, 1, 10)), role: Value('roleX'), hiringDate: Value(DateTime(2026, 1, 10)), phone: Value('phoneX'), phone2: Value('phone2X'), address: Value('addressX'), addressNumber: Value('addressNumberX'), addressComplement: Value('addressComplementX'), salary: Value(1.5), schooling: Value('schoolingX'), status: Value('statusX')), isNotNull);
    employeeData.copyWithCompanion(EmployeeTableCompanion());
    employeeData.copyWithCompanion(EmployeeTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', name: Value('name'), dob: Value(DateTime(2026, 1, 10)), role: Value('role'), hiringDate: Value(DateTime(2026, 1, 10)), phone: Value('phone'), phone2: Value('phone2'), address: Value('address'), addressNumber: Value('addressNumber'), addressComplement: Value('addressComplement'), salary: Value(1.5), schooling: Value('schooling'), status: Value('status')));
    expect(employeeDataNull.toCompanion(true), isNotNull);
    expect(employeeDataNull.toColumns(false), isNotEmpty);
    expect(EmployeeTableCompanion().toString(), contains('EmployeeTableCompanion'));
    expect(EmployeeTableCompanion().copyWith(), isNotNull);
    expect(EmployeeTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', name: Value('name'), dob: Value(DateTime(2026, 1, 10)), role: Value('role'), hiringDate: Value(DateTime(2026, 1, 10)), phone: Value('phone'), phone2: Value('phone2'), address: Value('address'), addressNumber: Value('addressNumber'), addressComplement: Value('addressComplement'), salary: Value(1.5), schooling: Value('schooling'), status: Value('status')).toColumns(true), isNotEmpty);
    expect(EmployeeTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), name: Variable<String>('name'), dob: Variable<DateTime>(DateTime(2026, 1, 10)), role: Variable<String>('role'), hiringDate: Variable<DateTime>(DateTime(2026, 1, 10)), phone: Variable<String>('phone'), phone2: Variable<String>('phone2'), address: Variable<String>('address'), addressNumber: Variable<String>('addressNumber'), addressComplement: Variable<String>('addressComplement'), salary: Variable<double>(1.5), schooling: Variable<String>('schooling'), status: Variable<String>('status'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(EmployeeTableCompanion.custom().toColumns(true), isEmpty);
    db.employeeTable.validateIntegrity(employeeData, isInserting: true);
    db.employeeTable.validateIntegrity(employeeData, isInserting: false);
    db.employeeTable.validateIntegrity(EmployeeTableCompanion(), isInserting: true);
    db.employeeTable.validateIntegrity(EmployeeTableCompanion(), isInserting: false);
    expect(db.employeeTable.createAlias('empl_a').aliasedName, isNotEmpty);
    final employeeDataF = $$EmployeeTableTableFilterComposer($db: db, $table: db.employeeTable);
    employeeDataF.condominiumId; employeeDataF.id; employeeDataF.name; employeeDataF.dob; employeeDataF.role; employeeDataF.hiringDate; employeeDataF.phone; employeeDataF.phone2; employeeDataF.address; employeeDataF.addressNumber; employeeDataF.addressComplement; employeeDataF.salary; employeeDataF.schooling; employeeDataF.status;
    final employeeDataO = $$EmployeeTableTableOrderingComposer($db: db, $table: db.employeeTable);
    employeeDataO.condominiumId; employeeDataO.id; employeeDataO.name; employeeDataO.dob; employeeDataO.role; employeeDataO.hiringDate; employeeDataO.phone; employeeDataO.phone2; employeeDataO.address; employeeDataO.addressNumber; employeeDataO.addressComplement; employeeDataO.salary; employeeDataO.schooling; employeeDataO.status;
    final employeeDataA = $$EmployeeTableTableAnnotationComposer($db: db, $table: db.employeeTable);
    employeeDataA.condominiumId; employeeDataA.id; employeeDataA.name; employeeDataA.dob; employeeDataA.role; employeeDataA.hiringDate; employeeDataA.phone; employeeDataA.phone2; employeeDataA.address; employeeDataA.addressNumber; employeeDataA.addressComplement; employeeDataA.salary; employeeDataA.schooling; employeeDataA.status;
    await db.into(db.employeeTable).insert(employeeData, mode: InsertMode.replace);
    await (db.select(db.employeeTable.createAlias('empx'))).get();
    await db.managers.employeeTable.filter((f) {
      f.condominiumId;
      f.id;
      f.name;
      f.dob;
      f.role;
      f.hiringDate;
      f.phone;
      f.phone2;
      f.address;
      f.addressNumber;
      f.addressComplement;
      f.salary;
      f.schooling;
      f.status;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.employeeTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.name;
      o.dob;
      o.role;
      o.hiringDate;
      o.phone;
      o.phone2;
      o.address;
      o.addressNumber;
      o.addressComplement;
      o.salary;
      o.schooling;
      o.status;
      return o.condominiumId.asc();
    }).get();
    await db.managers.employeeTable.withReferences().get();
    await db.managers.employeeTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final reservationSummaryData = ReservationSummaryData(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type');
    final reservationSummaryDataNull = ReservationSummaryData(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type');
    expect(reservationSummaryData == reservationSummaryData.copyWith(day: DateTime(2026, 1, 10), condominiumId: 'condominiumIdX', type: 'typeX'), isFalse);
    expect(reservationSummaryData.copyWith(day: DateTime(2026, 1, 10), condominiumId: 'condominiumIdX', type: 'typeX'), isNotNull);
    reservationSummaryData.copyWithCompanion(ReservationSummaryTableCompanion());
    reservationSummaryData.copyWithCompanion(ReservationSummaryTableCompanion.insert(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type'));
    expect(reservationSummaryDataNull.toCompanion(true), isNotNull);
    expect(reservationSummaryDataNull.toColumns(false), isNotEmpty);
    expect(ReservationSummaryTableCompanion().toString(), contains('ReservationSummaryTableCompanion'));
    expect(ReservationSummaryTableCompanion().copyWith(), isNotNull);
    expect(ReservationSummaryTableCompanion.insert(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type').toColumns(true), isNotEmpty);
    expect(ReservationSummaryTableCompanion.custom(day: Variable<DateTime>(DateTime(2026, 1, 10)), condominiumId: Variable<String>('condominiumId'), type: Variable<String>('type'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ReservationSummaryTableCompanion.custom().toColumns(true), isEmpty);
    db.reservationSummaryTable.validateIntegrity(reservationSummaryData, isInserting: true);
    db.reservationSummaryTable.validateIntegrity(reservationSummaryData, isInserting: false);
    db.reservationSummaryTable.validateIntegrity(ReservationSummaryTableCompanion(), isInserting: true);
    db.reservationSummaryTable.validateIntegrity(ReservationSummaryTableCompanion(), isInserting: false);
    expect(db.reservationSummaryTable.createAlias('rese_a').aliasedName, isNotEmpty);
    final reservationSummaryDataF = $$ReservationSummaryTableTableFilterComposer($db: db, $table: db.reservationSummaryTable);
    reservationSummaryDataF.day; reservationSummaryDataF.condominiumId; reservationSummaryDataF.type;
    final reservationSummaryDataO = $$ReservationSummaryTableTableOrderingComposer($db: db, $table: db.reservationSummaryTable);
    reservationSummaryDataO.day; reservationSummaryDataO.condominiumId; reservationSummaryDataO.type;
    final reservationSummaryDataA = $$ReservationSummaryTableTableAnnotationComposer($db: db, $table: db.reservationSummaryTable);
    reservationSummaryDataA.day; reservationSummaryDataA.condominiumId; reservationSummaryDataA.type;
    await db.into(db.reservationSummaryTable).insert(reservationSummaryData, mode: InsertMode.replace);
    await (db.select(db.reservationSummaryTable.createAlias('resx'))).get();
    await db.managers.reservationSummaryTable.filter((f) {
      f.day;
      f.condominiumId;
      f.type;
      return f.day.equals(DateTime(2026, 1, 10));
    }).get();
    await db.managers.reservationSummaryTable.orderBy((o) {
      o.day;
      o.condominiumId;
      o.type;
      return o.day.asc();
    }).get();
    await db.managers.reservationSummaryTable.withReferences().get();
    await db.managers.reservationSummaryTable.filter((f) => f.day.equals(DateTime(2026, 1, 10))).update((o) => o(
      day: Value(DateTime(2026, 1, 10)),
    ));

    final spaceData = SpaceData(id: 'id', name: 'name', pictureUrl: 'pictureUrl', condominiumId: 'condominiumId');
    final spaceDataNull = SpaceData(id: 'id', condominiumId: 'condominiumId');
    expect(spaceData == spaceData.copyWith(id: 'idX', name: Value('nameX'), pictureUrl: Value('pictureUrlX'), condominiumId: 'condominiumIdX'), isFalse);
    expect(spaceData.copyWith(id: 'idX', name: Value('nameX'), pictureUrl: Value('pictureUrlX'), condominiumId: 'condominiumIdX'), isNotNull);
    spaceData.copyWithCompanion(SpaceTableCompanion());
    spaceData.copyWithCompanion(SpaceTableCompanion.insert(id: 'id', name: Value('name'), pictureUrl: Value('pictureUrl'), condominiumId: 'condominiumId'));
    expect(spaceDataNull.toCompanion(true), isNotNull);
    expect(spaceDataNull.toColumns(false), isNotEmpty);
    expect(SpaceTableCompanion().toString(), contains('SpaceTableCompanion'));
    expect(SpaceTableCompanion().copyWith(), isNotNull);
    expect(SpaceTableCompanion.insert(id: 'id', name: Value('name'), pictureUrl: Value('pictureUrl'), condominiumId: 'condominiumId').toColumns(true), isNotEmpty);
    expect(SpaceTableCompanion.custom(id: Variable<String>('id'), name: Variable<String>('name'), pictureUrl: Variable<String>('pictureUrl'), condominiumId: Variable<String>('condominiumId'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(SpaceTableCompanion.custom().toColumns(true), isEmpty);
    db.spaceTable.validateIntegrity(spaceData, isInserting: true);
    db.spaceTable.validateIntegrity(spaceData, isInserting: false);
    db.spaceTable.validateIntegrity(SpaceTableCompanion(), isInserting: true);
    db.spaceTable.validateIntegrity(SpaceTableCompanion(), isInserting: false);
    expect(db.spaceTable.createAlias('spac_a').aliasedName, isNotEmpty);
    final spaceDataF = $$SpaceTableTableFilterComposer($db: db, $table: db.spaceTable);
    spaceDataF.id; spaceDataF.name; spaceDataF.pictureUrl; spaceDataF.condominiumId;
    final spaceDataO = $$SpaceTableTableOrderingComposer($db: db, $table: db.spaceTable);
    spaceDataO.id; spaceDataO.name; spaceDataO.pictureUrl; spaceDataO.condominiumId;
    final spaceDataA = $$SpaceTableTableAnnotationComposer($db: db, $table: db.spaceTable);
    spaceDataA.id; spaceDataA.name; spaceDataA.pictureUrl; spaceDataA.condominiumId;
    await db.into(db.spaceTable).insert(spaceData, mode: InsertMode.replace);
    await (db.select(db.spaceTable.createAlias('spax'))).get();
    await db.managers.spaceTable.filter((f) {
      f.id;
      f.name;
      f.pictureUrl;
      f.condominiumId;
      return f.id.equals('id');
    }).get();
    await db.managers.spaceTable.orderBy((o) {
      o.id;
      o.name;
      o.pictureUrl;
      o.condominiumId;
      return o.id.asc();
    }).get();
    await db.managers.spaceTable.withReferences().get();
    await db.managers.spaceTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final condominiumBalanceData = CondominiumBalanceData(id: 'id', reference: 'reference', balance: 1.5, previousBalance: 1.5, forecast: 1.5, income: 1.5, expenses: 1.5, date: DateTime(2026, 1, 10), lastUpdatedAt: DateTime(2026, 1, 10));
    final condominiumBalanceDataNull = CondominiumBalanceData(reference: 'reference');
    expect(condominiumBalanceData == condominiumBalanceData.copyWith(id: Value('idX'), reference: 'referenceX', balance: Value(1.5), previousBalance: Value(1.5), forecast: Value(1.5), income: Value(1.5), expenses: Value(1.5), date: Value(DateTime(2026, 1, 10)), lastUpdatedAt: Value(DateTime(2026, 1, 10))), isFalse);
    expect(condominiumBalanceData.copyWith(id: Value('idX'), reference: 'referenceX', balance: Value(1.5), previousBalance: Value(1.5), forecast: Value(1.5), income: Value(1.5), expenses: Value(1.5), date: Value(DateTime(2026, 1, 10)), lastUpdatedAt: Value(DateTime(2026, 1, 10))), isNotNull);
    condominiumBalanceData.copyWithCompanion(CondominiumBalanceTableCompanion());
    condominiumBalanceData.copyWithCompanion(CondominiumBalanceTableCompanion.insert(id: Value('id'), reference: 'reference', balance: Value(1.5), previousBalance: Value(1.5), forecast: Value(1.5), income: Value(1.5), expenses: Value(1.5), date: Value(DateTime(2026, 1, 10)), lastUpdatedAt: Value(DateTime(2026, 1, 10))));
    expect(condominiumBalanceDataNull.toCompanion(true), isNotNull);
    expect(condominiumBalanceDataNull.toColumns(false), isNotEmpty);
    expect(CondominiumBalanceTableCompanion().toString(), contains('CondominiumBalanceTableCompanion'));
    expect(CondominiumBalanceTableCompanion().copyWith(), isNotNull);
    expect(CondominiumBalanceTableCompanion.insert(id: Value('id'), reference: 'reference', balance: Value(1.5), previousBalance: Value(1.5), forecast: Value(1.5), income: Value(1.5), expenses: Value(1.5), date: Value(DateTime(2026, 1, 10)), lastUpdatedAt: Value(DateTime(2026, 1, 10))).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceTableCompanion.custom(id: Variable<String>('id'), reference: Variable<String>('reference'), balance: Variable<double>(1.5), previousBalance: Variable<double>(1.5), forecast: Variable<double>(1.5), income: Variable<double>(1.5), expenses: Variable<double>(1.5), date: Variable<DateTime>(DateTime(2026, 1, 10)), lastUpdatedAt: Variable<DateTime>(DateTime(2026, 1, 10)), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceTableCompanion.custom().toColumns(true), isEmpty);
    db.condominiumBalanceTable.validateIntegrity(condominiumBalanceData, isInserting: true);
    db.condominiumBalanceTable.validateIntegrity(condominiumBalanceData, isInserting: false);
    db.condominiumBalanceTable.validateIntegrity(CondominiumBalanceTableCompanion(), isInserting: true);
    db.condominiumBalanceTable.validateIntegrity(CondominiumBalanceTableCompanion(), isInserting: false);
    expect(db.condominiumBalanceTable.createAlias('cond_a').aliasedName, isNotEmpty);
    final condominiumBalanceDataF = $$CondominiumBalanceTableTableFilterComposer($db: db, $table: db.condominiumBalanceTable);
    condominiumBalanceDataF.id; condominiumBalanceDataF.reference; condominiumBalanceDataF.balance; condominiumBalanceDataF.previousBalance; condominiumBalanceDataF.forecast; condominiumBalanceDataF.income; condominiumBalanceDataF.expenses; condominiumBalanceDataF.date; condominiumBalanceDataF.lastUpdatedAt;
    final condominiumBalanceDataO = $$CondominiumBalanceTableTableOrderingComposer($db: db, $table: db.condominiumBalanceTable);
    condominiumBalanceDataO.id; condominiumBalanceDataO.reference; condominiumBalanceDataO.balance; condominiumBalanceDataO.previousBalance; condominiumBalanceDataO.forecast; condominiumBalanceDataO.income; condominiumBalanceDataO.expenses; condominiumBalanceDataO.date; condominiumBalanceDataO.lastUpdatedAt;
    final condominiumBalanceDataA = $$CondominiumBalanceTableTableAnnotationComposer($db: db, $table: db.condominiumBalanceTable);
    condominiumBalanceDataA.id; condominiumBalanceDataA.reference; condominiumBalanceDataA.balance; condominiumBalanceDataA.previousBalance; condominiumBalanceDataA.forecast; condominiumBalanceDataA.income; condominiumBalanceDataA.expenses; condominiumBalanceDataA.date; condominiumBalanceDataA.lastUpdatedAt;
    await db.into(db.condominiumBalanceTable).insert(condominiumBalanceData, mode: InsertMode.replace);
    await (db.select(db.condominiumBalanceTable.createAlias('conx'))).get();
    await db.managers.condominiumBalanceTable.filter((f) {
      f.id;
      f.reference;
      f.balance;
      f.previousBalance;
      f.forecast;
      f.income;
      f.expenses;
      f.date;
      f.lastUpdatedAt;
      return f.id.equals('id');
    }).get();
    await db.managers.condominiumBalanceTable.orderBy((o) {
      o.id;
      o.reference;
      o.balance;
      o.previousBalance;
      o.forecast;
      o.income;
      o.expenses;
      o.date;
      o.lastUpdatedAt;
      return o.id.asc();
    }).get();
    await db.managers.condominiumBalanceTable.withReferences().get();
    await db.managers.condominiumBalanceTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final condominiumBalanceDetailData = CondominiumBalanceDetailData(reference: 'reference', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, lastUpdatedAt: DateTime(2026, 1, 10));
    final condominiumBalanceDetailDataNull = CondominiumBalanceDetailData(reference: 'reference');
    expect(condominiumBalanceDetailData == condominiumBalanceDetailData.copyWith(reference: 'referenceX', previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), lastUpdatedAt: Value(DateTime(2026, 1, 10))), isFalse);
    expect(condominiumBalanceDetailData.copyWith(reference: 'referenceX', previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), lastUpdatedAt: Value(DateTime(2026, 1, 10))), isNotNull);
    condominiumBalanceDetailData.copyWithCompanion(CondominiumBalanceDetailTableCompanion());
    condominiumBalanceDetailData.copyWithCompanion(CondominiumBalanceDetailTableCompanion.insert(reference: 'reference', previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), lastUpdatedAt: Value(DateTime(2026, 1, 10))));
    expect(condominiumBalanceDetailDataNull.toCompanion(true), isNotNull);
    expect(condominiumBalanceDetailDataNull.toColumns(false), isNotEmpty);
    expect(CondominiumBalanceDetailTableCompanion().toString(), contains('CondominiumBalanceDetailTableCompanion'));
    expect(CondominiumBalanceDetailTableCompanion().copyWith(), isNotNull);
    expect(CondominiumBalanceDetailTableCompanion.insert(reference: 'reference', previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), lastUpdatedAt: Value(DateTime(2026, 1, 10))).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceDetailTableCompanion.custom(reference: Variable<String>('reference'), previousBalance: Variable<double>(1.5), balance: Variable<double>(1.5), accountBalance: Variable<double>(1.5), debit: Variable<double>(1.5), credits: Variable<double>(1.5), lastUpdatedAt: Variable<DateTime>(DateTime(2026, 1, 10)), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceDetailTableCompanion.custom().toColumns(true), isEmpty);
    db.condominiumBalanceDetailTable.validateIntegrity(condominiumBalanceDetailData, isInserting: true);
    db.condominiumBalanceDetailTable.validateIntegrity(condominiumBalanceDetailData, isInserting: false);
    db.condominiumBalanceDetailTable.validateIntegrity(CondominiumBalanceDetailTableCompanion(), isInserting: true);
    db.condominiumBalanceDetailTable.validateIntegrity(CondominiumBalanceDetailTableCompanion(), isInserting: false);
    expect(db.condominiumBalanceDetailTable.createAlias('cond_a').aliasedName, isNotEmpty);
    final condominiumBalanceDetailDataF = $$CondominiumBalanceDetailTableTableFilterComposer($db: db, $table: db.condominiumBalanceDetailTable);
    condominiumBalanceDetailDataF.reference; condominiumBalanceDetailDataF.previousBalance; condominiumBalanceDetailDataF.balance; condominiumBalanceDetailDataF.accountBalance; condominiumBalanceDetailDataF.debit; condominiumBalanceDetailDataF.credits; condominiumBalanceDetailDataF.lastUpdatedAt;
    final condominiumBalanceDetailDataO = $$CondominiumBalanceDetailTableTableOrderingComposer($db: db, $table: db.condominiumBalanceDetailTable);
    condominiumBalanceDetailDataO.reference; condominiumBalanceDetailDataO.previousBalance; condominiumBalanceDetailDataO.balance; condominiumBalanceDetailDataO.accountBalance; condominiumBalanceDetailDataO.debit; condominiumBalanceDetailDataO.credits; condominiumBalanceDetailDataO.lastUpdatedAt;
    final condominiumBalanceDetailDataA = $$CondominiumBalanceDetailTableTableAnnotationComposer($db: db, $table: db.condominiumBalanceDetailTable);
    condominiumBalanceDetailDataA.reference; condominiumBalanceDetailDataA.previousBalance; condominiumBalanceDetailDataA.balance; condominiumBalanceDetailDataA.accountBalance; condominiumBalanceDetailDataA.debit; condominiumBalanceDetailDataA.credits; condominiumBalanceDetailDataA.lastUpdatedAt;
    await db.into(db.condominiumBalanceDetailTable).insert(condominiumBalanceDetailData, mode: InsertMode.replace);
    await (db.select(db.condominiumBalanceDetailTable.createAlias('conx'))).get();
    await db.managers.condominiumBalanceDetailTable.filter((f) {
      f.reference;
      f.previousBalance;
      f.balance;
      f.accountBalance;
      f.debit;
      f.credits;
      f.lastUpdatedAt;
      return f.reference.equals('reference');
    }).get();
    await db.managers.condominiumBalanceDetailTable.orderBy((o) {
      o.reference;
      o.previousBalance;
      o.balance;
      o.accountBalance;
      o.debit;
      o.credits;
      o.lastUpdatedAt;
      return o.reference.asc();
    }).get();
    await db.managers.condominiumBalanceDetailTable.withReferences().get();
    await db.managers.condominiumBalanceDetailTable.filter((f) => f.reference.equals('reference')).update((o) => o(
      reference: Value('reference'),
    ));

    final condominiumBalanceDebitsData = CondominiumBalanceDebitsData(reference: 'reference', id: 'id', name: 'name', type: 'type', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, period: DateTime(2026, 1, 10));
    final condominiumBalanceDebitsDataNull = CondominiumBalanceDebitsData(reference: 'reference');
    expect(condominiumBalanceDebitsData == condominiumBalanceDebitsData.copyWith(reference: 'referenceX', id: Value('idX'), name: Value('nameX'), type: Value('typeX'), previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), period: Value(DateTime(2026, 1, 10))), isFalse);
    expect(condominiumBalanceDebitsData.copyWith(reference: 'referenceX', id: Value('idX'), name: Value('nameX'), type: Value('typeX'), previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), period: Value(DateTime(2026, 1, 10))), isNotNull);
    condominiumBalanceDebitsData.copyWithCompanion(CondominiumBalanceDebitsTableCompanion());
    condominiumBalanceDebitsData.copyWithCompanion(CondominiumBalanceDebitsTableCompanion.insert(reference: 'reference', id: Value('id'), name: Value('name'), type: Value('type'), previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), period: Value(DateTime(2026, 1, 10))));
    expect(condominiumBalanceDebitsDataNull.toCompanion(true), isNotNull);
    expect(condominiumBalanceDebitsDataNull.toColumns(false), isNotEmpty);
    expect(CondominiumBalanceDebitsTableCompanion().toString(), contains('CondominiumBalanceDebitsTableCompanion'));
    expect(CondominiumBalanceDebitsTableCompanion().copyWith(), isNotNull);
    expect(CondominiumBalanceDebitsTableCompanion.insert(reference: 'reference', id: Value('id'), name: Value('name'), type: Value('type'), previousBalance: Value(1.5), balance: Value(1.5), accountBalance: Value(1.5), debit: Value(1.5), credits: Value(1.5), period: Value(DateTime(2026, 1, 10))).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceDebitsTableCompanion.custom(reference: Variable<String>('reference'), id: Variable<String>('id'), name: Variable<String>('name'), type: Variable<String>('type'), previousBalance: Variable<double>(1.5), balance: Variable<double>(1.5), accountBalance: Variable<double>(1.5), debit: Variable<double>(1.5), credits: Variable<double>(1.5), period: Variable<DateTime>(DateTime(2026, 1, 10)), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceDebitsTableCompanion.custom().toColumns(true), isEmpty);
    db.condominiumBalanceDebitsTable.validateIntegrity(condominiumBalanceDebitsData, isInserting: true);
    db.condominiumBalanceDebitsTable.validateIntegrity(condominiumBalanceDebitsData, isInserting: false);
    db.condominiumBalanceDebitsTable.validateIntegrity(CondominiumBalanceDebitsTableCompanion(), isInserting: true);
    db.condominiumBalanceDebitsTable.validateIntegrity(CondominiumBalanceDebitsTableCompanion(), isInserting: false);
    expect(db.condominiumBalanceDebitsTable.createAlias('cond_a').aliasedName, isNotEmpty);
    final condominiumBalanceDebitsDataF = $$CondominiumBalanceDebitsTableTableFilterComposer($db: db, $table: db.condominiumBalanceDebitsTable);
    condominiumBalanceDebitsDataF.reference; condominiumBalanceDebitsDataF.id; condominiumBalanceDebitsDataF.name; condominiumBalanceDebitsDataF.type; condominiumBalanceDebitsDataF.previousBalance; condominiumBalanceDebitsDataF.balance; condominiumBalanceDebitsDataF.accountBalance; condominiumBalanceDebitsDataF.debit; condominiumBalanceDebitsDataF.credits; condominiumBalanceDebitsDataF.period;
    final condominiumBalanceDebitsDataO = $$CondominiumBalanceDebitsTableTableOrderingComposer($db: db, $table: db.condominiumBalanceDebitsTable);
    condominiumBalanceDebitsDataO.reference; condominiumBalanceDebitsDataO.id; condominiumBalanceDebitsDataO.name; condominiumBalanceDebitsDataO.type; condominiumBalanceDebitsDataO.previousBalance; condominiumBalanceDebitsDataO.balance; condominiumBalanceDebitsDataO.accountBalance; condominiumBalanceDebitsDataO.debit; condominiumBalanceDebitsDataO.credits; condominiumBalanceDebitsDataO.period;
    final condominiumBalanceDebitsDataA = $$CondominiumBalanceDebitsTableTableAnnotationComposer($db: db, $table: db.condominiumBalanceDebitsTable);
    condominiumBalanceDebitsDataA.reference; condominiumBalanceDebitsDataA.id; condominiumBalanceDebitsDataA.name; condominiumBalanceDebitsDataA.type; condominiumBalanceDebitsDataA.previousBalance; condominiumBalanceDebitsDataA.balance; condominiumBalanceDebitsDataA.accountBalance; condominiumBalanceDebitsDataA.debit; condominiumBalanceDebitsDataA.credits; condominiumBalanceDebitsDataA.period;
    await db.into(db.condominiumBalanceDebitsTable).insert(condominiumBalanceDebitsData, mode: InsertMode.replace);
    await (db.select(db.condominiumBalanceDebitsTable.createAlias('conx'))).get();
    await db.managers.condominiumBalanceDebitsTable.filter((f) {
      f.reference;
      f.id;
      f.name;
      f.type;
      f.previousBalance;
      f.balance;
      f.accountBalance;
      f.debit;
      f.credits;
      f.period;
      return f.reference.equals('reference');
    }).get();
    await db.managers.condominiumBalanceDebitsTable.orderBy((o) {
      o.reference;
      o.id;
      o.name;
      o.type;
      o.previousBalance;
      o.balance;
      o.accountBalance;
      o.debit;
      o.credits;
      o.period;
      return o.reference.asc();
    }).get();
    await db.managers.condominiumBalanceDebitsTable.withReferences().get();
    await db.managers.condominiumBalanceDebitsTable.filter((f) => f.reference.equals('reference')).update((o) => o(
      reference: Value('reference'),
    ));

    final condominiumBalanceSummaryData = CondominiumBalanceSummaryData(reference: 'reference', name: 'name', debits: 1.5, credits: 1.5);
    final condominiumBalanceSummaryDataNull = CondominiumBalanceSummaryData(reference: 'reference');
    expect(condominiumBalanceSummaryData == condominiumBalanceSummaryData.copyWith(reference: 'referenceX', name: Value('nameX'), debits: Value(1.5), credits: Value(1.5)), isFalse);
    expect(condominiumBalanceSummaryData.copyWith(reference: 'referenceX', name: Value('nameX'), debits: Value(1.5), credits: Value(1.5)), isNotNull);
    condominiumBalanceSummaryData.copyWithCompanion(CondominiumBalanceSummaryTableCompanion());
    condominiumBalanceSummaryData.copyWithCompanion(CondominiumBalanceSummaryTableCompanion.insert(reference: 'reference', name: Value('name'), debits: Value(1.5), credits: Value(1.5)));
    expect(condominiumBalanceSummaryDataNull.toCompanion(true), isNotNull);
    expect(condominiumBalanceSummaryDataNull.toColumns(false), isNotEmpty);
    expect(CondominiumBalanceSummaryTableCompanion().toString(), contains('CondominiumBalanceSummaryTableCompanion'));
    expect(CondominiumBalanceSummaryTableCompanion().copyWith(), isNotNull);
    expect(CondominiumBalanceSummaryTableCompanion.insert(reference: 'reference', name: Value('name'), debits: Value(1.5), credits: Value(1.5)).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceSummaryTableCompanion.custom(reference: Variable<String>('reference'), name: Variable<String>('name'), debits: Variable<double>(1.5), credits: Variable<double>(1.5), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(CondominiumBalanceSummaryTableCompanion.custom().toColumns(true), isEmpty);
    db.condominiumBalanceSummaryTable.validateIntegrity(condominiumBalanceSummaryData, isInserting: true);
    db.condominiumBalanceSummaryTable.validateIntegrity(condominiumBalanceSummaryData, isInserting: false);
    db.condominiumBalanceSummaryTable.validateIntegrity(CondominiumBalanceSummaryTableCompanion(), isInserting: true);
    db.condominiumBalanceSummaryTable.validateIntegrity(CondominiumBalanceSummaryTableCompanion(), isInserting: false);
    expect(db.condominiumBalanceSummaryTable.createAlias('cond_a').aliasedName, isNotEmpty);
    final condominiumBalanceSummaryDataF = $$CondominiumBalanceSummaryTableTableFilterComposer($db: db, $table: db.condominiumBalanceSummaryTable);
    condominiumBalanceSummaryDataF.reference; condominiumBalanceSummaryDataF.name; condominiumBalanceSummaryDataF.debits; condominiumBalanceSummaryDataF.credits;
    final condominiumBalanceSummaryDataO = $$CondominiumBalanceSummaryTableTableOrderingComposer($db: db, $table: db.condominiumBalanceSummaryTable);
    condominiumBalanceSummaryDataO.reference; condominiumBalanceSummaryDataO.name; condominiumBalanceSummaryDataO.debits; condominiumBalanceSummaryDataO.credits;
    final condominiumBalanceSummaryDataA = $$CondominiumBalanceSummaryTableTableAnnotationComposer($db: db, $table: db.condominiumBalanceSummaryTable);
    condominiumBalanceSummaryDataA.reference; condominiumBalanceSummaryDataA.name; condominiumBalanceSummaryDataA.debits; condominiumBalanceSummaryDataA.credits;
    await db.into(db.condominiumBalanceSummaryTable).insert(condominiumBalanceSummaryData, mode: InsertMode.replace);
    await (db.select(db.condominiumBalanceSummaryTable.createAlias('conx'))).get();
    await db.managers.condominiumBalanceSummaryTable.filter((f) {
      f.reference;
      f.name;
      f.debits;
      f.credits;
      return f.reference.equals('reference');
    }).get();
    await db.managers.condominiumBalanceSummaryTable.orderBy((o) {
      o.reference;
      o.name;
      o.debits;
      o.credits;
      return o.reference.asc();
    }).get();
    await db.managers.condominiumBalanceSummaryTable.withReferences().get();
    await db.managers.condominiumBalanceSummaryTable.filter((f) => f.reference.equals('reference')).update((o) => o(
      reference: Value('reference'),
    ));

    final agreementsData = AgreementsData(id: 'id', condominiumId: 'condominiumId', reference: 1, unit: 'unit', unitOwner: 'unitOwner', baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: 'paymentMethod', status: 'status', statusMessage: 'statusMessage', expiration: DateTime(2026, 1, 10), proposaldedDate: DateTime(2026, 1, 10), approvalDate: DateTime(2026, 1, 10), dueDate: 1, lastInstallmentDate: DateTime(2026, 1, 10));
    final agreementsDataNull = AgreementsData(id: 'id', condominiumId: 'condominiumId', reference: 1, baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, dueDate: 1);
    expect(agreementsData == agreementsData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', reference: 1, unit: Value('unitX'), unitOwner: Value('unitOwnerX'), baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: Value('paymentMethodX'), status: Value('statusX'), statusMessage: Value('statusMessageX'), expiration: Value(DateTime(2026, 1, 10)), proposaldedDate: Value(DateTime(2026, 1, 10)), approvalDate: Value(DateTime(2026, 1, 10)), dueDate: 1, lastInstallmentDate: Value(DateTime(2026, 1, 10))), isFalse);
    expect(agreementsData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', reference: 1, unit: Value('unitX'), unitOwner: Value('unitOwnerX'), baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: Value('paymentMethodX'), status: Value('statusX'), statusMessage: Value('statusMessageX'), expiration: Value(DateTime(2026, 1, 10)), proposaldedDate: Value(DateTime(2026, 1, 10)), approvalDate: Value(DateTime(2026, 1, 10)), dueDate: 1, lastInstallmentDate: Value(DateTime(2026, 1, 10))), isNotNull);
    agreementsData.copyWithCompanion(AgreementsTableCompanion());
    agreementsData.copyWithCompanion(AgreementsTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', reference: 1, unit: Value('unit'), unitOwner: Value('unitOwner'), baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: Value('paymentMethod'), status: Value('status'), statusMessage: Value('statusMessage'), expiration: Value(DateTime(2026, 1, 10)), proposaldedDate: Value(DateTime(2026, 1, 10)), approvalDate: Value(DateTime(2026, 1, 10)), dueDate: 1, lastInstallmentDate: Value(DateTime(2026, 1, 10))));
    expect(agreementsDataNull.toCompanion(true), isNotNull);
    expect(agreementsDataNull.toColumns(false), isNotEmpty);
    expect(AgreementsTableCompanion().toString(), contains('AgreementsTableCompanion'));
    expect(AgreementsTableCompanion().copyWith(), isNotNull);
    expect(AgreementsTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', reference: 1, unit: Value('unit'), unitOwner: Value('unitOwner'), baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: Value('paymentMethod'), status: Value('status'), statusMessage: Value('statusMessage'), expiration: Value(DateTime(2026, 1, 10)), proposaldedDate: Value(DateTime(2026, 1, 10)), approvalDate: Value(DateTime(2026, 1, 10)), dueDate: 1, lastInstallmentDate: Value(DateTime(2026, 1, 10))).toColumns(true), isNotEmpty);
    expect(AgreementsTableCompanion.custom(id: Variable<String>('id'), condominiumId: Variable<String>('condominiumId'), reference: Variable<int>(1), unit: Variable<String>('unit'), unitOwner: Variable<String>('unitOwner'), baseValue: Variable<double>(1.5), fineAndCosts: Variable<double>(1.5), installmentQuantity: Variable<int>(1), paymentMethod: Variable<String>('paymentMethod'), status: Variable<String>('status'), statusMessage: Variable<String>('statusMessage'), expiration: Variable<DateTime>(DateTime(2026, 1, 10)), proposaldedDate: Variable<DateTime>(DateTime(2026, 1, 10)), approvalDate: Variable<DateTime>(DateTime(2026, 1, 10)), dueDate: Variable<int>(1), lastInstallmentDate: Variable<DateTime>(DateTime(2026, 1, 10)), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AgreementsTableCompanion.custom().toColumns(true), isEmpty);
    db.agreementsTable.validateIntegrity(agreementsData, isInserting: true);
    db.agreementsTable.validateIntegrity(agreementsData, isInserting: false);
    db.agreementsTable.validateIntegrity(AgreementsTableCompanion(), isInserting: true);
    db.agreementsTable.validateIntegrity(AgreementsTableCompanion(), isInserting: false);
    expect(db.agreementsTable.createAlias('agre_a').aliasedName, isNotEmpty);
    final agreementsDataF = $$AgreementsTableTableFilterComposer($db: db, $table: db.agreementsTable);
    agreementsDataF.id; agreementsDataF.condominiumId; agreementsDataF.reference; agreementsDataF.unit; agreementsDataF.unitOwner; agreementsDataF.baseValue; agreementsDataF.fineAndCosts; agreementsDataF.installmentQuantity; agreementsDataF.paymentMethod; agreementsDataF.status; agreementsDataF.statusMessage; agreementsDataF.expiration; agreementsDataF.proposaldedDate; agreementsDataF.approvalDate; agreementsDataF.dueDate; agreementsDataF.lastInstallmentDate;
    final agreementsDataO = $$AgreementsTableTableOrderingComposer($db: db, $table: db.agreementsTable);
    agreementsDataO.id; agreementsDataO.condominiumId; agreementsDataO.reference; agreementsDataO.unit; agreementsDataO.unitOwner; agreementsDataO.baseValue; agreementsDataO.fineAndCosts; agreementsDataO.installmentQuantity; agreementsDataO.paymentMethod; agreementsDataO.status; agreementsDataO.statusMessage; agreementsDataO.expiration; agreementsDataO.proposaldedDate; agreementsDataO.approvalDate; agreementsDataO.dueDate; agreementsDataO.lastInstallmentDate;
    final agreementsDataA = $$AgreementsTableTableAnnotationComposer($db: db, $table: db.agreementsTable);
    agreementsDataA.id; agreementsDataA.condominiumId; agreementsDataA.reference; agreementsDataA.unit; agreementsDataA.unitOwner; agreementsDataA.baseValue; agreementsDataA.fineAndCosts; agreementsDataA.installmentQuantity; agreementsDataA.paymentMethod; agreementsDataA.status; agreementsDataA.statusMessage; agreementsDataA.expiration; agreementsDataA.proposaldedDate; agreementsDataA.approvalDate; agreementsDataA.dueDate; agreementsDataA.lastInstallmentDate;
    await db.into(db.agreementsTable).insert(agreementsData, mode: InsertMode.replace);
    await (db.select(db.agreementsTable.createAlias('agrx'))).get();
    await db.managers.agreementsTable.filter((f) {
      f.id;
      f.condominiumId;
      f.reference;
      f.unit;
      f.unitOwner;
      f.baseValue;
      f.fineAndCosts;
      f.installmentQuantity;
      f.paymentMethod;
      f.status;
      f.statusMessage;
      f.expiration;
      f.proposaldedDate;
      f.approvalDate;
      f.dueDate;
      f.lastInstallmentDate;
      return f.id.equals('id');
    }).get();
    await db.managers.agreementsTable.orderBy((o) {
      o.id;
      o.condominiumId;
      o.reference;
      o.unit;
      o.unitOwner;
      o.baseValue;
      o.fineAndCosts;
      o.installmentQuantity;
      o.paymentMethod;
      o.status;
      o.statusMessage;
      o.expiration;
      o.proposaldedDate;
      o.approvalDate;
      o.dueDate;
      o.lastInstallmentDate;
      return o.id.asc();
    }).get();
    await db.managers.agreementsTable.withReferences().get();
    await db.managers.agreementsTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final agreementsInstallmentsData = AgreementsInstallmentsData(installmentId: 'installmentId', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, value: 1.5, dueDate: DateTime(2026, 1, 10), status: 'status');
    final agreementsInstallmentsDataNull = AgreementsInstallmentsData(installmentId: 'installmentId', condominiumId: 'condominiumId', reference: 1, value: 1.5);
    expect(agreementsInstallmentsData == agreementsInstallmentsData.copyWith(installmentId: 'installmentIdX', condominiumId: 'condominiumIdX', agreementId: Value('agreementIdX'), reference: 1, value: 1.5, dueDate: Value(DateTime(2026, 1, 10)), status: Value('statusX')), isFalse);
    expect(agreementsInstallmentsData.copyWith(installmentId: 'installmentIdX', condominiumId: 'condominiumIdX', agreementId: Value('agreementIdX'), reference: 1, value: 1.5, dueDate: Value(DateTime(2026, 1, 10)), status: Value('statusX')), isNotNull);
    agreementsInstallmentsData.copyWithCompanion(AgreementsInstallmentsTableCompanion());
    agreementsInstallmentsData.copyWithCompanion(AgreementsInstallmentsTableCompanion.insert(installmentId: 'installmentId', condominiumId: 'condominiumId', agreementId: Value('agreementId'), reference: 1, value: 1.5, dueDate: Value(DateTime(2026, 1, 10)), status: Value('status')));
    expect(agreementsInstallmentsDataNull.toCompanion(true), isNotNull);
    expect(agreementsInstallmentsDataNull.toColumns(false), isNotEmpty);
    expect(AgreementsInstallmentsTableCompanion().toString(), contains('AgreementsInstallmentsTableCompanion'));
    expect(AgreementsInstallmentsTableCompanion().copyWith(), isNotNull);
    expect(AgreementsInstallmentsTableCompanion.insert(installmentId: 'installmentId', condominiumId: 'condominiumId', agreementId: Value('agreementId'), reference: 1, value: 1.5, dueDate: Value(DateTime(2026, 1, 10)), status: Value('status')).toColumns(true), isNotEmpty);
    expect(AgreementsInstallmentsTableCompanion.custom(installmentId: Variable<String>('installmentId'), condominiumId: Variable<String>('condominiumId'), agreementId: Variable<String>('agreementId'), reference: Variable<int>(1), value: Variable<double>(1.5), dueDate: Variable<DateTime>(DateTime(2026, 1, 10)), status: Variable<String>('status'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AgreementsInstallmentsTableCompanion.custom().toColumns(true), isEmpty);
    db.agreementsInstallmentsTable.validateIntegrity(agreementsInstallmentsData, isInserting: true);
    db.agreementsInstallmentsTable.validateIntegrity(agreementsInstallmentsData, isInserting: false);
    db.agreementsInstallmentsTable.validateIntegrity(AgreementsInstallmentsTableCompanion(), isInserting: true);
    db.agreementsInstallmentsTable.validateIntegrity(AgreementsInstallmentsTableCompanion(), isInserting: false);
    expect(db.agreementsInstallmentsTable.createAlias('agre_a').aliasedName, isNotEmpty);
    final agreementsInstallmentsDataF = $$AgreementsInstallmentsTableTableFilterComposer($db: db, $table: db.agreementsInstallmentsTable);
    agreementsInstallmentsDataF.installmentId; agreementsInstallmentsDataF.condominiumId; agreementsInstallmentsDataF.agreementId; agreementsInstallmentsDataF.reference; agreementsInstallmentsDataF.value; agreementsInstallmentsDataF.dueDate; agreementsInstallmentsDataF.status;
    final agreementsInstallmentsDataO = $$AgreementsInstallmentsTableTableOrderingComposer($db: db, $table: db.agreementsInstallmentsTable);
    agreementsInstallmentsDataO.installmentId; agreementsInstallmentsDataO.condominiumId; agreementsInstallmentsDataO.agreementId; agreementsInstallmentsDataO.reference; agreementsInstallmentsDataO.value; agreementsInstallmentsDataO.dueDate; agreementsInstallmentsDataO.status;
    final agreementsInstallmentsDataA = $$AgreementsInstallmentsTableTableAnnotationComposer($db: db, $table: db.agreementsInstallmentsTable);
    agreementsInstallmentsDataA.installmentId; agreementsInstallmentsDataA.condominiumId; agreementsInstallmentsDataA.agreementId; agreementsInstallmentsDataA.reference; agreementsInstallmentsDataA.value; agreementsInstallmentsDataA.dueDate; agreementsInstallmentsDataA.status;
    await db.into(db.agreementsInstallmentsTable).insert(agreementsInstallmentsData, mode: InsertMode.replace);
    await (db.select(db.agreementsInstallmentsTable.createAlias('agrx'))).get();
    await db.managers.agreementsInstallmentsTable.filter((f) {
      f.installmentId;
      f.condominiumId;
      f.agreementId;
      f.reference;
      f.value;
      f.dueDate;
      f.status;
      return f.installmentId.equals('installmentId');
    }).get();
    await db.managers.agreementsInstallmentsTable.orderBy((o) {
      o.installmentId;
      o.condominiumId;
      o.agreementId;
      o.reference;
      o.value;
      o.dueDate;
      o.status;
      return o.installmentId.asc();
    }).get();
    await db.managers.agreementsInstallmentsTable.withReferences().get();
    await db.managers.agreementsInstallmentsTable.filter((f) => f.installmentId.equals('installmentId')).update((o) => o(
      installmentId: Value('installmentId'),
    ));

    final agreementsQuoteData = AgreementsQuoteData(id: 'id', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, dueDate: DateTime(2026, 1, 10), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: 'overdueMessage');
    final agreementsQuoteDataNull = AgreementsQuoteData(id: 'id', condominiumId: 'condominiumId', reference: 1, originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5);
    expect(agreementsQuoteData == agreementsQuoteData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', agreementId: Value('agreementIdX'), reference: 1, dueDate: Value(DateTime(2026, 1, 10)), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: Value('overdueMessageX')), isFalse);
    expect(agreementsQuoteData.copyWith(id: 'idX', condominiumId: 'condominiumIdX', agreementId: Value('agreementIdX'), reference: 1, dueDate: Value(DateTime(2026, 1, 10)), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: Value('overdueMessageX')), isNotNull);
    agreementsQuoteData.copyWithCompanion(AgreementsQuoteTableCompanion());
    agreementsQuoteData.copyWithCompanion(AgreementsQuoteTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', agreementId: Value('agreementId'), reference: 1, dueDate: Value(DateTime(2026, 1, 10)), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: Value('overdueMessage')));
    expect(agreementsQuoteDataNull.toCompanion(true), isNotNull);
    expect(agreementsQuoteDataNull.toColumns(false), isNotEmpty);
    expect(AgreementsQuoteTableCompanion().toString(), contains('AgreementsQuoteTableCompanion'));
    expect(AgreementsQuoteTableCompanion().copyWith(), isNotNull);
    expect(AgreementsQuoteTableCompanion.insert(id: 'id', condominiumId: 'condominiumId', agreementId: Value('agreementId'), reference: 1, dueDate: Value(DateTime(2026, 1, 10)), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: Value('overdueMessage')).toColumns(true), isNotEmpty);
    expect(AgreementsQuoteTableCompanion.custom(id: Variable<String>('id'), condominiumId: Variable<String>('condominiumId'), agreementId: Variable<String>('agreementId'), reference: Variable<int>(1), dueDate: Variable<DateTime>(DateTime(2026, 1, 10)), originValue: Variable<double>(1.5), fineValue: Variable<double>(1.5), feeValue: Variable<double>(1.5), honoraryValue: Variable<double>(1.5), overdueMessage: Variable<String>('overdueMessage'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AgreementsQuoteTableCompanion.custom().toColumns(true), isEmpty);
    db.agreementsQuoteTable.validateIntegrity(agreementsQuoteData, isInserting: true);
    db.agreementsQuoteTable.validateIntegrity(agreementsQuoteData, isInserting: false);
    db.agreementsQuoteTable.validateIntegrity(AgreementsQuoteTableCompanion(), isInserting: true);
    db.agreementsQuoteTable.validateIntegrity(AgreementsQuoteTableCompanion(), isInserting: false);
    expect(db.agreementsQuoteTable.createAlias('agre_a').aliasedName, isNotEmpty);
    final agreementsQuoteDataF = $$AgreementsQuoteTableTableFilterComposer($db: db, $table: db.agreementsQuoteTable);
    agreementsQuoteDataF.id; agreementsQuoteDataF.condominiumId; agreementsQuoteDataF.agreementId; agreementsQuoteDataF.reference; agreementsQuoteDataF.dueDate; agreementsQuoteDataF.originValue; agreementsQuoteDataF.fineValue; agreementsQuoteDataF.feeValue; agreementsQuoteDataF.honoraryValue; agreementsQuoteDataF.overdueMessage;
    final agreementsQuoteDataO = $$AgreementsQuoteTableTableOrderingComposer($db: db, $table: db.agreementsQuoteTable);
    agreementsQuoteDataO.id; agreementsQuoteDataO.condominiumId; agreementsQuoteDataO.agreementId; agreementsQuoteDataO.reference; agreementsQuoteDataO.dueDate; agreementsQuoteDataO.originValue; agreementsQuoteDataO.fineValue; agreementsQuoteDataO.feeValue; agreementsQuoteDataO.honoraryValue; agreementsQuoteDataO.overdueMessage;
    final agreementsQuoteDataA = $$AgreementsQuoteTableTableAnnotationComposer($db: db, $table: db.agreementsQuoteTable);
    agreementsQuoteDataA.id; agreementsQuoteDataA.condominiumId; agreementsQuoteDataA.agreementId; agreementsQuoteDataA.reference; agreementsQuoteDataA.dueDate; agreementsQuoteDataA.originValue; agreementsQuoteDataA.fineValue; agreementsQuoteDataA.feeValue; agreementsQuoteDataA.honoraryValue; agreementsQuoteDataA.overdueMessage;
    await db.into(db.agreementsQuoteTable).insert(agreementsQuoteData, mode: InsertMode.replace);
    await (db.select(db.agreementsQuoteTable.createAlias('agrx'))).get();
    await db.managers.agreementsQuoteTable.filter((f) {
      f.id;
      f.condominiumId;
      f.agreementId;
      f.reference;
      f.dueDate;
      f.originValue;
      f.fineValue;
      f.feeValue;
      f.honoraryValue;
      f.overdueMessage;
      return f.id.equals('id');
    }).get();
    await db.managers.agreementsQuoteTable.orderBy((o) {
      o.id;
      o.condominiumId;
      o.agreementId;
      o.reference;
      o.dueDate;
      o.originValue;
      o.fineValue;
      o.feeValue;
      o.honoraryValue;
      o.overdueMessage;
      return o.id.asc();
    }).get();
    await db.managers.agreementsQuoteTable.withReferences().get();
    await db.managers.agreementsQuoteTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    final agreementsRulesDaysData = AgreementsRulesDaysData(condominiumId: 'condominiumId', days: 1);
    final agreementsRulesDaysDataNull = AgreementsRulesDaysData(condominiumId: 'condominiumId', days: 1);
    expect(agreementsRulesDaysData == agreementsRulesDaysData.copyWith(condominiumId: 'condominiumIdX', days: 1), isFalse);
    expect(agreementsRulesDaysData.copyWith(condominiumId: 'condominiumIdX', days: 1), isNotNull);
    agreementsRulesDaysData.copyWithCompanion(AgreementsRulesDaysTableCompanion());
    agreementsRulesDaysData.copyWithCompanion(AgreementsRulesDaysTableCompanion.insert(condominiumId: 'condominiumId', days: 1));
    expect(agreementsRulesDaysDataNull.toCompanion(true), isNotNull);
    expect(agreementsRulesDaysDataNull.toColumns(false), isNotEmpty);
    expect(AgreementsRulesDaysTableCompanion().toString(), contains('AgreementsRulesDaysTableCompanion'));
    expect(AgreementsRulesDaysTableCompanion().copyWith(), isNotNull);
    expect(AgreementsRulesDaysTableCompanion.insert(condominiumId: 'condominiumId', days: 1).toColumns(true), isNotEmpty);
    expect(AgreementsRulesDaysTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), days: Variable<int>(1), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AgreementsRulesDaysTableCompanion.custom().toColumns(true), isEmpty);
    db.agreementsRulesDaysTable.validateIntegrity(agreementsRulesDaysData, isInserting: true);
    db.agreementsRulesDaysTable.validateIntegrity(agreementsRulesDaysData, isInserting: false);
    db.agreementsRulesDaysTable.validateIntegrity(AgreementsRulesDaysTableCompanion(), isInserting: true);
    db.agreementsRulesDaysTable.validateIntegrity(AgreementsRulesDaysTableCompanion(), isInserting: false);
    expect(db.agreementsRulesDaysTable.createAlias('agre_a').aliasedName, isNotEmpty);
    final agreementsRulesDaysDataF = $$AgreementsRulesDaysTableTableFilterComposer($db: db, $table: db.agreementsRulesDaysTable);
    agreementsRulesDaysDataF.condominiumId; agreementsRulesDaysDataF.days;
    final agreementsRulesDaysDataO = $$AgreementsRulesDaysTableTableOrderingComposer($db: db, $table: db.agreementsRulesDaysTable);
    agreementsRulesDaysDataO.condominiumId; agreementsRulesDaysDataO.days;
    final agreementsRulesDaysDataA = $$AgreementsRulesDaysTableTableAnnotationComposer($db: db, $table: db.agreementsRulesDaysTable);
    agreementsRulesDaysDataA.condominiumId; agreementsRulesDaysDataA.days;
    await db.into(db.agreementsRulesDaysTable).insert(agreementsRulesDaysData, mode: InsertMode.replace);
    await (db.select(db.agreementsRulesDaysTable.createAlias('agrx'))).get();
    await db.managers.agreementsRulesDaysTable.filter((f) {
      f.condominiumId;
      f.days;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.agreementsRulesDaysTable.orderBy((o) {
      o.condominiumId;
      o.days;
      return o.condominiumId.asc();
    }).get();
    await db.managers.agreementsRulesDaysTable.withReferences().get();
    await db.managers.agreementsRulesDaysTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final agreementsRulesInstallmentsData = AgreementsRulesInstallmentsData(condominiumId: 'condominiumId', installmentQtd: 1);
    final agreementsRulesInstallmentsDataNull = AgreementsRulesInstallmentsData(condominiumId: 'condominiumId', installmentQtd: 1);
    expect(agreementsRulesInstallmentsData == agreementsRulesInstallmentsData.copyWith(condominiumId: 'condominiumIdX', installmentQtd: 1), isFalse);
    expect(agreementsRulesInstallmentsData.copyWith(condominiumId: 'condominiumIdX', installmentQtd: 1), isNotNull);
    agreementsRulesInstallmentsData.copyWithCompanion(AgreementsRulesInstallmentsTableCompanion());
    agreementsRulesInstallmentsData.copyWithCompanion(AgreementsRulesInstallmentsTableCompanion.insert(condominiumId: 'condominiumId', installmentQtd: 1));
    expect(agreementsRulesInstallmentsDataNull.toCompanion(true), isNotNull);
    expect(agreementsRulesInstallmentsDataNull.toColumns(false), isNotEmpty);
    expect(AgreementsRulesInstallmentsTableCompanion().toString(), contains('AgreementsRulesInstallmentsTableCompanion'));
    expect(AgreementsRulesInstallmentsTableCompanion().copyWith(), isNotNull);
    expect(AgreementsRulesInstallmentsTableCompanion.insert(condominiumId: 'condominiumId', installmentQtd: 1).toColumns(true), isNotEmpty);
    expect(AgreementsRulesInstallmentsTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), installmentQtd: Variable<int>(1), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(AgreementsRulesInstallmentsTableCompanion.custom().toColumns(true), isEmpty);
    db.agreementsRulesInstallmentsTable.validateIntegrity(agreementsRulesInstallmentsData, isInserting: true);
    db.agreementsRulesInstallmentsTable.validateIntegrity(agreementsRulesInstallmentsData, isInserting: false);
    db.agreementsRulesInstallmentsTable.validateIntegrity(AgreementsRulesInstallmentsTableCompanion(), isInserting: true);
    db.agreementsRulesInstallmentsTable.validateIntegrity(AgreementsRulesInstallmentsTableCompanion(), isInserting: false);
    expect(db.agreementsRulesInstallmentsTable.createAlias('agre_a').aliasedName, isNotEmpty);
    final agreementsRulesInstallmentsDataF = $$AgreementsRulesInstallmentsTableTableFilterComposer($db: db, $table: db.agreementsRulesInstallmentsTable);
    agreementsRulesInstallmentsDataF.condominiumId; agreementsRulesInstallmentsDataF.installmentQtd;
    final agreementsRulesInstallmentsDataO = $$AgreementsRulesInstallmentsTableTableOrderingComposer($db: db, $table: db.agreementsRulesInstallmentsTable);
    agreementsRulesInstallmentsDataO.condominiumId; agreementsRulesInstallmentsDataO.installmentQtd;
    final agreementsRulesInstallmentsDataA = $$AgreementsRulesInstallmentsTableTableAnnotationComposer($db: db, $table: db.agreementsRulesInstallmentsTable);
    agreementsRulesInstallmentsDataA.condominiumId; agreementsRulesInstallmentsDataA.installmentQtd;
    await db.into(db.agreementsRulesInstallmentsTable).insert(agreementsRulesInstallmentsData, mode: InsertMode.replace);
    await (db.select(db.agreementsRulesInstallmentsTable.createAlias('agrx'))).get();
    await db.managers.agreementsRulesInstallmentsTable.filter((f) {
      f.condominiumId;
      f.installmentQtd;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.agreementsRulesInstallmentsTable.orderBy((o) {
      o.condominiumId;
      o.installmentQtd;
      return o.condominiumId.asc();
    }).get();
    await db.managers.agreementsRulesInstallmentsTable.withReferences().get();
    await db.managers.agreementsRulesInstallmentsTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final resinPeopleData = ResinPeopleData(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role');
    final resinPeopleDataNull = ResinPeopleData(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role');
    expect(resinPeopleData == resinPeopleData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', document: 'documentX', name: 'nameX', role: 'roleX'), isFalse);
    expect(resinPeopleData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', document: 'documentX', name: 'nameX', role: 'roleX'), isNotNull);
    resinPeopleData.copyWithCompanion(ResinPeopleTableCompanion());
    resinPeopleData.copyWithCompanion(ResinPeopleTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role'));
    expect(resinPeopleDataNull.toCompanion(true), isNotNull);
    expect(resinPeopleDataNull.toColumns(false), isNotEmpty);
    expect(ResinPeopleTableCompanion().toString(), contains('ResinPeopleTableCompanion'));
    expect(ResinPeopleTableCompanion().copyWith(), isNotNull);
    expect(ResinPeopleTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role').toColumns(true), isNotEmpty);
    expect(ResinPeopleTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), document: Variable<String>('document'), name: Variable<String>('name'), role: Variable<String>('role'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ResinPeopleTableCompanion.custom().toColumns(true), isEmpty);
    db.resinPeopleTable.validateIntegrity(resinPeopleData, isInserting: true);
    db.resinPeopleTable.validateIntegrity(resinPeopleData, isInserting: false);
    db.resinPeopleTable.validateIntegrity(ResinPeopleTableCompanion(), isInserting: true);
    db.resinPeopleTable.validateIntegrity(ResinPeopleTableCompanion(), isInserting: false);
    expect(db.resinPeopleTable.createAlias('resi_a').aliasedName, isNotEmpty);
    final resinPeopleDataF = $$ResinPeopleTableTableFilterComposer($db: db, $table: db.resinPeopleTable);
    resinPeopleDataF.condominiumId; resinPeopleDataF.id; resinPeopleDataF.document; resinPeopleDataF.name; resinPeopleDataF.role;
    final resinPeopleDataO = $$ResinPeopleTableTableOrderingComposer($db: db, $table: db.resinPeopleTable);
    resinPeopleDataO.condominiumId; resinPeopleDataO.id; resinPeopleDataO.document; resinPeopleDataO.name; resinPeopleDataO.role;
    final resinPeopleDataA = $$ResinPeopleTableTableAnnotationComposer($db: db, $table: db.resinPeopleTable);
    resinPeopleDataA.condominiumId; resinPeopleDataA.id; resinPeopleDataA.document; resinPeopleDataA.name; resinPeopleDataA.role;
    await db.into(db.resinPeopleTable).insert(resinPeopleData, mode: InsertMode.replace);
    await (db.select(db.resinPeopleTable.createAlias('resx'))).get();
    await db.managers.resinPeopleTable.filter((f) {
      f.condominiumId;
      f.id;
      f.document;
      f.name;
      f.role;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.resinPeopleTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.document;
      o.name;
      o.role;
      return o.condominiumId.asc();
    }).get();
    await db.managers.resinPeopleTable.withReferences().get();
    await db.managers.resinPeopleTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final resinBanksData = ResinBanksData(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName');
    final resinBanksDataNull = ResinBanksData(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName');
    expect(resinBanksData == resinBanksData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', bankCode: 'bankCodeX', bankName: 'bankNameX'), isFalse);
    expect(resinBanksData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', bankCode: 'bankCodeX', bankName: 'bankNameX'), isNotNull);
    resinBanksData.copyWithCompanion(ResinBanksTableCompanion());
    resinBanksData.copyWithCompanion(ResinBanksTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName'));
    expect(resinBanksDataNull.toCompanion(true), isNotNull);
    expect(resinBanksDataNull.toColumns(false), isNotEmpty);
    expect(ResinBanksTableCompanion().toString(), contains('ResinBanksTableCompanion'));
    expect(ResinBanksTableCompanion().copyWith(), isNotNull);
    expect(ResinBanksTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName').toColumns(true), isNotEmpty);
    expect(ResinBanksTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), bankCode: Variable<String>('bankCode'), bankName: Variable<String>('bankName'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ResinBanksTableCompanion.custom().toColumns(true), isEmpty);
    db.resinBanksTable.validateIntegrity(resinBanksData, isInserting: true);
    db.resinBanksTable.validateIntegrity(resinBanksData, isInserting: false);
    db.resinBanksTable.validateIntegrity(ResinBanksTableCompanion(), isInserting: true);
    db.resinBanksTable.validateIntegrity(ResinBanksTableCompanion(), isInserting: false);
    expect(db.resinBanksTable.createAlias('resi_a').aliasedName, isNotEmpty);
    final resinBanksDataF = $$ResinBanksTableTableFilterComposer($db: db, $table: db.resinBanksTable);
    resinBanksDataF.condominiumId; resinBanksDataF.id; resinBanksDataF.bankCode; resinBanksDataF.bankName;
    final resinBanksDataO = $$ResinBanksTableTableOrderingComposer($db: db, $table: db.resinBanksTable);
    resinBanksDataO.condominiumId; resinBanksDataO.id; resinBanksDataO.bankCode; resinBanksDataO.bankName;
    final resinBanksDataA = $$ResinBanksTableTableAnnotationComposer($db: db, $table: db.resinBanksTable);
    resinBanksDataA.condominiumId; resinBanksDataA.id; resinBanksDataA.bankCode; resinBanksDataA.bankName;
    await db.into(db.resinBanksTable).insert(resinBanksData, mode: InsertMode.replace);
    await (db.select(db.resinBanksTable.createAlias('resx'))).get();
    await db.managers.resinBanksTable.filter((f) {
      f.condominiumId;
      f.id;
      f.bankCode;
      f.bankName;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.resinBanksTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.bankCode;
      o.bankName;
      return o.condominiumId.asc();
    }).get();
    await db.managers.resinBanksTable.withReferences().get();
    await db.managers.resinBanksTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final resinBankAccountsData = ResinBankAccountsData(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type');
    final resinBankAccountsDataNull = ResinBankAccountsData(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type');
    expect(resinBankAccountsData == resinBankAccountsData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', bankId: 'bankIdX', agency: 'agencyX', accountNumber: 'accountNumberX', document: 'documentX', supplierName: 'supplierNameX', type: 'typeX'), isFalse);
    expect(resinBankAccountsData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', bankId: 'bankIdX', agency: 'agencyX', accountNumber: 'accountNumberX', document: 'documentX', supplierName: 'supplierNameX', type: 'typeX'), isNotNull);
    resinBankAccountsData.copyWithCompanion(ResinBankAccountsTableCompanion());
    resinBankAccountsData.copyWithCompanion(ResinBankAccountsTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type'));
    expect(resinBankAccountsDataNull.toCompanion(true), isNotNull);
    expect(resinBankAccountsDataNull.toColumns(false), isNotEmpty);
    expect(ResinBankAccountsTableCompanion().toString(), contains('ResinBankAccountsTableCompanion'));
    expect(ResinBankAccountsTableCompanion().copyWith(), isNotNull);
    expect(ResinBankAccountsTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type').toColumns(true), isNotEmpty);
    expect(ResinBankAccountsTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), bankId: Variable<String>('bankId'), agency: Variable<String>('agency'), accountNumber: Variable<String>('accountNumber'), document: Variable<String>('document'), supplierName: Variable<String>('supplierName'), type: Variable<String>('type'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ResinBankAccountsTableCompanion.custom().toColumns(true), isEmpty);
    db.resinBankAccountsTable.validateIntegrity(resinBankAccountsData, isInserting: true);
    db.resinBankAccountsTable.validateIntegrity(resinBankAccountsData, isInserting: false);
    db.resinBankAccountsTable.validateIntegrity(ResinBankAccountsTableCompanion(), isInserting: true);
    db.resinBankAccountsTable.validateIntegrity(ResinBankAccountsTableCompanion(), isInserting: false);
    expect(db.resinBankAccountsTable.createAlias('resi_a').aliasedName, isNotEmpty);
    final resinBankAccountsDataF = $$ResinBankAccountsTableTableFilterComposer($db: db, $table: db.resinBankAccountsTable);
    resinBankAccountsDataF.condominiumId; resinBankAccountsDataF.id; resinBankAccountsDataF.bankId; resinBankAccountsDataF.agency; resinBankAccountsDataF.accountNumber; resinBankAccountsDataF.document; resinBankAccountsDataF.supplierName; resinBankAccountsDataF.type;
    final resinBankAccountsDataO = $$ResinBankAccountsTableTableOrderingComposer($db: db, $table: db.resinBankAccountsTable);
    resinBankAccountsDataO.condominiumId; resinBankAccountsDataO.id; resinBankAccountsDataO.bankId; resinBankAccountsDataO.agency; resinBankAccountsDataO.accountNumber; resinBankAccountsDataO.document; resinBankAccountsDataO.supplierName; resinBankAccountsDataO.type;
    final resinBankAccountsDataA = $$ResinBankAccountsTableTableAnnotationComposer($db: db, $table: db.resinBankAccountsTable);
    resinBankAccountsDataA.condominiumId; resinBankAccountsDataA.id; resinBankAccountsDataA.bankId; resinBankAccountsDataA.agency; resinBankAccountsDataA.accountNumber; resinBankAccountsDataA.document; resinBankAccountsDataA.supplierName; resinBankAccountsDataA.type;
    await db.into(db.resinBankAccountsTable).insert(resinBankAccountsData, mode: InsertMode.replace);
    await (db.select(db.resinBankAccountsTable.createAlias('resx'))).get();
    await db.managers.resinBankAccountsTable.filter((f) {
      f.condominiumId;
      f.id;
      f.bankId;
      f.agency;
      f.accountNumber;
      f.document;
      f.supplierName;
      f.type;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.resinBankAccountsTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.bankId;
      o.agency;
      o.accountNumber;
      o.document;
      o.supplierName;
      o.type;
      return o.condominiumId.asc();
    }).get();
    await db.managers.resinBankAccountsTable.withReferences().get();
    await db.managers.resinBankAccountsTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final resinRefundsData = ResinRefundsData(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requestDate: DateTime(2026, 1, 10), requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', description: 'description', canEdit: true, canCancel: true, inconcistency: 'inconcistency');
    final resinRefundsDataNull = ResinRefundsData(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', canEdit: true, canCancel: true, inconcistency: 'inconcistency');
    expect(resinRefundsData == resinRefundsData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', destinationAccountId: 'destinationAccountIdX', requestDate: Value(DateTime(2026, 1, 10)), requester: 'requesterX', status: 'statusX', type: 'typeX', value: 1.5, protocol: 'protocolX', description: Value('descriptionX'), canEdit: true, canCancel: true, inconcistency: 'inconcistencyX'), isFalse);
    expect(resinRefundsData.copyWith(condominiumId: 'condominiumIdX', id: 'idX', destinationAccountId: 'destinationAccountIdX', requestDate: Value(DateTime(2026, 1, 10)), requester: 'requesterX', status: 'statusX', type: 'typeX', value: 1.5, protocol: 'protocolX', description: Value('descriptionX'), canEdit: true, canCancel: true, inconcistency: 'inconcistencyX'), isNotNull);
    resinRefundsData.copyWithCompanion(ResinRefundsTableCompanion());
    resinRefundsData.copyWithCompanion(ResinRefundsTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requestDate: Value(DateTime(2026, 1, 10)), requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', description: Value('description'), canEdit: true, canCancel: true, inconcistency: 'inconcistency'));
    expect(resinRefundsDataNull.toCompanion(true), isNotNull);
    expect(resinRefundsDataNull.toColumns(false), isNotEmpty);
    expect(ResinRefundsTableCompanion().toString(), contains('ResinRefundsTableCompanion'));
    expect(ResinRefundsTableCompanion().copyWith(), isNotNull);
    expect(ResinRefundsTableCompanion.insert(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requestDate: Value(DateTime(2026, 1, 10)), requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', description: Value('description'), canEdit: true, canCancel: true, inconcistency: 'inconcistency').toColumns(true), isNotEmpty);
    expect(ResinRefundsTableCompanion.custom(condominiumId: Variable<String>('condominiumId'), id: Variable<String>('id'), destinationAccountId: Variable<String>('destinationAccountId'), requestDate: Variable<DateTime>(DateTime(2026, 1, 10)), requester: Variable<String>('requester'), status: Variable<String>('status'), type: Variable<String>('type'), value: Variable<double>(1.5), protocol: Variable<String>('protocol'), description: Variable<String>('description'), canEdit: Variable<bool>(true), canCancel: Variable<bool>(true), inconcistency: Variable<String>('inconcistency'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(ResinRefundsTableCompanion.custom().toColumns(true), isEmpty);
    db.resinRefundsTable.validateIntegrity(resinRefundsData, isInserting: true);
    db.resinRefundsTable.validateIntegrity(resinRefundsData, isInserting: false);
    db.resinRefundsTable.validateIntegrity(ResinRefundsTableCompanion(), isInserting: true);
    db.resinRefundsTable.validateIntegrity(ResinRefundsTableCompanion(), isInserting: false);
    expect(db.resinRefundsTable.createAlias('resi_a').aliasedName, isNotEmpty);
    final resinRefundsDataF = $$ResinRefundsTableTableFilterComposer($db: db, $table: db.resinRefundsTable);
    resinRefundsDataF.condominiumId; resinRefundsDataF.id; resinRefundsDataF.destinationAccountId; resinRefundsDataF.requestDate; resinRefundsDataF.requester; resinRefundsDataF.status; resinRefundsDataF.type; resinRefundsDataF.value; resinRefundsDataF.protocol; resinRefundsDataF.description; resinRefundsDataF.canEdit; resinRefundsDataF.canCancel; resinRefundsDataF.inconcistency;
    final resinRefundsDataO = $$ResinRefundsTableTableOrderingComposer($db: db, $table: db.resinRefundsTable);
    resinRefundsDataO.condominiumId; resinRefundsDataO.id; resinRefundsDataO.destinationAccountId; resinRefundsDataO.requestDate; resinRefundsDataO.requester; resinRefundsDataO.status; resinRefundsDataO.type; resinRefundsDataO.value; resinRefundsDataO.protocol; resinRefundsDataO.description; resinRefundsDataO.canEdit; resinRefundsDataO.canCancel; resinRefundsDataO.inconcistency;
    final resinRefundsDataA = $$ResinRefundsTableTableAnnotationComposer($db: db, $table: db.resinRefundsTable);
    resinRefundsDataA.condominiumId; resinRefundsDataA.id; resinRefundsDataA.destinationAccountId; resinRefundsDataA.requestDate; resinRefundsDataA.requester; resinRefundsDataA.status; resinRefundsDataA.type; resinRefundsDataA.value; resinRefundsDataA.protocol; resinRefundsDataA.description; resinRefundsDataA.canEdit; resinRefundsDataA.canCancel; resinRefundsDataA.inconcistency;
    await db.into(db.resinRefundsTable).insert(resinRefundsData, mode: InsertMode.replace);
    await (db.select(db.resinRefundsTable.createAlias('resx'))).get();
    await db.managers.resinRefundsTable.filter((f) {
      f.condominiumId;
      f.id;
      f.destinationAccountId;
      f.requestDate;
      f.requester;
      f.status;
      f.type;
      f.value;
      f.protocol;
      f.description;
      f.canEdit;
      f.canCancel;
      f.inconcistency;
      return f.condominiumId.equals('condominiumId');
    }).get();
    await db.managers.resinRefundsTable.orderBy((o) {
      o.condominiumId;
      o.id;
      o.destinationAccountId;
      o.requestDate;
      o.requester;
      o.status;
      o.type;
      o.value;
      o.protocol;
      o.description;
      o.canEdit;
      o.canCancel;
      o.inconcistency;
      return o.condominiumId.asc();
    }).get();
    await db.managers.resinRefundsTable.withReferences().get();
    await db.managers.resinRefundsTable.filter((f) => f.condominiumId.equals('condominiumId')).update((o) => o(
      condominiumId: Value('condominiumId'),
    ));

    final layoutData = LayoutData(id: 'id', condoId: 'condoId', cod: 'cod', name: 'name', reference: 'reference', primary: 'primary', secondary: 'secondary', logoPath: 'logoPath');
    final layoutDataNull = LayoutData(id: 'id', condoId: 'condoId');
    expect(layoutData == layoutData.copyWith(id: 'idX', condoId: 'condoIdX', cod: Value('codX'), name: Value('nameX'), reference: Value('referenceX'), primary: Value('primaryX'), secondary: Value('secondaryX'), logoPath: Value('logoPathX')), isFalse);
    expect(layoutData.copyWith(id: 'idX', condoId: 'condoIdX', cod: Value('codX'), name: Value('nameX'), reference: Value('referenceX'), primary: Value('primaryX'), secondary: Value('secondaryX'), logoPath: Value('logoPathX')), isNotNull);
    layoutData.copyWithCompanion(LayoutTableCompanion());
    layoutData.copyWithCompanion(LayoutTableCompanion.insert(id: 'id', condoId: 'condoId', cod: Value('cod'), name: Value('name'), reference: Value('reference'), primary: Value('primary'), secondary: Value('secondary'), logoPath: Value('logoPath')));
    expect(layoutDataNull.toCompanion(true), isNotNull);
    expect(layoutDataNull.toColumns(false), isNotEmpty);
    expect(LayoutTableCompanion().toString(), contains('LayoutTableCompanion'));
    expect(LayoutTableCompanion().copyWith(), isNotNull);
    expect(LayoutTableCompanion.insert(id: 'id', condoId: 'condoId', cod: Value('cod'), name: Value('name'), reference: Value('reference'), primary: Value('primary'), secondary: Value('secondary'), logoPath: Value('logoPath')).toColumns(true), isNotEmpty);
    expect(LayoutTableCompanion.custom(id: Variable<String>('id'), condoId: Variable<String>('condoId'), cod: Variable<String>('cod'), name: Variable<String>('name'), reference: Variable<String>('reference'), primary: Variable<String>('primary'), secondary: Variable<String>('secondary'), logoPath: Variable<String>('logoPath'), rowid: Variable<int>(1)).toColumns(true), isNotEmpty);
    expect(LayoutTableCompanion.custom().toColumns(true), isEmpty);
    db.layoutTable.validateIntegrity(layoutData, isInserting: true);
    db.layoutTable.validateIntegrity(layoutData, isInserting: false);
    db.layoutTable.validateIntegrity(LayoutTableCompanion(), isInserting: true);
    db.layoutTable.validateIntegrity(LayoutTableCompanion(), isInserting: false);
    expect(db.layoutTable.createAlias('layo_a').aliasedName, isNotEmpty);
    final layoutDataF = $$LayoutTableTableFilterComposer($db: db, $table: db.layoutTable);
    layoutDataF.id; layoutDataF.condoId; layoutDataF.cod; layoutDataF.name; layoutDataF.reference; layoutDataF.primary; layoutDataF.secondary; layoutDataF.logoPath;
    final layoutDataO = $$LayoutTableTableOrderingComposer($db: db, $table: db.layoutTable);
    layoutDataO.id; layoutDataO.condoId; layoutDataO.cod; layoutDataO.name; layoutDataO.reference; layoutDataO.primary; layoutDataO.secondary; layoutDataO.logoPath;
    final layoutDataA = $$LayoutTableTableAnnotationComposer($db: db, $table: db.layoutTable);
    layoutDataA.id; layoutDataA.condoId; layoutDataA.cod; layoutDataA.name; layoutDataA.reference; layoutDataA.primary; layoutDataA.secondary; layoutDataA.logoPath;
    await db.into(db.layoutTable).insert(layoutData, mode: InsertMode.replace);
    await (db.select(db.layoutTable.createAlias('layx'))).get();
    await db.managers.layoutTable.filter((f) {
      f.id;
      f.condoId;
      f.cod;
      f.name;
      f.reference;
      f.primary;
      f.secondary;
      f.logoPath;
      return f.id.equals('id');
    }).get();
    await db.managers.layoutTable.orderBy((o) {
      o.id;
      o.condoId;
      o.cod;
      o.name;
      o.reference;
      o.primary;
      o.secondary;
      o.logoPath;
      return o.id.asc();
    }).get();
    await db.managers.layoutTable.withReferences().get();
    await db.managers.layoutTable.filter((f) => f.id.equals('id')).update((o) => o(
      id: Value('id'),
    ));

    expect(db.managers.pendencyTable, isNotNull);
  });

  test('DAOs inserem, listam, filtram e limpam', () async {
    final when = DateTime(2026, 1, 10);
    await db.pendencyDao.insertPendencies([PendencyData(condominiumId: 'c1', id: 'p1', title: 't', message: 'm', date: when, type: 't', senderId: 's', senderName: 'n', senderPicture: 'pic', module: 'mod')]);
    expect(await db.pendencyDao.listPendencies('c1'), isNotEmpty);
    await db.pendencyDao.deletePendencies('c1');
    await db.pendencyDao.insertPendencies([PendencyData(condominiumId: 'c1', id: 'p1', type: 't', senderId: 's')]);
    await db.pendencyDao.clearPendencies();

    await db.meDao.insert(MeData(name: 'n', email: 'e', cpf: 'c', phone: 'p', picture: 'pic', pictureHash: 'h'));
    expect(await db.meDao.get(), isNotNull);
    await db.meDao.clear();
    await db.meDao.insert(MeData(name: 'n', email: 'e'));

    await db.condominiumDao.insert([CondominiumData(id: 'c1', name: 'n', address: 'a', reference: 'r', useFacialBiometric: true, managerAccessControlBiometricStatus: 'ok', notificationContext: 'ctx')]);
    expect(await db.condominiumDao.list(), isNotEmpty);
    await db.condominiumDao.clear();
    await db.condominiumDao.insert([CondominiumData(id: 'c1', name: 'n', address: 'a', reference: 'r', useFacialBiometric: false, managerAccessControlBiometricStatus: 'ok', notificationContext: 'ctx')]);

    await db.accountDao.insert([AccountData(id: 'a1', number: 'n', name: 'n', condominiumId: 'c1')]);
    expect(await db.accountDao.list('c1'), isNotEmpty);
    await db.accountDao.clear();

    await db.unitDao.insertUnits([UnitData(id: 'u1', title: 't', group: 'g', residentCount: 1, condominiumId: 'c1', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'ok', usesApp: true, fixedPhone: 'f', mobilePhone: 'm', lastUpdated: when)]);
    expect(await db.unitDao.listUnits('c1'), isNotEmpty);
    await db.unitDao.deleteUnits('c1');
    await db.unitDao.insertUnits([UnitData(id: 'u1', title: 't', residentCount: 1, condominiumId: 'c1', vehicleCount: 0, adimplente: false, agreement: false, billingStatus: 'ok', usesApp: false, fixedPhone: 'f', mobilePhone: 'm', lastUpdated: when)]);
    await db.unitDao.clearUnits();

    await db.residentDao.insertResidents([ResidentData(id: 'r1', name: 'n', cpf: 'c', unitId: 'u1', unitTitle: 't', unitGroup: 'g', unitResidentCount: 1, condominiumId: 'c1')]);
    expect(await db.residentDao.listResidents('c1'), isNotEmpty);
    await db.residentDao.deleteResidents('c1');
    await db.residentDao.clearResidents();

    await db.incomeDao.insert(IncomeData(condominiumId: 'c1', value: 1.5, year: 2026, month: 1));
    await db.incomeDao.insertShares([IncomeShareData(condominiumId: 'c1', year: 2026, month: 1, title: 't', total: 1, share: 1.5, color: 'c')]);
    await db.incomeDao.insertForecast([IncomeForecastData(condominiumId: 'c1', year: 2026, month: 1, forecastPeriod: 'p', forecast: 1.5, value: 1.5)]);
    expect(await db.incomeDao.selectIncome('c1', when), isNotNull);
    expect(await db.incomeDao.selectShares('c1', when), isNotEmpty);
    expect(await db.incomeDao.selectForecast('c1', when), isNotEmpty);
    await db.incomeDao.clear();

    await db.chatContactDao.insert([ChatContactData(id: 'k1', condominiumId: 'c1', unitId: 'u1', unitTitle: 't', unitGroup: 'g', phone: 'p')]);
    expect(await db.chatContactDao.list('c1'), isNotEmpty);
    await db.chatContactDao.clear();

    await db.employeeDao.insert([EmployeeData(condominiumId: 'c1', id: 'e1', name: 'n', dob: when, role: 'r', hiringDate: when, phone: 'p', phone2: 'p2', address: 'a', addressNumber: '1', addressComplement: 'c', salary: 1.5, schooling: 's', status: 'ok')]);
    expect(await db.employeeDao.list('c1'), isNotEmpty);
    await db.employeeDao.clear();

    await db.reservationSummaryDao.insert([ReservationSummaryData(day: when, condominiumId: 'c1', type: 't')]);
    expect(await db.reservationSummaryDao.list('c1', DateTime(2026, 1, 1), DateTime(2026, 1, 31)), isNotEmpty);
    await db.reservationSummaryDao.clear();

    await db.spaceDao.insert([SpaceData(id: 's1', name: 'n', pictureUrl: 'u', condominiumId: 'c1')]);
    expect(await db.spaceDao.list('c1'), isNotEmpty);
    await db.spaceDao.clear();

    await db.condominiumBalanceDao.insert(CondominiumBalanceData(id: 'b1', reference: 'ref', balance: 1.5, previousBalance: 1.5, forecast: 1.5, income: 1.5, expenses: 1.5, date: when, lastUpdatedAt: when));
    expect(await db.condominiumBalanceDao.getCondominiumBalance('ref'), isNotNull);
    await db.condominiumBalanceDao.deleteCondominiumBalance('ref');
    await db.condominiumBalanceDao.insert(CondominiumBalanceData(id: 'b1', reference: 'ref', balance: 1.5, previousBalance: 1.5, forecast: 1.5, income: 1.5, expenses: 1.5, date: when, lastUpdatedAt: when));
    await db.condominiumBalanceDao.clear();

    await db.condominiumBalanceDetailDao.insert(CondominiumBalanceDetailData(reference: 'ref', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, lastUpdatedAt: when));
    expect(await db.condominiumBalanceDetailDao.getCondominiumBalanceDetail('ref'), isNotNull);
    await db.condominiumBalanceDetailDao.deleteCondominiumBalanceDetail('ref');
    await db.condominiumBalanceDetailDao.insert(CondominiumBalanceDetailData(reference: 'ref', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, lastUpdatedAt: when));
    await db.condominiumBalanceDetailDao.clear();

    await db.condominiumBalanceDebitsDao.insert([CondominiumBalanceDebitsData(reference: 'ref', id: 'd1', name: 'n', type: 't', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, period: when)]);
    expect(await db.condominiumBalanceDebitsDao.getCondominiumBalanceDebits('ref'), isNotEmpty);
    await db.condominiumBalanceDebitsDao.deleteCondominiumBalanceDebits('ref');
    await db.condominiumBalanceDebitsDao.clear();

    await db.condominiumBalanceSummaryDao.insert([CondominiumBalanceSummaryData(reference: 'ref', name: 'n', debits: 1.5, credits: 1.5)]);
    expect(await db.condominiumBalanceSummaryDao.getCondominiumBalanceSummary('ref'), isNotEmpty);
    await db.condominiumBalanceSummaryDao.deleteCondominiumBalanceSummary('ref');
    await db.condominiumBalanceSummaryDao.clear();

    await db.agreementsDao.insert(AgreementsData(id: 'ag1', condominiumId: 'c1', reference: 1, unit: 'u', unitOwner: 'o', baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: 'p', status: 's', statusMessage: 'm', expiration: when, proposaldedDate: when, approvalDate: when, dueDate: 1, lastInstallmentDate: when));
    expect(await db.agreementsDao.getAgreements('c1'), isNotEmpty);
    await db.agreementsDao.deleteAgreement('ag1');
    await db.agreementsDao.insert(AgreementsData(id: 'ag1', condominiumId: 'c1', reference: 1, unit: 'u', unitOwner: 'o', baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: 'p', status: 's', statusMessage: 'm', expiration: when, proposaldedDate: when, approvalDate: when, dueDate: 1, lastInstallmentDate: when));
    await db.agreementsDao.deleteCondominiumAgreements('c1');
    await db.agreementsDao.clear();

    await db.agreementsInstallmentsDao.insert(AgreementsInstallmentsData(installmentId: 'i1', condominiumId: 'c1', agreementId: 'ag1', reference: 1, value: 1.5, dueDate: when, status: 's'));
    expect(await db.agreementsInstallmentsDao.getAgreementsInstallments('ag1'), isNotEmpty);
    await db.agreementsInstallmentsDao.deleteInstallment('i1');
    await db.agreementsInstallmentsDao.insert(AgreementsInstallmentsData(installmentId: 'i1', condominiumId: 'c1', agreementId: 'ag1', reference: 1, value: 1.5, dueDate: when, status: 's'));
    await db.agreementsInstallmentsDao.deleteCondominiumInstallments('c1');
    await db.agreementsInstallmentsDao.clear();

    await db.agreementsQuoteDao.insert(AgreementsQuoteData(id: 'q1', condominiumId: 'c1', agreementId: 'ag1', reference: 1, dueDate: when, originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: 'm'));
    expect(await db.agreementsQuoteDao.getAgreementsQuote('ag1'), isNotEmpty);
    await db.agreementsQuoteDao.deleteQuote('q1');
    await db.agreementsQuoteDao.insert(AgreementsQuoteData(id: 'q1', condominiumId: 'c1', agreementId: 'ag1', reference: 1, dueDate: when, originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: 'm'));
    await db.agreementsQuoteDao.deleteCondominiumQuotes('c1');
    await db.agreementsQuoteDao.clear();

    await db.agreementsRulesDaysDao.insert(AgreementsRulesDaysData(condominiumId: 'c1', days: 1));
    expect(await db.agreementsRulesDaysDao.getAgreementsRulesDays('c1'), isNotEmpty);
    await db.agreementsRulesDaysDao.deleteAgreementsRulesDays('c1');
    await db.agreementsRulesDaysDao.clear();

    await db.agreementsRulesInstallmentsDao.insert(AgreementsRulesInstallmentsData(condominiumId: 'c1', installmentQtd: 1));
    expect(await db.agreementsRulesInstallmentsDao.getAgreementsRulesInstallments('c1'), isNotNull);
    await db.agreementsRulesInstallmentsDao.deleteAgreementsRulesInstallments('c1');
    await db.agreementsRulesInstallmentsDao.clear();

    await db.resinPeopleDao.insert(ResinPeopleData(condominiumId: 'c1', id: 'rp1', document: 'd', name: 'n', role: 'r'));
    expect(await db.resinPeopleDao.getResinPeople('c1'), isNotEmpty);
    await db.resinPeopleDao.deleteResinPerson('rp1');
    await db.resinPeopleDao.insert(ResinPeopleData(condominiumId: 'c1', id: 'rp1', document: 'd', name: 'n', role: 'r'));
    await db.resinPeopleDao.deleteCondominiumResinPeople('c1');
    await db.resinPeopleDao.clear();

    await db.resinBanksDao.insert(ResinBanksData(condominiumId: 'c1', id: 'rb1', bankCode: '001', bankName: 'b'));
    expect(await db.resinBanksDao.getResinBanks('c1'), isNotEmpty);
    expect(await db.resinBanksDao.getSingleResinBank('c1', 'missing'), isNull);
    await db.resinBanksDao.insert(ResinBanksData(condominiumId: 'c1', id: 'rb1', bankCode: '001', bankName: 'b'));
    expect(await db.resinBanksDao.getSingleResinBank('c1', 'rb1'), isNotNull);
    await db.resinBanksDao.deleteResinBank('rb1');
    await db.resinBanksDao.insert(ResinBanksData(condominiumId: 'c1', id: 'rb1', bankCode: '001', bankName: 'b'));
    await db.resinBanksDao.deleteCondominiumResinBanks('c1');
    await db.resinBanksDao.clear();

    await db.resinBankAccountsDao.insert(ResinBankAccountsData(condominiumId: 'c1', id: 'ra1', bankId: 'rb1', agency: '1', accountNumber: '2', document: 'd', supplierName: 's', type: 't'));
    expect(await db.resinBankAccountsDao.getResinBankAccounts('c1'), isNotEmpty);
    expect(await db.resinBankAccountsDao.getSingleResinBankAccount('ra1'), isNotNull);
    await db.resinBankAccountsDao.deleteResinBankAccount('ra1');
    await db.resinBankAccountsDao.insert(ResinBankAccountsData(condominiumId: 'c1', id: 'ra1', bankId: 'rb1', agency: '1', accountNumber: '2', document: 'd', supplierName: 's', type: 't'));
    await db.resinBankAccountsDao.deleteCondominiumResinBankAccounts('c1');
    await db.resinBankAccountsDao.clear();

    await db.resinRefundsDao.insert(ResinRefundsData(condominiumId: 'c1', id: 'rr1', destinationAccountId: 'ra1', requestDate: when, requester: 'r', status: 's', type: 't', value: 1.5, protocol: 'p', description: 'd', canEdit: true, canCancel: true, inconcistency: 'i'));
    expect(await db.resinRefundsDao.getResinRefunds('c1'), isNotEmpty);
    await db.resinRefundsDao.deleteResinRefund('rr1');
    await db.resinRefundsDao.insert(ResinRefundsData(condominiumId: 'c1', id: 'rr1', destinationAccountId: 'ra1', requestDate: when, requester: 'r', status: 's', type: 't', value: 1.5, protocol: 'p', description: 'd', canEdit: false, canCancel: false, inconcistency: 'i'));
    await db.resinRefundsDao.deleteCondominiumResinRefunds('c1');
    await db.resinRefundsDao.clear();

    await db.layoutDao.insert(LayoutData(id: 'l1', condoId: 'c1', cod: 'c', name: 'n', reference: 'r', primary: 'p', secondary: 's', logoPath: 'x'));
    expect(await db.layoutDao.list(), isNotEmpty);
    await db.layoutDao.clear();

    final hub = LelloHubDao(db);
    await hub.insert(LelloHubData(number: 'h1'));
    expect(await hub.getByNumber('h1'), isNotNull);
    expect(await hub.getByNumber('missing'), isNull);
    await hub.clear();
  });

  test('migration onUpgrade cobre from 1 a 12', () async {
    Future<void> dropCol(String table, String col) async {
      try {
        await db.customStatement('ALTER TABLE $table DROP COLUMN $col');
      } catch (_) {}
    }

    Future<void> dropTables(List<String> tables) async {
      for (final table in tables) {
        await db.customStatement('DROP TABLE IF EXISTS $table');
      }
    }

    const createdLater = [
      'condominium_balance_table',
      'condominium_balance_detail_table',
      'condominium_balance_debits_table',
      'condominium_balance_summary_table',
      'agreements_table',
      'agreements_installments_table',
      'agreements_quote_table',
      'agreements_rules_days_table',
      'agreements_rules_installments_table',
      'resin_bank_accounts_table',
      'resin_banks_table',
      'resin_people_table',
      'resin_refunds_table',
      'layout_table',
    ];

    Future<void> run(int from, Future<void> Function() prepare) async {
      await db.close();
      db = LelloDatabase.forExecutor(NativeDatabase.memory());
      await db.customSelect('SELECT 1').get();
      await prepare();
      try {
        await db.migration.onUpgrade(Migrator(db), from, 13);
      } catch (_) {}
    }

    await run(1, () async {
      await dropCol('condominium_table', 'reference');
      await dropCol('condominium_table', 'notification_context');
      await dropCol('pendency_table', 'module');
      await dropTables(createdLater);
    });
    await run(2, () async {
      await dropCol('condominium_table', 'notification_context');
      await dropCol('pendency_table', 'module');
      await dropTables(createdLater);
    });
    await run(3, () async {
      await dropCol('condominium_table', 'notification_context');
      await dropCol('pendency_table', 'module');
      await dropTables([
        'condominium_balance_detail_table',
        'condominium_balance_debits_table',
        'condominium_balance_summary_table',
        'agreements_table',
        'agreements_installments_table',
        'agreements_quote_table',
        'agreements_rules_days_table',
        'agreements_rules_installments_table',
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(4, () async {
      await dropCol('me_table', 'picture_hash');
      await dropCol('pendency_table', 'module');
      await dropCol('condominium_table', 'notification_context');
      await dropTables([
        'agreements_table',
        'agreements_installments_table',
        'agreements_quote_table',
        'agreements_rules_days_table',
        'agreements_rules_installments_table',
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(5, () async {
      await dropCol('pendency_table', 'module');
      await dropCol('condominium_table', 'notification_context');
      await dropTables([
        'agreements_table',
        'agreements_installments_table',
        'agreements_quote_table',
        'agreements_rules_days_table',
        'agreements_rules_installments_table',
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(6, () async {
      await dropCol('pendency_table', 'module');
      await dropTables([
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(7, () async {
      await dropTables([
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(8, () async {
      await dropCol('condominium_table', 'notification_context');
      await dropTables([
        'resin_bank_accounts_table',
        'resin_banks_table',
        'resin_people_table',
        'resin_refunds_table',
        'layout_table',
      ]);
    });
    await run(9, () async {
      await dropCol('condominium_table', 'use_facial_biometric');
      await dropCol('condominium_table', 'manager_access_control_biometric_status');
      await dropCol('condominium_table', 'notification_context');
      await dropTables(['layout_table']);
    });
    await run(10, () async {
      await dropCol('condominium_table', 'notification_context');
      await dropTables(['layout_table']);
    });
    await run(11, () async {
      await dropCol('condominium_table', 'notification_context');
      await dropTables(['layout_table']);
    });
    await run(12, () async {
      await dropCol('condominium_table', 'notification_context');
    });
  });
}
