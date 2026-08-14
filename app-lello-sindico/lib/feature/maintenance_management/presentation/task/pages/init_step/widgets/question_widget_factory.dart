import 'package:flutter/material.dart';
import '../../../../../domain/entity/event_details_entity.dart';
import 'fields/text_question_widget.dart';
import 'fields/textarea_question_widget.dart';
import 'fields/number_question_widget.dart';
import 'fields/radio_question_widget.dart';
import 'fields/file_question_widget.dart';
import 'fields/date_question_widget.dart';
import 'fields/select_question_widget.dart';
import 'fields/checkbox_question_widget.dart';
import 'fields/rating_stars_question_widget.dart';
import 'fields/signature_question_widget.dart';
import 'fields/unsupported_question_widget.dart';

/// Factory para criar widgets dinâmicos baseados no tipo de campo
class QuestionWidgetFactory {
  static Widget create({
    required QuestionEntity question,
    required dynamic currentAnswer,
    required Function(dynamic) onAnswerChanged,
  }) {
    switch (question.fieldType) {
      case 'TEXT':
        return TextQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'TEXTAREA':
        return TextAreaQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'NUMBER':
      case 'DECIMAL':
        return NumberQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
          isDecimal: question.fieldType == 'DECIMAL',
        );

      case 'RADIO':
        return RadioQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'SELECT':
      case 'COMBO_SELECT':
        return SelectQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'CHECKBOX':
        return CheckboxQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as List<String>?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'DATE':
      case 'SCHEDULE':
        return DateQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'FILE':
        return FileQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as List<String>?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'RATING_STARS':
        return RatingStarsQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as int?,
          onAnswerChanged: onAnswerChanged,
        );

      case 'SIGNATURE':
        return SignatureQuestionWidget(
          question: question,
          currentAnswer: currentAnswer as String?,
          onAnswerChanged: onAnswerChanged,
        );

      // Campos não implementados ainda
      case 'ASSET':
      case 'LOCAL':
      case 'SECTOR':
      case 'STEP_ANSWERABLE':
      case 'COLLECTION':
      case 'COLLECTIONS':
      default:
        return UnsupportedQuestionWidget(
          question: question,
        );
    }
  }
}
