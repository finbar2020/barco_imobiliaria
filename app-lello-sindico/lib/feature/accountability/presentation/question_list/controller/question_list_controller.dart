// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/use_case/list_doubt/list_doubt_usecase.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_event.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';

class QuestionListController {
  final SessionBloc sessionBloc;
  final ListAccountabilityDoubtUsecase _listAccountabilityDoubtUsecase;
  final QuestionListBloc bloc;
  final String baseUrl;

  QuestionListController({
    required this.sessionBloc,
    required ListAccountabilityDoubtUsecase listAccountabilityDoubtUsecase,
    required this.bloc,
    required this.baseUrl,
  }) : _listAccountabilityDoubtUsecase = listAccountabilityDoubtUsecase;

  Future<void> getQuestionList() async {
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;

    bloc.add(QuestionListLoadingEvent());

    final result = await _listAccountabilityDoubtUsecase(
      ListAccountabilityDoubtParam(
        condominiumId: condominiumId,
        questionSituation: null,
      ),
    );
    result.fold(
      (failure) => bloc.add(QuestionListFailedEvent(error: failure)),
      (data) {
        if (data.isEmpty) {
          return bloc.add(QuestionListEmptyEvent());
        }
        for (var element in data) {
          element.baseUrl = baseUrl;
        }
        bloc.add(QuestionListLoadedEvent(data: data));
      },
    );
  }

  String get codominiumId => sessionBloc.state.session!.selectedCondominium!.id;
}
