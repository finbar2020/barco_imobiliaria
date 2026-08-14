import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/staff_access_management/domain/entity/acess_type_enum.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_bloc.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_event.dart';

class StaffAccessManagementController {
  final StaffAccessManagementBloc bloc;
  final SessionBloc sessionBloc;
  final BuildingManagerUsersCase getBuildingManagerUsersCase;
  final DeactivateNonManagerUserCase deactivateNonManagerUserCase;
  final PutBuildingManagerUserCase putBuildingManagerUserCase;

  List<BuildingManagerUser> activeUsers = [];

  final PostNonUserCase post;

  List<String> accessProfiles = [
    "staff_access_management_full_building_manager",
    "staff_access_management_restricted_building_manager",
    "staff_access_management_full_janitor",
    "staff_access_management_full_janitor_gdp",
    "staff_access_management_restricted_janitor",
  ];
  List<String> genderTypes = [
    "staff_access_management_add_female",
    "staff_access_management_add_male",
  ];

  BuildingManagerUser nonUser = BuildingManagerUser();
  BuildingManagerUser editUser = BuildingManagerUser();

  final Environment env =
      ApplicationContainer.instance().resolve<Environment>();

  StaffAccessManagementController({
    required this.bloc,
    required this.sessionBloc,
    required this.getBuildingManagerUsersCase,
    required this.deactivateNonManagerUserCase,
    required this.post,
    required this.putBuildingManagerUserCase,
  });

  Future<void> getBuildingManagerUsers({
    required CondoUserManageType condoUserManageType,
  }) async {
    bloc.add(LoadingStaffAccessManagementEvent());
    bool haveAccess = sessionBloc.getRemoteConfig()?.getBool(
            CustomFirebaseRemoteConfig.showAccessProfileJanitorWithGDP) ??
        false;
    if (!haveAccess) {
      accessProfiles.remove("staff_access_management_full_janitor_gdp");
    }

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await getBuildingManagerUsersCase(
      BuildingManagerUsersParam(
          condominiumId: condominiumId,
          condoUserManageType: condoUserManageType),
    );
    response.fold(
        (error) => bloc.add(
              FailureNonManagerUserEvent(failure: error),
            ), (response) {
      // Adiciona os usuários com 'isActive' true
      activeUsers = response.where((user) => user.isActive!).toList()
        ..sort((a, b) {
          List<String> extractNames(String fullName) {
            var names = fullName.split(' ');
            return [names.first, names.length > 1 ? names.last : ''];
          }

          var namesA = extractNames(a.name!);
          var namesB = extractNames(b.name!);
          var firstNameComparison = namesA[0].compareTo(namesB[0]);
          if (firstNameComparison != 0) {
            return firstNameComparison;
          }
          return namesA[1].compareTo(namesB[1]);
        });

      return bloc.add(
        LoadedNonManagerUserEvent(buildingManagerUsers: activeUsers),
      );
    });
  }

  Future<void> putBuildingManagerUser() async {
    bloc.add(LoadingStaffAccessManagementEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await putBuildingManagerUserCase.call(
      PutBuildingManagerUserParam(
          model: editUser, condominiumId: condominiumId),
    );

    response.fold((error) {
      var fail = error is ApiResponse
          ? KnownFailure((error as ApiResponse).errorCode ?? "",
              (error as ApiResponse).message,
              message: (error as ApiResponse).message)
          : error;
      bloc.add(
          FailureNonManagerUserEvent(addNonUserError: true, failure: fail));
    }, (r) {
      bloc.add(
        LoadedNonManagerUserEvent(
            buildingManagerUsers: activeUsers, addNonUserSuccess: true),
      );
      editUser = BuildingManagerUser();
    });
  }

  Future<void> deactivateUser({
    required String condominiumId,
    required String userId,
    required bool isActive,
  }) async {
    final response = await deactivateNonManagerUserCase(
      DeactivateNonManagerUserParam(
        condominiumId: condominiumId,
        userId: userId,
        isActive: isActive,
      ),
    );

    response.fold(
        (failure) => bloc.add(FailureNonManagerUserEvent(failure: failure)),
        (success) {
      bloc.add(SuccessNonManagerUserEvent());
    });
  }

  Future<void> postNonUser() async {
    bloc.add(LoadingStaffAccessManagementEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final response = await post.call(
      PostNonUserParam(model: nonUser, condominiumId: condominiumId),
    );

    response.fold((error) {
      var fail = error is ApiResponse
          ? KnownFailure((error as ApiResponse).errorCode ?? "",
              (error as ApiResponse).message,
              message: (error as ApiResponse).message)
          : error;
      bloc.add(
          FailureNonManagerUserEvent(addNonUserError: true, failure: fail));
    }, (r) {
      activeUsers.add(nonUser);
      bloc.add(
        LoadedNonManagerUserEvent(
            buildingManagerUsers: activeUsers, addNonUserSuccess: true),
      );
      nonUser = BuildingManagerUser();
      getBuildingManagerUsers(
          condoUserManageType: CondoUserManageType.otherUsers);
    });
  }

  backToList() {
    bloc.add(LoadedNonManagerUserEvent(buildingManagerUsers: activeUsers));
  }

  String getDisplayName({required String name}) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first} ${nameParts.last}';
    }
    return nameParts.first;
  }

  String getAccessTypeText({required AccessType? accessType}) {
    switch (accessType) {
      case AccessType.fullCondoPresident:
        return 'staff_access_management_full_condo_president';
      case AccessType.fullCondoCouncilMember:
        return 'staff_access_management_full_condo_council_member';
      case AccessType.fullCondoRepresentative:
        return 'staff_access_management_full_condo_representative';
      case AccessType.fullBuildingManager:
        return 'staff_access_management_full_building_manager';
      case AccessType.restrictedBuildingManager:
        return 'staff_access_management_restricted_building_manager';
      case AccessType.fullJanitor:
        return 'staff_access_management_full_janitor';
      case AccessType.fullJanitorGdp:
        return 'staff_access_management_full_janitor_gdp';
      case AccessType.restrictedJanitor:
        return 'staff_access_management_restricted_janitor';
      default:
        return '';
    }
  }

  String? get condominiumId =>
      sessionBloc.state.session?.selectedCondominium?.id ?? "";

  String? get userId => sessionBloc.state.session?.me?.id ?? "";
  AccessType setAccessType({required String accessType}) {
    switch (accessType) {
      case 'staff_access_management_full_condo_president':
        return AccessType.fullCondoPresident;
      case 'staff_access_management_full_condo_council_member':
        return AccessType.fullCondoCouncilMember;
      case 'staff_access_management_full_condo_representative':
        return AccessType.fullCondoRepresentative;
      case 'staff_access_management_full_building_manager':
        return AccessType.fullBuildingManager;
      case 'staff_access_management_restricted_building_manager':
        return AccessType.restrictedBuildingManager;
      case 'staff_access_management_full_janitor':
        return AccessType.fullJanitor;
      case 'staff_access_management_full_janitor_gdp':
        return AccessType.fullJanitorGdp;
      case 'staff_access_management_restricted_janitor':
        return AccessType.restrictedJanitor;
      default:
        return AccessType.fullJanitor;
    }
  }

  String formatCellPhoneNumber({required String number}) {
    String digitsOnly = number.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length == 11) {
      return '(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7, 11)}';
    } else {
      return number;
    }
  }

  String formatCpf({required String cpf}) {
    String digitsOnly = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length == 11) {
      return '${digitsOnly.substring(0, 3)}.${digitsOnly.substring(3, 6)}.${digitsOnly.substring(6, 9)}-${digitsOnly.substring(9, 11)}';
    } else {
      return cpf;
    }
  }
}
