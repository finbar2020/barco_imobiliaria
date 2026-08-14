import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class ConsultantController {
  final SessionBloc sessionBloc;
  final ConsultantUseCase getConsultantUseCase;
  final AuthenticationStore authenticationStore;

  ConsultantController({
    required this.getConsultantUseCase,
    required this.sessionBloc,
    required this.authenticationStore,
  });

  ConsultantEntity? consultantEntity;

  Future<void> getConsultant({required bool forceUpdate}) async {
    final remote =
        await getConsultantUseCase(ConsultantParms(condominiumId: '1'));

    remote.fold(
      (error) => FirebaseCrashlytics.instance.recordError(
        error,
        StackTrace.current,
      ),
      (response) {
        consultantEntity = response;
        sessionBloc.getConsultor(response);
      },
    );
  }
}
