import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/network/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/reservation/data/data_source/reservation_api.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source_impl.dart';
import 'package:morar/feature/reservation/data/model/reservation_model.dart';
import 'package:morar/feature/reservation/data/model/reservation_registration_model.dart';
import 'package:morar/feature/reservation/data/model/reservation_rule_model.dart';
import 'package:morar/feature/reservation/data/model/reservation_scheduled_model.dart';
import 'package:morar/feature/reservation/data/model/space_available_hours_model.dart';
import 'package:morar/feature/reservation/data/model/space_calendar_model.dart';
import 'package:morar/feature/reservation/data/model/space_model.dart';
import 'package:morar/feature/reservation/data/model/space_type_model.dart';
import 'package:morar/feature/reservation/data/repository/reserve_repository_impl.dart';
import 'package:morar/feature/reservation/domain/entity/reservatio_chargin.dart';
import 'package:morar/feature/reservation/domain/entity/reservation.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/entity/space_type.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation_impl.dart';
import 'package:morar/feature/reservation/presentation/controller/reservation_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';

class MockApi extends Mock implements ReservationApi {}

Space space({String id = 's1', String type = 'A', bool chargeable = false, String name = 'Salão'}) => Space()
  ..id = id
  ..name = name
  ..type = (SpaceType()
    ..id = type
    ..description = 'tipo')
  ..capacity = 10
  ..reservationRule = (ReservationRule()
    ..chargeable = chargeable
    ..allDay = false
    ..openHour = 8
    ..closeHour = 22
    ..paymentMethod = chargeable ? 'billet' : null);

ReservationScheduled scheduled({
  int? idStatus = 83,
  ReservationCharging? charging,
  String? type = 'A',
  String start = '10/01/2099 10:00:00',
  String? canCancelUntil,
}) =>
    ReservationScheduled()
      ..id = 1
      ..area = 'churrasqueira'
      ..idStatus = idStatus
      ..flagChargingForm = charging
      ..charginFormDescription = charging
      ..reservationType = type
      ..reservationValue = 150.5
      ..startReservationDate = start
      ..endReservationDate = '10/01/2099 14:00:00'
      ..billetPeriod = DateTime(2099, 1, 5)
      ..flagChargingStatus = 'OPEN'
      ..billetCode = 'code'
      ..canCancelUntil = canCancelUntil;

class _FakeDataSource extends Fake implements ReservationRemoteDataSource {
  _FakeDataSource({this.error});
  final Object? error;
  ReservationRegistrationModel? posted;

  @override
  Future<List<SpaceModel>> getSpaces(String condominiumId) async {
    if (error != null) throw error!;
    return [SpaceModel(id: condominiumId)];
  }

  @override
  Future<SpaceCalendarModel> getCalendar(String condominiumId, String spaceId, DateTime startDate, DateTime endDate) async {
    if (error != null) throw error!;
    return SpaceCalendarModel(lockedDays: ['1']);
  }

  @override
  Future<List<SpaceAvailableHoursModel>> getHours(String condominiumId, String spaceId, DateTime date, String unitId) async {
    if (error != null) throw error!;
    return [SpaceAvailableHoursModel(from: '08', until: '10')];
  }

  @override
  Future<List<ReservationScheduledModel>> getAllReservationsScheduled(String condominiumId, String unitId) async {
    if (error != null) throw error!;
    return [ReservationScheduledModel(id: 1, flagChargingForm: 'BILLET')];
  }

  @override
  Future<ReservationScheduledModel> postReservation(String condominiumId, String spaceId, ReservationRegistrationModel body) async {
    if (error != null) throw error!;
    posted = body;
    return ReservationScheduledModel(id: 2, area: 'x');
  }

  @override
  Future<String> deleteReservation(String condominiumId, String reservationId, String reservationType) async {
    if (error != null) throw error!;
    return 'Sucesso';
  }
}

class _FakeRepository extends Fake implements ReservationRepository {
  final calls = <String>[];
  @override
  Future<Try<List<Space>>> getSpaces(String condominiumId) async {
    calls.add('spaces:$condominiumId');
    return Success([space()]);
  }

  @override
  Future<Try<List<ReservationScheduled>>> getAllReservationScheduled(String condominiumId, String unitId) async {
    calls.add('all:$condominiumId:$unitId');
    return Success([scheduled()]);
  }

  @override
  Future<Try<SpaceCalendarResponse>> getCalendar(String condominiumId, String spaceId, DateTime startDate, DateTime endDate) async {
    calls.add('calendar:$spaceId');
    return Success(SpaceCalendarResponse());
  }

  @override
  Future<Try<List<SpaceAvailableHours>>> getHours(String condominiumId, String spaceId, DateTime date, String unitId) async {
    calls.add('hours:$spaceId');
    return Success(const []);
  }

  @override
  Future<Try<ReservationScheduled>> postReservation(String condominiumId, String spaceId, ReservationRegistration body) async {
    calls.add('post:$spaceId');
    return Success(scheduled());
  }

  @override
  Future<Try<String>> deleteReservation(String condominiumId, String reservationId, String reservationType) async {
    calls.add('delete:$reservationId');
    return Success('ok');
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('entidades', () {
    test('ReservationRule', () {
      final rule = space(chargeable: true).reservationRule;
      expect(rule.isBillet, isTrue);
      expect(rule.isQuota, isFalse);
      expect(rule.isGuarantor, isFalse);
      expect(rule.paymentInfo, 'space_registration_single_bank_slip');
      expect((ReservationRule()..paymentMethod = 'QUOTA').paymentInfo, 'space_registration_fee_billet');
      expect((ReservationRule()..paymentMethod = 'guarantor').paymentInfo, 'space_registration_guarantor');
      expect(ReservationRule().paymentInfo, '');
      expect(rule.workingTime, 'Das 08:00 ás 22:00');
      expect((ReservationRule()..allDay = true).workingTime, 'Dia todo');
      expect(rule.getMaxReservationDate.difference(DateTime.now()).inDays, inInclusiveRange(364, 365));
      expect((ReservationRule()..reservationRangeMaximum = 10).getMaxReservationDate.difference(DateTime.now()).inDays,
          inInclusiveRange(9, 10));
      final min = (ReservationRule()..reservationRangeMinimum = 3).getMinReservationDate;
      expect(min.isUtc, isTrue);
      expect(min.difference(rule.getMinReservationDate).inDays, 3);
      expect(ReservationLimitation.values, hasLength(5));
    });

    test('SpaceType e Space', () {
      final a = SpaceType()..id = 'A';
      expect(a == (SpaceType()..id = 'A'), isTrue);
      expect(a == (SpaceType()..id = 'B'), isFalse);
      expect(SpaceType() == SpaceType(), isFalse);
      expect(a.hashCode, isA<int>());
      expect(Space().reservationRule, isA<ReservationRule>());
    });

    testWidgets('ReservationScheduled', (tester) async {
      final free = scheduled();
      expect(free.diaMes, '10/01');
      expect(free.horaInicial, '10');
      expect(free.horaFinal, '14');
      expect(free.vencimento, DateFormat.yMd().format(DateTime(2099, 1, 5)));
      expect(free.vencidomentoMesDia, DateFormat.Md().format(DateTime(2099, 1, 5)));
      expect(free.tituloReserva, 'churrasqueira');
      expect(free.subTituloReserva, '');
      expect(free.status, 'space_reserved');
      expect(free.color, '#219653');
      expect(free.payment, isTrue);
      expect(free.canCancel, isTrue);
      expect(free.highlight, isFalse);
      expect(free.toString(), contains('area: churrasqueira'));

      final billet = scheduled(charging: ReservationCharging.billet, idStatus: 7620);
      expect(billet.tituloReserva, contains('churrasqueira - R\$'));
      expect(billet.subTituloReserva, startsWith('Vence em '));
      expect(billet.status, 'space_reserved_waiting_payment');
      expect(billet.color, '#E37F22');

      final quota = scheduled(charging: ReservationCharging.quota, idStatus: 7630);
      expect(quota.tituloReserva, 'churrasqueira');
      expect(quota.subTituloReserva, contains('cota condominial'));
      expect(quota.status, 'space_reserved_waiting_raffle');

      expect(scheduled(idStatus: 90).status, 'income_billet_detail_situation_canceled');
      expect(scheduled(idStatus: 90).color, '#FF5341');
      expect(scheduled(idStatus: 90).canCancel, isFalse);
      expect(scheduled(idStatus: null).status, 'income_billet_detail_situation_canceled');
      expect(scheduled(idStatus: 7640).status, 'space_reserved');
      expect(scheduled(idStatus: 1).status, 'income_billet_detail_situation_canceled');
      expect(scheduled(start: '10/01/2000 10:00:00').canCancel, isFalse);
      expect(scheduled(canCancelUntil: '10/01/2000 10:00:00').canCancel, isFalse);
      expect(scheduled(canCancelUntil: '10/01/2098 10:00:00').canCancel, isTrue);

      await pumpApp(tester, const Text('x'), localized: true);
      final context = tester.element(find.text('x'));
      expect(quota.paymentMethodTile(context), 'space_reservation_payment_quota');
      expect(billet.paymentMethodTile(context), 'space_reservation_payment_billet');
      expect(scheduled(charging: ReservationCharging.guarantor).paymentMethodTile(context),
          'space_reservation_payment_guarantor');
      expect(free.paymentMethodTile(context), '');
    });

    test('ReservationRegistration', () {
      final registration = ReservationRegistration(spaceId: 's', unitId: 'u', flagUtilityTerm: true);
      expect(registration.toString(), contains('spaceId: s'));
    });
  });

  group('models', () {
    test('limitation da regra: conversão tolerante', () {
      // Corrigido: `fromEntity` aceita tanto o nome do enum quanto o
      // `toString()` da String guardada na entidade...
      expect(
        ReservationRuleModel.fromEntity(ReservationRule()..limitation = 'day')!
            .limitation,
        'day',
      );
      expect(
        ReservationRuleModel.fromEntity(
                ReservationRule()..limitation = 'ReservationLimitation.month')!
            .limitation,
        'month',
      );
      expect(ReservationRuleModel.fromEntity(ReservationRule())!.limitation, 'none');
      // ...e `toEntity` cai no enum padrão quando vem nulo/desconhecido da API.
      expect(ReservationRuleModel().toEntity().limitation, 'ReservationLimitation.none');
      expect(
        ReservationRuleModel(limitation: 'xpto').toEntity().limitation,
        'ReservationLimitation.none',
      );
      expect(
        ReservationRuleModel(limitation: 'weekDay').toEntity().limitation,
        'ReservationLimitation.weekDay',
      );
    });

    test('SpaceModel round trip com regra e tipo', () {
      final entity = space(chargeable: true)..sharedSpace = space(id: 's2');
      final model = SpaceModel.fromEntity(entity)!;
      final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(json['reservation_rule']['chargeable'], isTrue);
      expect(json['shared_space']['id'], 's2');
      json['reservation_rule']['limitation'] = 'day';
      json['shared_space']['reservation_rule']['limitation'] = 'none';
      final back = SpaceModel.fromJson(json).toEntity();
      expect(back.reservationRule.limitation, 'ReservationLimitation.day');
      expect(back.reservationRule.isBillet, isTrue);
      expect(back.type == entity.type, isTrue);
      expect(back.sharedSpace!.id, 's2');
      expect(SpaceModel.fromEntity(null), isNull);
      expect(SpaceTypeModel.fromEntity(null), isNull);
      expect(ReservationRuleModel.fromEntity(null), isNull);
      expect(SpaceModel().toEntity().reservationRule, isA<ReservationRule>());
      expect(SpaceTypeModel.fromJson({'id': 'A', 'description': 'd'}).toEntity().description, 'd');
      expect(ReservationRuleModel.fromJson({'limitation': 'month', 'percentage_tax': 1.5}).toEntity().percentageTax, 1.5);
    });

    test('ReservationScheduledModel converte enums', () {
      final model = ReservationScheduledModel.fromEntity(scheduled(charging: ReservationCharging.billet))!
        ..billetValue = 1
        ..billetSituation = 'ok';
      final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(json['flag_charging_form'], 'billet');
      final entity = ReservationScheduledModel.fromJson(json).toEntity();
      expect(entity.flagChargingForm, ReservationCharging.billet);
      expect(entity.charginFormDescription, ReservationCharging.billet);
      expect(entity.billetValue, 1);
      expect(ReservationScheduledModel.fromJson({'flag_charging_form': 'QUOTA'}).toEntity().flagChargingForm,
          ReservationCharging.quota);
      expect(ReservationScheduledModel.fromEntity(null), isNull);
    });

    test('demais modelos', () {
      final registration = ReservationRegistrationModel.fromEntity(
          ReservationRegistration(space: space(), flagUtilityTerm: true, unitId: 'u', reservationType: 'A'))!;
      expect(registration.spaceId, 's1');
      expect(registration.toString(), contains('unitId: u'));
      final registrationJson = jsonDecode(jsonEncode(registration.toJson())) as Map<String, dynamic>;
      registrationJson['space']['reservation_rule']['limitation'] = 'day';
      final back = ReservationRegistrationModel.fromJson(registrationJson).toEntity();
      expect(back.space!.id, 's1');
      expect(back.flagUtilityTerm, isTrue);
      expect(ReservationRegistrationModel.fromEntity(null), isNull);

      final calendar = SpaceCalendarModel.fromEntity(SpaceCalendarResponse()..lockedDays = ['1'])!;
      expect(SpaceCalendarModel.fromJson(calendar.toJson()).toEntity().lockedDays, ['1']);
      expect(SpaceCalendarModel.fromEntity(null), isNull);

      final hours = SpaceAvailableHoursModel.fromEntity(SpaceAvailableHours(from: '8', until: '9'))!;
      expect(SpaceAvailableHoursModel.fromJson(hours.toJson()).toEntity().until, '9');
      expect(SpaceAvailableHoursModel.fromEntity(null), isNull);

      final reservation = ReservationModel.fromEntity(Reservation()
        ..id = 'r'
        ..space = space()
        ..price = 2)!;
      final reservationJson = jsonDecode(jsonEncode(reservation.toJson())) as Map<String, dynamic>;
      reservationJson['space']['reservation_rule']['limitation'] = 'day';
      final reservationBack = ReservationModel.fromJson(reservationJson).toEntity();
      expect(reservationBack.space!.id, 's1');
      expect(reservationBack.price, 2);
      expect(ReservationModel.fromEntity(null), isNull);
    });
  });

  test('use cases validam', () async {
    final repo = _FakeRepository();
    Failure? f(Try r) => r.fold((e) => e, (_) => null);
    expect(f(await DeleteReservationImpl(repository: repo)(DeleteReservationParam(condominiumId: '', reservationId: 'r', reservationType: 'A'))), isA<InvalidParamFailure>());
    expect(f(await DeleteReservationImpl(repository: repo)(DeleteReservationParam(condominiumId: 'c', reservationId: '', reservationType: 'A'))), isA<InvalidParamFailure>());
    expect(f(await DeleteReservationImpl(repository: repo)(DeleteReservationParam(condominiumId: 'c', reservationId: 'r', reservationType: ''))), isA<InvalidParamFailure>());
    expect(f(await GetAllReservationImpl(repository: repo)(GetAllReservationParam(condominiumId: '', unitId: 'u'))), isA<InvalidParamFailure>());
    expect(f(await GetAllReservationImpl(repository: repo)(GetAllReservationParam(condominiumId: 'c', unitId: ''))), isA<InvalidParamFailure>());
    expect(f(await GetCalendarImpl(repository: repo)(GetCalendarParam(condominiumId: '', spaceId: 's', startDate: DateTime(2026), endDate: DateTime(2026)))), isA<InvalidParamFailure>());
    expect(f(await GetCalendarImpl(repository: repo)(GetCalendarParam(condominiumId: 'c', spaceId: '', startDate: DateTime(2026), endDate: DateTime(2026)))), isA<InvalidParamFailure>());
    expect(f(await GetHoursImpl(repository: repo)(GetHoursParam(condominiumId: '', spaceId: 's', date: DateTime(2026), unitId: 'u'))), isA<InvalidParamFailure>());
    expect(f(await GetHoursImpl(repository: repo)(GetHoursParam(condominiumId: 'c', spaceId: 's', date: DateTime(2026), unitId: ''))), isA<InvalidParamFailure>());
    expect(f(await GetSpaceImpl(repository: repo)(GetSpaceParam(condominiumId: ''))), isA<InvalidParamFailure>());
    expect(f(await PostReservationImpl(repository: repo)(PostReservationParam(condominiumId: '', spaceId: 's', reservationRegistration: ReservationRegistration()))), isA<InvalidParamFailure>());
    expect(f(await PostReservationImpl(repository: repo)(PostReservationParam(condominiumId: 'c', spaceId: '', reservationRegistration: ReservationRegistration()))), isA<InvalidParamFailure>());

    await DeleteReservationImpl(repository: repo)(DeleteReservationParam(condominiumId: 'c', reservationId: 'r', reservationType: 'A'));
    await GetAllReservationImpl(repository: repo)(GetAllReservationParam(condominiumId: 'c', unitId: 'u'));
    await GetCalendarImpl(repository: repo)(GetCalendarParam(condominiumId: 'c', spaceId: 's', startDate: DateTime(2026), endDate: DateTime(2026)));
    await GetHoursImpl(repository: repo)(GetHoursParam(condominiumId: 'c', spaceId: 's', date: DateTime(2026), unitId: 'u'));
    await GetSpaceImpl(repository: repo)(GetSpaceParam(condominiumId: 'c'));
    await PostReservationImpl(repository: repo)(PostReservationParam(condominiumId: 'c', spaceId: 's', reservationRegistration: ReservationRegistration()));
    expect(repo.calls, ['delete:r', 'all:c:u', 'calendar:s', 'hours:s', 'spaces:c', 'post:s']);
  });

  group('ReservationRepositoryImpl', () {
    test('sucesso', () async {
      final ds = _FakeDataSource();
      final repo = ReservationRepositoryImpl(dataSource: ds);
      expect((await repo.getSpaces('c')).fold((_) => null, (l) => l.single.id), 'c');
      expect((await repo.getCalendar('c', 's', DateTime(2026), DateTime(2026))).fold((_) => null, (c) => c.lockedDays), ['1']);
      expect((await repo.getAllReservationScheduled('c', 'u')).fold((_) => null, (l) => l.single.flagChargingForm),
          ReservationCharging.billet);
      expect((await repo.getHours('c', 's', DateTime(2026), 'u')).fold((_) => null, (l) => l.single.from), '08');
      final posted = await repo.postReservation('c', 's', ReservationRegistration(space: space(), unitId: 'u'));
      expect(posted.fold((_) => null, (r) => r.id), 2);
      expect(ds.posted!.spaceId, 's1');
      expect((await repo.deleteReservation('c', 'r', 'A')).fold((_) => null, (r) => r), 'Sucesso');
    });

    test('406 vira KnownFailure', () async {
      final api406 = ApiFailure.fromJson({'status': 406, 'detail': 'limite'});
      final repo = ReservationRepositoryImpl(dataSource: _FakeDataSource(error: api406));
      expect(((await repo.getHours('c', 's', DateTime(2026), 'u')).fold((f) => f, (_) => null) as KnownFailure).code, 'limite');
      expect(((await repo.postReservation('c', 's', ReservationRegistration())).fold((f) => f, (_) => null) as KnownFailure).code, 'limite');
      final api500 = ApiFailure.fromJson({'status': 500});
      final repo500 = ReservationRepositoryImpl(dataSource: _FakeDataSource(error: api500));
      expect((await repo500.getHours('c', 's', DateTime(2026), 'u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo500.postReservation('c', 's', ReservationRegistration())).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('exceções genéricas', () async {
      final repo = ReservationRepositoryImpl(dataSource: _FakeDataSource(error: Exception('x')));
      expect((await repo.getSpaces('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getCalendar('c', 's', DateTime(2026), DateTime(2026))).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getAllReservationScheduled('c', 'u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getHours('c', 's', DateTime(2026), 'u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.postReservation('c', 's', ReservationRegistration())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.deleteReservation('c', 'r', 'A')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  test('data source formata datas e corpo', () async {
    final api = MockApi();
    registerFallbackValue(<String, dynamic>{});
    final ds = ReservationRemoteDataSourceImpl(api: api);
    when(() => api.getSpaces('c')).thenAnswer((_) async => Response<dynamic>(http.Response(jsonEncode([{'id': 's'}]), 200), null));
    when(() => api.getReservations('c', 'u')).thenAnswer((_) async => Response<dynamic>(http.Response(jsonEncode([{'id': 1}]), 200), null));
    when(() => api.getCalendar('c', 's', '2026-03-05', '2026-11-20')).thenAnswer(
        (_) async => Response<dynamic>(http.Response(jsonEncode({'locked_days': ['x']}), 200), null));
    when(() => api.getHours('c', 's', DateTime(2026, 3, 5), 'u')).thenAnswer(
        (_) async => Response<dynamic>(http.Response(jsonEncode([{'from': 'a', 'until': 'b'}]), 200), null));
    when(() => api.postReservations('c', 's', any())).thenAnswer(
        (_) async => Response<dynamic>(http.Response(jsonEncode({'id': 9}), 200), null));
    when(() => api.deleteReservation('c', 'r', 'A')).thenAnswer((_) async => Response<dynamic>(http.Response('', 200), null));
    when(() => api.deleteReservation('c', 'e', 'A')).thenAnswer((_) async => Response<dynamic>(http.Response('', 500), null, error: 'err'));

    expect((await ds.getSpaces('c')).single.id, 's');
    expect((await ds.getAllReservationsScheduled('c', 'u')).single.id, 1);
    expect((await ds.getCalendar('c', 's', DateTime(2026, 3, 5), DateTime(2026, 11, 20))).lockedDays, ['x']);
    expect((await ds.getHours('c', 's', DateTime(2026, 3, 5), 'u')).single.until, 'b');
    final posted = await ds.postReservation('c', 's', ReservationRegistrationModel(spaceId: 's', unitId: 'u', flagUtilityTerm: true));
    expect(posted.id, 9);
    final body = verify(() => api.postReservations('c', 's', captureAny())).captured.single as Map;
    expect(body['space_id'], 's');
    expect(body['flag_utility_term'], isTrue);
    expect(await ds.deleteReservation('c', 'r', 'A'), 'Sucesso');
    expect(() => ds.deleteReservation('c', 'e', 'A'), throwsA('err'));
  });

  test('ReservationController filtra por tipo', () {
    final controller = ReservationController();
    expect(controller.shouldShowFilter, isFalse);
    controller.spaces = [space(id: 'f'), space(id: 'p', chargeable: true), space(id: 'm', type: 'M')];
    expect(controller.shouldShowFilter, isTrue);
    expect(controller.hasFreeArea, isTrue);
    expect(controller.hasPaidArea, isTrue);
    expect(controller.hasMovingArea, isTrue);
    expect(controller.filteredSpaces.map((s) => s.id), ['f', 'p', 'm']);
    controller.isFreeAreaSelected = true;
    expect(controller.filteredSpaces.map((s) => s.id), ['f']);
    controller.isPaidAreaSelected = true;
    expect(controller.filteredSpaces.map((s) => s.id), ['f', 'p']);
    controller.isFreeAreaSelected = false;
    controller.isPaidAreaSelected = false;
    controller.isMovingAreaSelected = true;
    expect(controller.filteredSpaces.map((s) => s.id), ['m']);
    controller.dispose();
    expect(controller.spaces, isEmpty);
    expect(controller.isMovingAreaSelected, isFalse);
    controller.spaces = [space(id: 'f')];
    expect(controller.shouldShowFilter, isFalse);
  });
}
