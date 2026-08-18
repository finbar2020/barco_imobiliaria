import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:lello/feature/access_management/domain/usecase/check_seventh_service/access_management_check_service.dart';
import 'package:lello/feature/access_management/domain/usecase/check_seventh_service/access_management_check_service_impl.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite_impl.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_recommendation/approve_recommendation_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability_period/get_accountability_period.dart';
import 'package:lello/feature/accountability/domain/use_case/get_question_types/get_question_type_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/list_doubt/list_doubt_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/send_new_question/send_new_question_impl.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/repository/notifications_preferences_repository.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences_impl.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences_impl.dart';

NotificationsPreferences _pref() => NotificationsPreferences(
      reference: 1,
      active: true,
      module: 'payment',
      configType: 'email',
      altText: 'Pagamentos',
      listType: const [NotificationsPreferencesType.email],
    );

class _FakeAccessRepo extends Fake implements AccessManagementRepository {
  Object? last;

  @override
  Future<Try<String>> sendInvite(AccessManagementSendInviteEntity model) async {
    last = model.name;
    return Success('sent');
  }

  @override
  Future<Try<AccessManagementServiceSeventh>> checkSeventhService(
      String reference) async {
    last = reference;
    return Success(AccessManagementServiceSeventh(condominiumActive: true));
  }
}

class _FakeAccountabilityRepo extends Fake
    implements AccountabilityRepository {
  Object? last;

  @override
  Future<Try<Accountability>> select(
      String condominiumId, DateTime period) async {
    last = condominiumId;
    return Success(Accountability()..condominiumId = condominiumId);
  }

  @override
  Future<Try<List<AccountabilityPeriods>>> getPeriod(
      String condominiumId) async {
    last = condominiumId;
    return Success([
      AccountabilityPeriods(
        period: DateTime(2026, 1, 1),
        situation: 'APROVADA',
        approvalDate: DateTime(2026, 1, 10),
      ),
    ]);
  }

  @override
  Future<Try<List<AccountabilityQuestionType>>> listType(
      String condominiumId) async {
    return Success([
      AccountabilityQuestionType(
        id: 't1',
        name: 'Dúvida',
        idCompany: 1,
        idSupervisor: 1,
        idRequestPpc: 1,
      ),
    ]);
  }

  @override
  Future<Try<List<AccountabilityDoubt>>> listDoubt(
      String condominiumId, DoubtSituation? questionSituation) async {
    last = questionSituation;
    return Success([AccountabilityDoubt(period: DateTime(2026, 1, 1))]);
  }

  @override
  Future<Try<AccountabilityDoubt>> sendDoubt(
      String condominiumId, AccountabilityDoubt doubt) async {
    last = condominiumId;
    return Success(doubt);
  }

  @override
  Future<Try<void>> sendRecommendation(
      String condominiumId, DateTime period) async {
    last = condominiumId;
    return Success(null);
  }
}

class _FakeApprovalRepo extends Fake
    implements AccountabilityApprovalRepository {
  @override
  Future<Try<AccountabilityApproval>> insert(
      AccountabilityApproval approval) async {
    return Success(approval..id = 'a1');
  }
}

class _FakePrefsRepo extends Fake
    implements NotificationsPreferencesRepository {
  Object? last;

  @override
  Future<Try<List<NotificationsPreferences>>> getNotificationsPreferences(
      String condominiumId) async {
    last = condominiumId;
    return Success([_pref()]);
  }

  @override
  Future<Try<List<NotificationsPreferences>>> updateNotificationsPreferences(
      String condominiumId, List<NotificationsPreferences> body) async {
    last = body.length;
    return Success(body);
  }
}

void main() {
  test('Acesso: convite e serviço sétimo', () async {
    final repo = _FakeAccessRepo();
    expect(
      await SendInviteUsecaseImpl(repository: repo)(
        SendInviteParam(entity: AccessManagementSendInviteEntity(name: 'Ana')),
      ),
      isA<Success<String>>(),
    );
    expect(
      await AccessManagementCheckServiceCaseImpl(repository: repo)(
        AccessManagementCheckServiceParams(reference: ''),
      ),
      isA<Rejection<AccessManagementServiceSeventh>>(),
    );
    expect(
      await AccessManagementCheckServiceCaseImpl(repository: repo)(
        AccessManagementCheckServiceParams(reference: 'c1'),
      ),
      isA<Success<AccessManagementServiceSeventh>>(),
    );
  });

  test('Prestação de contas: período, tipos, dúvidas e aprovação', () async {
    final repo = _FakeAccountabilityRepo();
    expect(
      await GetAccountabilityUsecase(repository: repo)(
        GetAccountabilityParam(condominiumId: '', period: DateTime(2026, 1)),
      ),
      isA<Rejection<Accountability>>(),
    );
    expect(
      await GetAccountabilityUsecase(repository: repo)(
        GetAccountabilityParam(condominiumId: 'c1', period: DateTime(2026, 1)),
      ),
      isA<Success<Accountability>>(),
    );

    final periods = await GetAccountabilityPeriodUsecase(repository: repo)('c1');
    expect(periods, isA<Success<List<AccountabilityPeriods>>>());
    expect(
      (periods as Success<List<AccountabilityPeriods>>).get().first.isAproved,
      isTrue,
    );

    expect(
      await GetAccountabilityQuestionUsecase(repository: repo)(
        GetAccountabilityQuestionParam(condominiumId: 'c1'),
      ),
      isA<Success<List<AccountabilityQuestionType>>>(),
    );
    expect(
      await ListAccountabilityDoubtUsecase(repository: repo)(
        ListAccountabilityDoubtParam(
          condominiumId: 'c1',
          questionSituation: DoubtSituation.in_progress,
        ),
      ),
      isA<Success<List<AccountabilityDoubt>>>(),
    );

    final doubt = AccountabilityDoubt(period: DateTime(2026, 1, 1));
    expect(doubt.questionSituationText.isNotEmpty, isTrue);
    expect(
      await SendAccountabilityQuestionUsecase(repository: repo)(
        SendAccountabilityQuestionParam(doubt: doubt, condominiumId: 'c1'),
      ),
      isA<Success<AccountabilityDoubt>>(),
    );

    expect(
      await ApproveRecommendationUsecase(repository: repo)(
        ApproveRecommendationParams(
          condominiumId: 'c1',
          period: DateTime(2026, 1, 1),
        ),
      ),
      isA<Success<void>>(),
    );
    expect(
      await ApproveAccountabilityUsecase(repository: _FakeApprovalRepo())(
        Accountability(),
      ),
      isA<Success<AccountabilityApproval>>(),
    );
  });

  test('Preferências de notificação: get e update', () async {
    final repo = _FakePrefsRepo();
    expect(
      await GetNotificationsPreferencesUseCaseImpl(repository: repo)(
        GetNotificationsPreferencesParam(condoId: ''),
      ),
      isA<Rejection<List<NotificationsPreferences>>>(),
    );
    expect(
      await GetNotificationsPreferencesUseCaseImpl(repository: repo)(
        GetNotificationsPreferencesParam(condoId: 'c1'),
      ),
      isA<Success<List<NotificationsPreferences>>>(),
    );
    expect(
      await UpdateNotificationsPreferencesImpl(repository: repo)(
        UpdateNotificationsPreferencesParam(
          condominiumId: 'c1',
          notificationsPreferences: [_pref()],
        ),
      ),
      isA<Success<List<NotificationsPreferences>>>(),
    );
  });
}
