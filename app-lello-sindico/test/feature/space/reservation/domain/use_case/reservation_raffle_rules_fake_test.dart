import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_summary_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_time_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle_impl.dart';

class _FakeReservationRepo extends Fake implements ReservationRepository {
  Object? last;

  @override
  Future<Try<ReservationRaffleDetail>> selectRaffleDetail(
      String condominiumId, String spaceId, String reservationId) async {
    last = reservationId;
    return Success(ReservationRaffleDetail());
  }

  @override
  Future<Try<Reservation>> insertRaffle(String condominiumId,
      ReservationRegistration registration, ReservationRaffleData data) async {
    last = condominiumId;
    return Success(Reservation()..id = 'raffle-1');
  }

  @override
  Future<Try<ReservationRaffleResult>> insertRaffleExecution(
      String condominiumId, String spaceId, String reservationId) async {
    last = spaceId;
    return Success(ReservationRaffleResult());
  }

  @override
  Future<Try<Reservation>> insertMaintenance(
      String condominiumId, ReservationRegistration registration) async {
    last = registration.spaceId;
    return Success(Reservation()..id = 'maint-1');
  }
}

class _FakeRuleRepo extends Fake implements ReservationRuleRepository {
  Object? last;

  @override
  Future<Try<ReservationRule>> select(String condominiumId, String spaceId) async {
    last = spaceId;
    return Success(ReservationRule());
  }

  @override
  Future<Try<ReservationChangeRules>> getChangeRules(String condominiumId) async {
    last = condominiumId;
    return Success(ReservationChangeRules(idMovingRule: 'rule-1'));
  }

  @override
  Future<Try<String>> postChangeRules(
      String condominiumId, Map<String, dynamic> body) async {
    last = body['days'];
    return Success('ok');
  }
}

class _FakeTimeRepo extends Fake implements ReservationTimeRepository {
  @override
  Future<Try<List<ReservationTime>>> list(
      String condominiumId, String spaceId, DateTime date) async {
    return Success([ReservationTime()..from = date]);
  }
}

class _FakeSummaryRepo extends Fake implements ReservationSummaryRepository {
  @override
  Future<Try<SpaceCalendarResponse>> list(
      String condominiumId,
      String spaceId,
      DateTime periodStart,
      DateTime periodEnd,
      DataOrigin origin) async {
    return Success(SpaceCalendarResponse()..freeToReserveDays = ['2026-01-10']);
  }
}

void main() {
  test('GetRaffleImpl valida ids e devolve o sorteio', () async {
    final repo = _FakeReservationRepo();
    expect(
      await GetRaffleImpl(repository: repo)(
        GetRaffleParam(condominiumId: '', spaceId: 's1', reservationId: 'r1'),
      ),
      isA<Rejection<ReservationRaffleDetail>>(),
    );
    expect(
      await GetRaffleImpl(repository: repo)(
        GetRaffleParam(condominiumId: 'c1', spaceId: 's1', reservationId: 'r1'),
      ),
      isA<Success<ReservationRaffleDetail>>(),
    );
    expect(repo.last, 'r1');
  });

  test('RegisterRaffleImpl e DrawRaffleImpl rejeitam condomínio vazio', () async {
    final repo = _FakeReservationRepo();
    expect(
      await RegisterRaffleImpl(repository: repo)(
        RegisterRaffleParam(
          condominiumId: '',
          registration: ReservationRegistration(spaceId: 's1'),
          data: ReservationRaffleData(),
        ),
      ),
      isA<Rejection<Reservation>>(),
    );
    expect(
      await RegisterRaffleImpl(repository: repo)(
        RegisterRaffleParam(
          condominiumId: 'c1',
          registration: ReservationRegistration(spaceId: 's1'),
          data: ReservationRaffleData(),
        ),
      ),
      isA<Success<Reservation>>(),
    );

    expect(
      await DrawRaffleImpl(repository: repo)(
        DrawRaffleParam(condominiumId: 'c1', reservationId: '', spaceId: 's1'),
      ),
      isA<Rejection<ReservationRaffleResult>>(),
    );
    expect(
      await DrawRaffleImpl(repository: repo)(
        DrawRaffleParam(
          condominiumId: 'c1',
          reservationId: 'r1',
          spaceId: 's1',
        ),
      ),
      isA<Success<ReservationRaffleResult>>(),
    );
  });

  test('RegisterMaintenanceImpl encaminha o espaço', () async {
    final repo = _FakeReservationRepo();
    expect(
      await RegisterMaintenanceImpl(repository: repo)(
        RegisterMaintenanceParam(
          condominiumId: '',
          registration: ReservationRegistration(spaceId: 's1'),
        ),
      ),
      isA<Rejection<Reservation>>(),
    );
    expect(
      await RegisterMaintenanceImpl(repository: repo)(
        RegisterMaintenanceParam(
          condominiumId: 'c1',
          registration: ReservationRegistration(spaceId: 's1'),
        ),
      ),
      isA<Success<Reservation>>(),
    );
    expect(repo.last, 's1');
  });

  test('Regras de reserva: get, alteração e post', () async {
    final repo = _FakeRuleRepo();
    expect(
      await GetReservationRuleImpl(repository: repo)(
        GetReservationRuleParam(condominiumId: 'c1', spaceId: ''),
      ),
      isA<Rejection<ReservationRule>>(),
    );
    expect(
      await GetReservationRuleImpl(repository: repo)(
        GetReservationRuleParam(condominiumId: 'c1', spaceId: 's1'),
      ),
      isA<Success<ReservationRule>>(),
    );

    expect(
      await GetReservationChangeRulesImpl(repository: repo)(
        GetReservationChangeRulesParam(condominiumId: ''),
      ),
      isA<Rejection<ReservationChangeRules>>(),
    );
    expect(
      await GetReservationChangeRulesImpl(repository: repo)(
        GetReservationChangeRulesParam(condominiumId: 'c1'),
      ),
      isA<Success<ReservationChangeRules>>(),
    );

    expect(
      await PostReservationChangeRulesImpl(repository: repo)(
        PostReservationChangeRulesParam(condominiumId: '', body: const {}),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await PostReservationChangeRulesImpl(repository: repo)(
        PostReservationChangeRulesParam(
          condominiumId: 'c1',
          body: const {'days': 2},
        ),
      ),
      isA<Success<String>>(),
    );
    expect(repo.last, 2);
  });

  test('Horários e resumo do calendário de reserva', () async {
    expect(
      await ListReservationTimeImpl(repository: _FakeTimeRepo())(
        ListReservationTimeParam(
          condominiumId: 'c1',
          spaceId: '',
          date: DateTime(2026, 1, 10),
        ),
      ),
      isA<Rejection<List<ReservationTime>>>(),
    );
    expect(
      await ListReservationTimeImpl(repository: _FakeTimeRepo())(
        ListReservationTimeParam(
          condominiumId: 'c1',
          spaceId: 's1',
          date: DateTime(2026, 1, 10),
        ),
      ),
      isA<Success<List<ReservationTime>>>(),
    );

    expect(
      await ListReservationSummaryImpl(repository: _FakeSummaryRepo())(
        ListReservationSummaryParam(
          condominiumId: '',
          spaceId: 's1',
          periodStart: DateTime(2026, 1, 1),
          periodEnd: DateTime(2026, 1, 31),
          origin: DataOrigin.remote,
        ),
      ),
      isA<Rejection<SpaceCalendarResponse>>(),
    );
    expect(
      await ListReservationSummaryImpl(repository: _FakeSummaryRepo())(
        ListReservationSummaryParam(
          condominiumId: 'c1',
          spaceId: 's1',
          periodStart: DateTime(2026, 1, 1),
          periodEnd: DateTime(2026, 1, 31),
          origin: DataOrigin.remote,
        ),
      ),
      isA<Success<SpaceCalendarResponse>>(),
    );
  });
}
