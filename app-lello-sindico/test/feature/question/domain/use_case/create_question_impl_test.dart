import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/question/domain/entity/question.dart';
import 'package:lello/feature/question/domain/repository/question_repository.dart';
import 'package:lello/feature/question/domain/use_case/create_question/question_create.dart';
import 'package:lello/feature/question/domain/use_case/create_question/question_create_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  QuestionRepository repository;
  CreateQuestion createQuestion;

  final condominiumId = "3";
  final entity = Question();

  final params =
      CreateQuestionParams(condominiumId: condominiumId, question: entity);

  setUp(() {
    repository = QuestionRepositoryMock();
    createQuestion = CreateQuestionImpl(repository: repository);
  });

  group('call', () {
    group('With invalid params', () {
      test('Should invalid params when param is null', () async {
        final result = await createQuestion.call(null);
        expect(
            result,
            IsAnd<Rejection<Question>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is null', () async {
        final invalid =
            CreateQuestionParams(condominiumId: null, question: null);
        final result = await createQuestion.call(invalid);
        expect(
            result,
            IsAnd<Rejection<Question>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is empty', () async {
        final invalid = CreateQuestionParams(condominiumId: "", question: null);
        final result = await createQuestion.call(invalid);
        expect(
            result,
            IsAnd<Rejection<Question>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when origin is null', () async {
        final invalid =
            CreateQuestionParams(condominiumId: condominiumId, question: null);
        final result = await createQuestion.call(invalid);
        expect(
            result,
            IsAnd<Rejection<Question>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository create', () async {
      when(repository.create(any, any))
          .thenAnswer((_) async => Success(entity));
      await createQuestion.call(params);
      verify(repository.create(entity, condominiumId));
    });

    test('Should return success when repository succeeeds', () async {
      when(repository.create(any, any))
          .thenAnswer((_) async => Success(entity));
      final result = await createQuestion.call(params);
      expect(result, IsAnd<Success<Question>>((it) => it.get() == entity));
    });

    test('Should return rejection when repository succeeeds', () async {
      when(repository.create(any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await createQuestion.call(params);
      expect(result,
          IsAnd<Rejection<Question>>((it) => it.get() is UnknownFailure));
    });
  });
}

class QuestionRepositoryMock extends Mock implements QuestionRepository {}
