import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/checkbox_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/date_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/file_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/number_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/radio_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/rating_stars_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/select_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/signature_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/text_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/textarea_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/unsupported_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/question_widget_factory.dart';

import '../../../../helpers/question_fixtures.dart';

void main() {
  Widget build(String type, {dynamic answer}) => QuestionWidgetFactory.create(
        question: questionFixture(fieldType: type),
        currentAnswer: answer,
        onAnswerChanged: (_) {},
      );

  test('mapeia cada fieldType para o widget correspondente', () {
    expect(build('TEXT'), isA<TextQuestionWidget>());
    expect(build('TEXTAREA'), isA<TextAreaQuestionWidget>());
    expect(build('NUMBER'), isA<NumberQuestionWidget>());
    expect(build('DECIMAL'), isA<NumberQuestionWidget>());
    expect(build('RADIO'), isA<RadioQuestionWidget>());
    expect(build('SELECT'), isA<SelectQuestionWidget>());
    expect(build('COMBO_SELECT'), isA<SelectQuestionWidget>());
    expect(build('CHECKBOX', answer: <String>[]), isA<CheckboxQuestionWidget>());
    expect(build('DATE'), isA<DateQuestionWidget>());
    expect(build('SCHEDULE'), isA<DateQuestionWidget>());
    expect(build('FILE', answer: <String>[]), isA<FileQuestionWidget>());
    expect(build('RATING_STARS', answer: 3), isA<RatingStarsQuestionWidget>());
    expect(build('SIGNATURE'), isA<SignatureQuestionWidget>());
  });

  test('tipos não suportados caem no UnsupportedQuestionWidget', () {
    for (final type in [
      'ASSET',
      'LOCAL',
      'SECTOR',
      'STEP_ANSWERABLE',
      'COLLECTION',
      'COLLECTIONS',
      'UNKNOWN',
    ]) {
      expect(build(type), isA<UnsupportedQuestionWidget>(), reason: type);
    }
  });
}
