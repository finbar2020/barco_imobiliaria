import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/question/data/model/question_model.dart';
import 'package:lello/feature/question/domain/entity/question.dart';
import 'package:lello/feature/question/domain/use_case/create_question/question_create.dart';
import 'package:lello/feature/question/domain/use_case/load_type_question/load_type_question.dart';
import 'package:lello/feature/question/presentation/default/bloc/question_bloc.dart';
import 'package:lello/feature/question/presentation/default/bloc/question_bloc_impl.dart';
import 'package:lello/feature/question/presentation/default/bloc/question_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

void main() {
  QuestionBloc bloc;
  SessionBloc sessionBloc;
  CreateQuestion createQuestion;
  LoadTypeQuestion loadTypes;

  setUp(() {
    sessionBloc = SessionBlocMock();
    final me = Me()..email = "lorem@bacon.com";
    final session = Session()
      ..selectedCondominium = Condominium(id: "123")
      ..me = me;
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));

    createQuestion = CreateQuestionMock();
    loadTypes = CreateLoadTypesMock();
    bloc = QuestionBlocImpl(
        createQuestion: createQuestion,
        sessionBloc: sessionBloc,
        loadTypes: loadTypes);
  });

  group("create", () {
    test("Should call create use case", () async {
      bloc.beginCreate(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          Question());

      await expectLater(
          bloc,
          emitsInOrder([
            isA<QuestionCreatingState>(),
            isA<QuestionSessionLoadState>(),
            isA<QuestionCreatingState>(),
          ]));

      verify(createQuestion.call(any));
    });

    test("Should call create question", () async {
      bloc.beginCreate(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          Question());

      await expectLater(
          bloc,
          emitsInOrder([
            isA<QuestionCreatingState>(),
            isA<QuestionSessionLoadState>(),
            isA<QuestionCreatingState>(),
          ]));
    });

    test("Should emit loaded when create question succeed", () async {
      Question question = Question();
      when(createQuestion.call(any)).thenAnswer((_) async => Success(question));

      bloc.beginCreate(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          Question());

      expect(
          bloc,
          emitsInOrder([
            isA<QuestionCreatingState>(),
            isA<QuestionSessionLoadState>(),
            isA<QuestionCreatingState>(),
            isA<QuestionCreatedState>()
          ]));
    });

    test("Should emit loaded when create question failure", () async {
      when(createQuestion.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc.beginCreate(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          Question());

      expect(
          bloc,
          emitsInOrder([
            isA<QuestionCreatingState>(),
            isA<QuestionSessionLoadState>(),
            isA<QuestionCreatingState>(),
            isA<QuestionCreatingFailedState>(),
          ]));
    });
  });
}

class CreateQuestionMock extends Mock implements CreateQuestion {}

class CreateLoadTypesMock extends Mock implements LoadTypeQuestion {}

class SessionBlocMock extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}
