import 'package:lello/feature/accountability/presentation/list/bloc/accountability_bloc.dart';
import 'package:lello/feature/accountability/presentation/list/bloc/accountability_event.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/use_case/get_accountability_period/get_accountability_period.dart';

class AccountabilityController {
  final AccountabilityBloc bloc;
  final SessionBloc sessionBloc;
  final GetAccountabilityPeriodUsecase _getAccountabilityPeriodUsecase;

  AccountabilityController({
    required this.bloc,
    required this.sessionBloc,
    required GetAccountabilityPeriodUsecase getAccountabilityPeriodUsecase,
  }) : _getAccountabilityPeriodUsecase = getAccountabilityPeriodUsecase;

  Future<void> getAccountabilityPeriods() async {
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;

    bloc.add(AccountabilityPeriodsLoadingEvent());

    final result = await _getAccountabilityPeriodUsecase(condominiumId);
    result.fold(
      (failure) => bloc.add(
        AccountabilityPeriodsFailedEvent(
          failure: failure,
        ),
      ),
      (data) {
        if (data.isEmpty) {
          return bloc.add(AccountabilityPeriodsEmptyEvent());
        }
        bloc.add(
          AccountabilityPeriodsLoadedEvent(period: data),
        );
      },
    );
  }
}
