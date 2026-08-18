import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/staff_access_management/domain/entity/acess_type_enum.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user_impl.dart';

BuildingManagerUser _validUser({String? id}) => BuildingManagerUser(
      id: id,
      cpf: '12345678900',
      gender: 'M',
      birthday: '1990-01-01',
      email: 'a@b.com',
      phone: '11999999999',
      accessType: AccessType.fullJanitor,
    );

class _FakeStaffRepo extends Fake implements StaffAccessManagementRepository {
  Object? last;

  @override
  Future<Try<List<BuildingManagerUser>>> getBuildingManagerUsers(
      String? condominiumId, CondoUserManageType? condoUserManageType) async {
    last = condoUserManageType;
    return Success([_validUser(id: 'u1')]);
  }

  @override
  Future<Try<ApiResponse>> postNonUser(
      BuildingManagerUser nonUser, String condominiumId) async {
    last = nonUser.email;
    return Success(ApiResponse(success: true));
  }

  @override
  Future<Try<ApiResponse>> putBuildingManagerUser(
      BuildingManagerUser buildingManagerUser, String condominiumId) async {
    last = buildingManagerUser.id;
    return Success(ApiResponse(success: true));
  }

  @override
  Future<Try<ApiResponse>> deactivateNonManagerUsers(
      String condominiumId, String userId, bool isActive) async {
    last = isActive;
    return Success(ApiResponse(success: true));
  }
}

void main() {
  test('BuildingManagerUsersCaseImpl lista usuários do condomínio', () async {
    final repo = _FakeStaffRepo();
    final result = await BuildingManagerUsersCaseImpl(repository: repo)(
      BuildingManagerUsersParam(
        condominiumId: 'c1',
        condoUserManageType: CondoUserManageType.otherUsers,
      ),
    );
    expect(result, isA<Success<List<BuildingManagerUser>>>());
    expect(repo.last, CondoUserManageType.otherUsers);
    expect(CondoUserManageType.executiveBody.toFormatString(), 'executiveBody');
    expect(CondoUserManageType.otherUsers.toFormatString(), 'otherUsers');
  });

  test('PostNonUserCaseImpl valida campos obrigatórios', () async {
    final repo = _FakeStaffRepo();
    expect(
      await PostNonUserCaseImpl(repository: repo)(
        PostNonUserParam(model: _validUser(), condominiumId: ''),
      ),
      isA<Rejection<ApiResponse>>(),
    );
    expect(
      await PostNonUserCaseImpl(repository: repo)(
        PostNonUserParam(
          model: BuildingManagerUser(cpf: '', accessType: AccessType.fullJanitor),
          condominiumId: 'c1',
        ),
      ),
      isA<Rejection<ApiResponse>>(),
    );
    expect(
      await PostNonUserCaseImpl(repository: repo)(
        PostNonUserParam(model: _validUser(), condominiumId: 'c1'),
      ),
      isA<Success<ApiResponse>>(),
    );
  });

  test('PutBuildingManagerUserCaseImpl exige tipo de acesso', () async {
    final repo = _FakeStaffRepo();
    expect(
      await PutBuildingManagerUserCaseImpl(repository: repo)(
        PutBuildingManagerUserParam(
          model: BuildingManagerUser(id: 'u1'),
          condominiumId: 'c1',
        ),
      ),
      isA<Rejection<ApiResponse>>(),
    );
    expect(
      await PutBuildingManagerUserCaseImpl(repository: repo)(
        PutBuildingManagerUserParam(
          model: _validUser(id: 'u1'),
          condominiumId: 'c1',
        ),
      ),
      isA<Success<ApiResponse>>(),
    );
    expect(repo.last, 'u1');
  });

  test('DeactivateNonManagerUserCaseImpl valida ids', () async {
    final repo = _FakeStaffRepo();
    expect(
      await DeactivateNonManagerUserCaseImpl(repository: repo)(
        DeactivateNonManagerUserParam(
          condominiumId: '',
          userId: 'u1',
          isActive: false,
        ),
      ),
      isA<Rejection<void>>(),
    );
    expect(
      await DeactivateNonManagerUserCaseImpl(repository: repo)(
        DeactivateNonManagerUserParam(
          condominiumId: 'c1',
          userId: 'u1',
          isActive: false,
        ),
      ),
      isA<Success<void>>(),
    );
    expect(repo.last, false);
  });
}
