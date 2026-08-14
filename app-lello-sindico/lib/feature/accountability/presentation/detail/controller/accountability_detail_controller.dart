import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability_usecase.dart';

import '../../../domain/entity/accountability_periods.dart';
import '../../../domain/use_case/approve_recommendation/approve_recommendation_usecase.dart';
import '../bloc/accountability_detail_bloc.dart';
import '../bloc/accountability_detail_event.dart';

class AccountabilityDetailController {
  final AccountabilityDetailBloc bloc;
  final GetAccountabilityUsecase _getAccountabilityUsecase;
  final ApproveRecommendationUsecase _approveRecommendationUsecase;
  AccountabilityDetailController({
    required this.bloc,
    required GetAccountabilityUsecase getAccountabilityUsecase,
    required ApproveRecommendationUsecase approveRecommendationUsecase,
  })  : _getAccountabilityUsecase = getAccountabilityUsecase,
        _approveRecommendationUsecase = approveRecommendationUsecase;

  AccountabilityPeriods? period;

  String? condominiumId;

  Future<void> getAccountabilityList({
    required String condominiumId,
    required AccountabilityPeriods periods,
  }) async {
    bloc.add(AccountabilityDetailLoadingEvent());

    final result = await _getAccountabilityUsecase.call(
      GetAccountabilityParam(
        condominiumId: condominiumId,
        period: periods.period,
      ),
    );
    result.fold(
      (failure) => bloc.add(
        AccountabilityDetailFailedEvent(
          error: failure,
          condominiumId: condominiumId,
          period: periods,
        ),
      ),
      (data) => bloc.add(
        AccountabilityDetailLoadedEvent(
          accountability: data,
          condominiumId: data.condominiumId!,
          period: periods,
        ),
      ),
    );
  }

  Future<void> approveRecommendation({
    required DateTime period,
    required String condominiumId,
  }) async {
    bloc.add(AccountabilitySendRecommendationLoadingEvent());

    final result = await _approveRecommendationUsecase(
      ApproveRecommendationParams(
        period: period,
        condominiumId: condominiumId,
      ),
    );

    result.fold(
      (failure) => bloc.add(
        AccountabilitySendRecommendationFailureEvent(
            message: failure.error.toString()),
      ),
      (data) => bloc.add(AccountabilitySendRecommendationSuccessEvent()),
    );
  }

  void dispose() {
    bloc.add(AccountabilityDetailEmptyEvent());
  }
}
