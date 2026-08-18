import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/domain/repository/space_type_repository.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space_impl.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type_impl.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space_impl.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration_impl.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space_impl.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_all_reservations/list_all_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_all_reservations/list_all_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation_impl.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class _FakeSpaceRepo extends Fake implements SpaceRepository {
  Object? last;

  @override
  Future<Try<List<Space>>> list(String condominiumId, DataOrigin origin) async {
    last = origin;
    return Success([Space()..id = 's1'..name = 'Salão']);
  }

  @override
  Future<Try<Space>> insert(String condominiumId, Space space) async {
    last = 'insert';
    return Success(space);
  }

  @override
  Future<Try<Space>> update(String condominiumId, Space space) async {
    last = 'update';
    return Success(space);
  }
}

class _FakeTypeRepo extends Fake implements SpaceTypeRepository {
  @override
  Future<Try<List<SpaceType>>> list(String condominiumId) async =>
      Success([SpaceType()..id = 't1'..description = 'Festa']);
}

class _FakeRequestRepo extends Fake
    implements SpaceRegistrationRequestRepository {
  @override
  Future<Try<SpaceRegistrationRequest>> insert(
          String condominiumId, SpaceRegistrationRequest data) async =>
      Success(data);
}

class _FakeReservationRepo extends Fake implements ReservationRepository {
  Object? last;

  @override
  Future<Try<List<SpaceAvailableHours>>> list(String condominiumId,
      {required String spaceId, String? unitId, required DateTime date}) async {
    last = spaceId;
    return Success([SpaceAvailableHours()..from = '08:00'..until = '09:00']);
  }

  @override
  Future<Try<List<ReservationResponse>>> listAllReservations(
      String condominiumId,
      {DateTime? startDate,
      DateTime? endDate}) async {
    last = condominiumId;
    return Success([ReservationResponse()..id = 1]);
  }

  @override
  Future<Try<String>> insertReservation(String condominiumId,
      ReservationRegistration registration, String unitId) async {
    last = unitId;
    return Success('ok');
  }

  @override
  Future<Try<String>> cancelReservation(
      String condominiumId, String reservationId, String? reservationType) async {
    last = reservationId;
    return Success('cancelled');
  }

  @override
  Future<Try<Unit>> delete(
      String condominiumId, String reservationId, String? reservationType) async {
    last = reservationId;
    return Success(Unit(id: 'u1'));
  }
}

void main() {
  test('ListSpaceImpl e ListSpaceTypeImpl', () async {
    final spaces = _FakeSpaceRepo();
    expect(
      await ListSpaceImpl(repository: spaces)(
        ListSpaceParam(condominiumId: '', origin: DataOrigin.remote),
      ),
      isA<Rejection<List<Space>>>(),
    );
    expect(
      await ListSpaceImpl(repository: spaces)(
        ListSpaceParam(condominiumId: 'c1', origin: DataOrigin.remote),
      ),
      isA<Success<List<Space>>>(),
    );

    expect(
      await ListSpaceTypeImpl(repository: _FakeTypeRepo())(
        ListSpaceTypeParam(condominiumId: 'c1'),
      ),
      isA<Success<List<SpaceType>>>(),
    );
  });

  test('RegisterSpaceImpl e UpdateSpaceImpl', () async {
    final repo = _FakeSpaceRepo();
    final space = Space()..name = 'Salão';
    expect(
      await RegisterSpaceImpl(repository: repo)(
        RegisterSpaceParam(condominiumId: 'c1', space: space),
      ),
      isA<Success<Space>>(),
    );
    expect(
      await UpdateSpaceImpl(repository: repo)(
        UpdateSpaceParam(condominiumId: 'c1', space: space),
      ),
      isA<Success<Space>>(),
    );
    expect(repo.last, 'update');
  });

  test('RequestSpaceRegistrationImpl encaminha o pedido', () async {
    expect(
      await RequestSpaceRegistrationImpl(repository: _FakeRequestRepo())(
        RequestSpaceRegistrationParam(
          condominiumId: 'c1',
          data: SpaceRegistrationRequest()..space = 'Salão',
        ),
      ),
      isA<Success<SpaceRegistrationRequest>>(),
    );
  });

  test('Reservas: listar, cadastrar, cancelar e excluir', () async {
    final repo = _FakeReservationRepo();
    expect(
      await ListReservationImpl(repository: repo)(
        ListReservationParam(
          condominiumId: 'c1',
          spaceId: '',
          date: DateTime(2026, 1, 1),
        ),
      ),
      isA<Rejection<List<SpaceAvailableHours>>>(),
    );
    expect(
      await ListReservationImpl(repository: repo)(
        ListReservationParam(
          condominiumId: 'c1',
          spaceId: 's1',
          date: DateTime(2026, 1, 1),
        ),
      ),
      isA<Success<List<SpaceAvailableHours>>>(),
    );

    expect(
      await ListAllReservationsImpl(repository: repo)(
        ListAllReservationParam(condominiumId: 'c1'),
      ),
      isA<Success<List<ReservationResponse>>>(),
    );

    expect(
      await RegisterReservationImpl(repository: repo)(
        RegisterReservationParam(
          condominiumId: 'c1',
          registration: ReservationRegistration(unitId: 'u1', spaceId: 's1'),
        ),
      ),
      isA<Success<String>>(),
    );

    expect(
      await DeleteReservationImpl(repository: repo)(
        DeleteReservationParam(
          condominiumId: 'c1',
          reservationId: 'r1',
          reservationType: 'NORMAL',
        ),
      ),
      isA<Success<String>>(),
    );

    expect(
      await CancelReservationImpl(repository: repo)(
        CancelReservationParam(condominiumId: 'c1', reservationId: 'r1'),
      ),
      isA<Success<Unit>>(),
    );
  });
}
